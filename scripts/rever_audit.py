#!/usr/bin/env python3
"""
rever_audit.py - APK / APKs Static Analysis, Endpoint & Secret Audit Engine
Part of the Antigravity Framework (#rever / #reverse / #revers)
"""

import sys
import os
import re
import glob
import json
import zipfile
import shutil
import tempfile
import subprocess
import argparse
from urllib.parse import urlparse, parse_qs
from typing import Dict, List, Set, Any, Optional

# Pure XML schema namespaces that are not network endpoints
PURE_SCHEMAS = {
    "schemas.android.com",
    "www.w3.org",
    "xmlpull.org",
}

# Regex patterns for secret detection
SECRET_PATTERNS = {
    "Google API Key": re.compile(r'\bAIza[0-9A-Za-z\-_]{35}\b'),
    "Google App ID (Firebase)": re.compile(r'\b1:\d{8,16}:android:[a-f0-9]{12,40}\b'),
    "AdMob App ID": re.compile(r'\bca-app-pub-\d+~\d+\b'),
    "Firebase URL": re.compile(r'https?://[a-zA-Z0-9_\-]+\.firebaseio\.com'),
    "AWS Access Key ID": re.compile(r'\b(AKIA|ABIA|ACCA|ASIA)[0-9A-Z]{16}\b'),
    "JWT Authentication Token": re.compile(r'\beyJ[a-zA-Z0-9_\-]{10,}\.eyJ[a-zA-Z0-9_\-]{10,}\.[a-zA-Z0-9_\-]+\b'),
    "Bearer Token": re.compile(r'(?i)\bbearer\s+([a-zA-Z0-9_\-\.]{20,})\b'),
    "Generic Private Key": re.compile(r'-----BEGIN (?:RSA |EC |DSA )?PRIVATE KEY-----'),
    "OpenAI / Anthropic API Key": re.compile(r'\bsk-(?:proj-)?[A-Za-z0-9_\-]{30,}\b'),
    "Stripe API Key": re.compile(r'\b(?:sk|pk)_(?:live|test)_[0-9a-zA-Z]{24}\b'),
    "Slack Webhook": re.compile(r'https://hooks\.slack\.com/services/T[a-zA-Z0-9_]+/B[a-zA-Z0-9_]+/[a-zA-Z0-9_]+'),
}

# Regex for clean URLs
URL_REGEX = re.compile(r'https?://[a-zA-Z0-9_\-\.]+\.[a-zA-Z]{2,}(?::\d+)?(?:/[a-zA-Z0-9_\-\./?:%#&=~+@!$,]*)?')

# Regex for Retrofit annotations in Java/Kotlin
RETROFIT_REGEX = re.compile(r'@(GET|POST|PUT|DELETE|PATCH|HEAD|OPTIONS)\s*\(\s*["\']([^"\']+)["\']\s*\)')

# Regex for Java/Kotlin fields holding keys or tokens
CODE_FIELD_SECRET_REGEX = re.compile(
    r'(?i)(?:private\s+|public\s+|protected\s+)?(?:static\s+)?(?:final\s+)?(?:String|val|var|const\s+val)\s+([a-zA-Z0-9_]*(?:token|api_key|apikey|secret|auth|bearer|password|private_key|client_id|app_key)[a-zA-Z0-9_]*)\s*=\s*["\']([^"\']{6,})["\']'
)

# Regex for OkHttp / Ktor header additions
OKHTTP_HEADER_REGEX = re.compile(
    r'(?i)\.(?:addHeader|header|setHeader)\s*\(\s*["\']([^"\']*(?:auth|token|key|secret|bearer)[^"\']*)["\']\s*,\s*["\']([^"\']+)["\']\s*\)'
)

def find_aapt_path() -> str:
    which_path = shutil.which("aapt")
    if which_path:
        return which_path
    sdk_root = os.path.expanduser("~/Library/Android/sdk/build-tools")
    if os.path.exists(sdk_root):
        candidates = sorted(glob.glob(f"{sdk_root}/*/aapt"), reverse=True)
        if candidates:
            return candidates[0]
    return ""

def find_jadx_path() -> str:
    which_path = shutil.which("jadx")
    if which_path:
        return which_path
    for candidate in ["/opt/homebrew/bin/jadx", "/usr/local/bin/jadx", "/usr/bin/jadx"]:
        if os.path.exists(candidate):
            return candidate
    return ""

def get_apk_metadata(apk_path: str) -> Dict[str, str]:
    meta = {
        "package_name": "unknown_package",
        "version_name": "unknown",
        "version_code": "unknown",
        "min_sdk": "unknown",
        "target_sdk": "unknown"
    }
    aapt_bin = find_aapt_path()
    if aapt_bin:
        try:
            res = subprocess.run([aapt_bin, "dump", "badging", apk_path], capture_output=True, text=True, timeout=10)
            stdout = res.stdout
            pkg_m = re.search(r"package:\s*name=[\x27\x22]([^\x27\x22]+)[\x27\x22]", stdout)
            if pkg_m:
                meta["package_name"] = pkg_m.group(1)
            vname_m = re.search(r"versionName=[\x27\x22]([^\x27\x22]+)[\x27\x22]", stdout)
            if vname_m:
                meta["version_name"] = vname_m.group(1)
            vcode_m = re.search(r"versionCode=[\x27\x22]([^\x27\x22]+)[\x27\x22]", stdout)
            if vcode_m:
                meta["version_code"] = vcode_m.group(1)
            min_m = re.search(r"sdkVersion:[\x27\x22]([^\x27\x22]+)[\x27\x22]", stdout)
            if min_m:
                meta["min_sdk"] = min_m.group(1)
            target_m = re.search(r"targetSdkVersion:[\x27\x22]([^\x27\x22]+)[\x27\x22]", stdout)
            if target_m:
                meta["target_sdk"] = target_m.group(1)
            return meta
        except Exception:
            pass

    # Fallback: scan strings in AndroidManifest.xml from zip
    try:
        with zipfile.ZipFile(apk_path, 'r') as zf:
            if "AndroidManifest.xml" in zf.namelist():
                raw = zf.read("AndroidManifest.xml")
                matches = re.findall(rb'([a-zA-Z][a-zA-Z0-9_]+(?:\.[a-zA-Z][a-zA-Z0-9_]+){2,})', raw)
                for m in matches:
                    decoded = m.decode('ascii', errors='ignore')
                    if not decoded.startswith(("android.", "com.android.", "schemas.")):
                        meta["package_name"] = decoded
                        break
    except Exception:
        pass

    if meta["package_name"] == "unknown_package":
        base = os.path.splitext(os.path.basename(apk_path))[0]
        meta["package_name"] = re.sub(r'[^a-zA-Z0-9_.]', '_', base)

    return meta

def normalize_archive(target_path: str, work_dir: str) -> str:
    """Extracts base.apk if target is .apks / .xapk / .zip, otherwise returns target_path."""
    if not os.path.isfile(target_path):
        raise FileNotFoundError(f"Target file not found: {target_path}")

    ext = os.path.splitext(target_path)[1].lower()
    if ext in [".apks", ".xapk", ".zip"]:
        extracted_apks = []
        with zipfile.ZipFile(target_path, 'r') as zf:
            for name in zf.namelist():
                if name.endswith(".apk"):
                    dest = os.path.join(work_dir, os.path.basename(name))
                    with open(dest, "wb") as f_out:
                        f_out.write(zf.read(name))
                    extracted_apks.append(dest)
        
        for apk in extracted_apks:
            if "base" in os.path.basename(apk).lower():
                return apk
        
        if extracted_apks:
            extracted_apks.sort(key=lambda x: os.path.getsize(x), reverse=True)
            return extracted_apks[0]

    return target_path

def scan_resources_and_manifest(apk_path: str) -> Dict[str, Any]:
    """Scans resources.arsc and AndroidManifest.xml for API keys, app IDs, and tokens."""
    findings: Dict[str, str] = {}
    manifest_flags = {"usesCleartextTraffic": False}
    aapt_bin = find_aapt_path()

    if aapt_bin:
        try:
            # 1. Manifest Meta-data & Cleartext traffic
            m_res = subprocess.run([aapt_bin, 'dump', 'xmltree', apk_path, 'AndroidManifest.xml'], capture_output=True, text=True, errors='ignore')
            lines = m_res.stdout.splitlines()
            curr_name = None
            for line in lines:
                if 'usesCleartextTraffic' in line and '0xffffffff' in line.lower():
                    manifest_flags['usesCleartextTraffic'] = True
                if 'android:name' in line:
                    m = re.search(r'android:name\([^)]+\)=[\x27\x22]([^\x27\x22]+)[\x27\x22]', line)
                    if m: curr_name = m.group(1)
                if 'android:value' in line and curr_name:
                    m = re.search(r'android:value\([^)]+\)=[\x27\x22]([^\x27\x22]+)[\x27\x22]', line)
                    if m:
                        val = m.group(1)
                        if any(k in curr_name.lower() for k in ['key', 'token', 'secret', 'id', 'api', 'admob', 'facebook', 'firebase', 'branch', 'appsflyer', 'pangle', 'vungle', 'inmobi']):
                            if not any(noise in val.lower() for noise in ['componentregistrar', 'startup', 'cct', 'initializer']):
                                findings[f"Manifest Meta-data ({curr_name})"] = val
                    curr_name = None

            # 2. Extract string resources from ARSC dump
            r_res = subprocess.run([aapt_bin, 'dump', '--values', 'resources', apk_path], capture_output=True, text=True, errors='ignore')
            matches = re.findall(r'resource\s+0x[0-9a-fA-F]+\s+[^:]+:string/([a-zA-Z0-9_]+):[^\n]+\n\s+\(string(?:8|16)\)\s+[\x27\x22]([^\x27\x22]+)[\x27\x22]', r_res.stdout)
            for name, val in matches:
                nl = name.lower()
                if any(k in nl for k in ['api_key', 'google_api_key', 'google_app_id', 'gcm_defaultsenderid', 'default_web_client_id', 'client_secret', 'app_token', 'facebook_app_id', 'facebook_client_token', 'branch_key', 'onesignal_app_id', 'appsflyer_key', 'crash_reporting_api_key', 'vungle', 'inmobi', 'pangle', 'mbridge']):
                    findings[f"Resource String ({name})"] = val

            # 3. Direct pattern scan across all ARSC dumped strings
            s_res = subprocess.run([aapt_bin, 'dump', 'strings', apk_path], capture_output=True, text=True, errors='ignore')
            for s_name, pat in SECRET_PATTERNS.items():
                for m in pat.findall(s_res.stdout):
                    if isinstance(m, tuple): m = m[0]
                    if m:
                        findings[f"Resource Pool ({s_name})"] = m

        except Exception:
            pass

    # Direct raw zip fallback
    try:
        with zipfile.ZipFile(apk_path, 'r') as zf:
            if 'resources.arsc' in zf.namelist():
                arsc_bytes = zf.read('resources.arsc')
                for s_name, pat in SECRET_PATTERNS.items():
                    for m in pat.findall(arsc_bytes.decode('ascii', errors='ignore')):
                        if isinstance(m, tuple): m = m[0]
                        if m and f"Resource Pool ({s_name})" not in findings:
                            findings[f"Resource Pool ({s_name})"] = m
            if 'AndroidManifest.xml' in zf.namelist():
                m_bytes = zf.read('AndroidManifest.xml')
                if b'usesCleartextTraffic' in m_bytes:
                    manifest_flags['usesCleartextTraffic'] = True
    except Exception:
        pass

    return {
        "secrets": findings,
        "manifest": manifest_flags
    }

def scan_dex_strings(apk_path: str) -> Dict[str, Any]:
    """Scans all classes*.dex raw bytes for URLs and secrets."""
    urls = set()
    secrets: Dict[str, List[str]] = {k: [] for k in SECRET_PATTERNS}

    skip_asset_exts = ('.png', '.jpg', '.jpeg', '.webp', '.gif', '.ttf', '.otf', '.mp3', '.wav', '.ogg', '.pdf')

    with zipfile.ZipFile(apk_path, 'r') as zf:
        for name in zf.namelist():
            is_target = (
                (name.startswith("classes") and name.endswith(".dex")) or
                (name.startswith("assets/") and not name.lower().endswith(skip_asset_exts))
            )
            if is_target:
                dex_bytes = zf.read(name)
                # Decode using latin1 to safely parse byte stream
                text_content = dex_bytes.decode('latin1', errors='ignore')

                # Extract URLs with clean boundary stripping
                for match in URL_REGEX.finditer(text_content):
                    u = match.group(0).rstrip(".,;:'\") \t\r\n\\")
                    if len(u) > 10:
                        urls.add(u)

                # Extract pattern-based secrets
                for s_name, s_pat in SECRET_PATTERNS.items():
                    for m in s_pat.findall(text_content):
                        if isinstance(m, tuple): m = m[0]
                        if m and m not in secrets[s_name]:
                            secrets[s_name].append(m)

    return {
        "urls": sorted(list(urls)),
        "secrets": {k: v for k, v in secrets.items() if v}
    }

def scan_decompiled_code(decompiled_dir: str) -> Dict[str, Any]:
    """Scans Java files generated by JADX for Retrofit, OkHttp headers, and hardcoded secrets."""
    retrofit_endpoints = []
    headers = set()
    code_secrets = {}

    for root, _, files in os.walk(decompiled_dir):
        for file in files:
            if file.endswith((".java", ".kt")):
                file_path = os.path.join(root, file)
                rel_file = os.path.relpath(file_path, decompiled_dir)
                try:
                    with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                        content = f.read()
                        
                        # 1. Retrofit routes
                        matches = RETROFIT_REGEX.findall(content)
                        for method, endpoint in matches:
                            retrofit_endpoints.append({
                                "method": method,
                                "endpoint": endpoint,
                                "source_file": rel_file
                            })
                            
                        # 2. @Headers annotations
                        header_matches = re.findall(r'@Headers\s*\(\s*(\[[^\]]+\]|"[^"]+")\s*\)', content)
                        for h in header_matches:
                            headers.add(h)

                        # 3. OkHttp / Ktor header additions
                        okhttp_matches = OKHTTP_HEADER_REGEX.findall(content)
                        for h_key, h_val in okhttp_matches:
                            code_secrets[f"Code Header: {h_key} ({rel_file})"] = h_val

                        # 4. Code variable fields holding tokens / keys
                        field_matches = CODE_FIELD_SECRET_REGEX.findall(content)
                        for var_name, var_val in field_matches:
                            if not any(noise in var_val.lower() for noise in ['null', 'true', 'false', 'placeholder', 'application/json']):
                                code_secrets[f"Code Variable: {var_name} ({rel_file})"] = var_val

                        # 5. Regex pattern scan across source code
                        for s_name, pat in SECRET_PATTERNS.items():
                            for m in pat.findall(content):
                                if isinstance(m, tuple): m = m[0]
                                if m:
                                    code_secrets[f"Decompiled Source: {s_name} ({rel_file})"] = m

                except Exception:
                    continue

    return {
        "retrofit_endpoints": retrofit_endpoints,
        "headers": sorted(list(headers)),
        "code_secrets": code_secrets
    }

def classify_endpoints(urls: List[str], app_package: str) -> Dict[str, List[str]]:
    """Groups endpoints by Third-Party Provider and App Backend without filtering them out."""
    grouped: Dict[str, List[str]] = {}

    for u in urls:
        p = urlparse(u)
        dom = p.netloc.lower()
        if not dom or any(s in dom for s in PURE_SCHEMAS):
            continue

        if any(k in dom for k in ["pangle", "tiktok", "bytedance"]):
            provider = "TikTok / Pangle SDK"
        elif any(k in dom for k in ["vungle"]):
            provider = "Vungle / Liftoff SDK"
        elif any(k in dom for k in ["inmobi"]):
            provider = "InMobi SDK"
        elif any(k in dom for k in ["facebook", "fb.gg"]):
            provider = "Meta / Facebook SDK"
        elif any(k in dom for k in ["google", "firebase", "crashlytics", "doubleclick", "gstatic", "goo.gle", "goo.gl", "googleapis"]):
            provider = "Google / Firebase / AdMob"
        elif any(k in dom for k in ["appsflyer", "adjust"]):
            provider = "Attribution SDK (AppsFlyer / Adjust)"
        elif any(k in dom for k in ["applovin", "unity3d", "unityads", "mintegral", "mbridge"]):
            provider = "Ad Network SDK (AppLovin / Unity / Mintegral)"
        else:
            provider = "App Backend & Custom Third-Party APIs"

        if provider not in grouped:
            grouped[provider] = []
        if u not in grouped[provider]:
            grouped[provider].append(u)

    return grouped

def run_audit(apk_path: str, deep_scan: bool = True) -> Dict[str, Any]:
    jadx_bin = find_jadx_path()
    with tempfile.TemporaryDirectory() as temp_dir:
        normalized_apk = normalize_archive(apk_path, temp_dir)
        metadata = get_apk_metadata(normalized_apk)
        
        # 1. Scan DEX
        fast_dex_results = scan_dex_strings(normalized_apk)

        # 2. Scan resources.arsc and AndroidManifest.xml
        res_results = scan_resources_and_manifest(normalized_apk)
        
        # 3. Classify all endpoints into Third-Party Providers and Backend
        grouped_endpoints = classify_endpoints(fast_dex_results["urls"], metadata["package_name"])

        retrofit_results = {"retrofit_endpoints": [], "headers": [], "code_secrets": {}}

        # 4. Deep Scan with JADX if available
        if deep_scan and jadx_bin:
            jadx_out = os.path.join(temp_dir, "jadx_decompiled")
            cmd = [jadx_bin, "--no-res", "-d", jadx_out, "-j", "4", normalized_apk]
            try:
                subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=180)
                if os.path.exists(jadx_out):
                    retrofit_results = scan_decompiled_code(jadx_out)
            except Exception:
                pass

        # Merge all discovered secrets from all 3 layers
        combined_secrets: Dict[str, str] = {}
        for k, v in res_results["secrets"].items():
            combined_secrets[k] = v
        for s_type, s_list in fast_dex_results["secrets"].items():
            for idx, val in enumerate(s_list[:5]):
                combined_secrets[f"DEX String Pool: {s_type} #{idx+1}"] = val
        for k, v in retrofit_results["code_secrets"].items():
            combined_secrets[k] = v

        return {
            "target": os.path.abspath(apk_path),
            "normalized_apk": os.path.basename(normalized_apk),
            "metadata": metadata,
            "manifest_flags": res_results["manifest"],
            "grouped_endpoints": grouped_endpoints,
            "secrets": combined_secrets,
            "retrofit_endpoints": retrofit_results["retrofit_endpoints"],
            "custom_headers": retrofit_results["headers"],
            "total_urls_found": len(fast_dex_results["urls"])
        }

def format_markdown_report(data: Dict[str, Any]) -> str:
    meta = data.get("metadata", {})
    pkg_name = meta.get("package_name", "unknown")
    vname = meta.get("version_name", "N/A")
    vcode = meta.get("version_code", "N/A")
    min_sdk = meta.get("min_sdk", "N/A")
    target_sdk = meta.get("target_sdk", "N/A")

    md = []
    md.append(f"# 🛡️ APK Static Audit Report: `{pkg_name}`\n")
    md.append(f"| Metric | Details |")
    md.append(f"| :--- | :--- |")
    md.append(f"| **Package Name** | **`{pkg_name}`** |")
    md.append(f"| **Version** | `{vname}` (Code: `{vcode}`) |")
    md.append(f"| **SDK Support** | Min SDK: `{min_sdk}` · Target SDK: `{target_sdk}` |")
    md.append(f"| **Artifact File** | `{data['normalized_apk']}` (`{data['target']}`) |")
    
    cleartext = "⚠️ ENABLED (Cleartext HTTP allowed)" if data['manifest_flags'].get("usesCleartextTraffic") else "🔒 Enforced HTTPS (Cleartext disallowed)"
    md.append(f"| **Network Security** | {cleartext} |\n")
    
    # Section 1: Secrets & Tokens
    md.append("## 🔑 1. Hardcoded Secrets, Keys & Tokens Found")
    if data["secrets"]:
        md.append(f"Detected **{len(data['secrets'])}** credential entries across Resources, Manifest, DEX and Source Code:\n")
        md.append("| Origin / Secret Type | Detected Value | Severity |")
        md.append("| :--- | :--- | :---: |")
        for s_type, s_val in data["secrets"].items():
            risk = "🔴 High" if any(k in s_type.lower() for k in ['key', 'token', 'secret', 'jwt', 'bearer', 'auth']) else "🟡 Medium"
            md.append(f"| **{s_type}** | `{s_val}` | {risk} |")
    else:
        md.append("✅ *No hardcoded API keys, tokens, or credentials detected.*")
    md.append("")

    # Section 2: Third-Party APIs, SDKs & Network Endpoints
    md.append("## 🔌 2. Third-Party APIs, SDKs & Network Endpoints")
    grouped = data.get("grouped_endpoints", {})
    if grouped:
        for provider, urls in sorted(grouped.items(), key=lambda x: len(x[1]), reverse=True):
            md.append(f"### 🌐 {provider} ({len(urls)} endpoints)")
            md.append("| # | Full Endpoint URL |")
            md.append("| :-: | :--- |")
            for idx, u in enumerate(urls[:25], 1): # Show up to 25 endpoints per provider
                md.append(f"| {idx} | `{u}` |")
            if len(urls) > 25:
                md.append(f"| ... | *(+{len(urls) - 25} more endpoints in this category)* |")
            md.append("")
    else:
        md.append("⚠️ *No network endpoints discovered.*")
    md.append("")

    # Section 3: Declarative Retrofit / Ktor Routes
    md.append("## 📡 3. Discovered Declarative Routes (Retrofit / Ktor)")
    if data["retrofit_endpoints"]:
        md.append("| HTTP Method | Route Endpoint | Source Interface / Class |")
        md.append("| :---: | :--- | :--- |")
        for ep in data["retrofit_endpoints"][:30]:
            md.append(f"| `{ep['method']}` | **`{ep['endpoint']}`** | `{ep['source_file']}` |")
        if len(data["retrofit_endpoints"]) > 30:
            md.append(f"\n*(...and {len(data['retrofit_endpoints']) - 30} more endpoints detected)*")
    else:
        md.append("ℹ️ *No Retrofit `@GET/@POST` interface definitions found in decompiled code (endpoints are called directly via SDK clients/OkHttp above).*")
    md.append("")

    # Section 4: Custom Headers
    if data.get("custom_headers"):
        md.append("## 📑 4. Network Headers Detected")
        for h in data["custom_headers"][:15]:
            md.append(f"* `{h}`")
        md.append("")

    md.append("---\n*Audit executed via Antigravity Engine `#rever` (JADX, AAPT & DEX Multi-Tier Scanner - Zero Filtering)*")
    return "\n".join(md)

def main():
    parser = argparse.ArgumentParser(description="APK/APKs Endpoint & Secret Static Audit Engine (#rever / #reverse / #revers)")
    parser.add_argument("target", help="Path to .apk, .apks, or .xapk file")
    parser.add_argument("--format", choices=["md", "json"], default="md", help="Output format (default: md)")
    parser.add_argument("--fast", action="store_true", help="Skip deep JADX decompile, scan DEX and Resources only")
    parser.add_argument("--output", "-o", help="Explicit save output path (defaults to <package_name>_audit_report.<ext>)")
    parser.add_argument("--out-dir", default=os.getcwd(), help="Directory to save report file (default: current working directory)")

    args = parser.parse_args()

    if not os.path.exists(args.target):
        print(f"Error: Target path '{args.target}' does not exist.", file=sys.stderr)
        sys.exit(1)

    deep_scan = not args.fast
    results = run_audit(args.target, deep_scan=deep_scan)

    pkg_name = results.get("metadata", {}).get("package_name", "unknown_app")

    if args.format == "json":
        output_text = json.dumps(results, indent=2, ensure_ascii=False)
        ext = "json"
    else:
        output_text = format_markdown_report(results)
        ext = "md"

    if args.output:
        report_file = args.output
    else:
        report_file = os.path.join(args.out_dir, f"{pkg_name}_audit_report.{ext}")

    with open(report_file, "w", encoding="utf-8") as f:
        f.write(output_text)

    print(f"\n[REPORT_GENERATED]: {os.path.abspath(report_file)}")
    print(output_text)

if __name__ == "__main__":
    main()
