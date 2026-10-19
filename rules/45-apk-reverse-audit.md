# 45 - APK REVERSE ENGINEERING & STATIC SECURITY AUDIT STANDARD [Quick Tag: `#rever` / `#reverse` / `#revers`]

## 1. PURPOSE & HIGHEST MANDATE
This document establishes the mandatory architectural and engineering compliance standard for **APK/APKs Static Analysis, Endpoint Extraction, and Credential Security Auditing**.

When performing security audits, third-party library verification, or competitive technical research on Android application packages (`.apk`, `.apks`, `.xapk`), the Antigravity Engine automatically activates the **Gate E45** pipeline to extract API routes, backend hosts, and audit for hardcoded secrets.

### ⚡ Seamless Autonomous Execution Mandate
Whenever `#rever`, `#reverse`, or `#revers` is triggered, the AI is granted **pre-approved end-to-end execution authorization**:
* All extraction, decompilation, analysis, and file generation tasks execute autonomously without intermediate permission prompts.
* The engine MUST automatically extract the application's unique `package_name` (via `aapt dump badging` or manifest string pool) and output a clean Markdown report saved directly to `./<package_name>_audit_report.md` in the current working directory.

---

## 2. THE 6-STAGE AUDIT PROTOCOL (GATE E45)

```text
+---------------------------------------------------------------------------------------------+
|                           GATE E45: REVER STATIC AUDIT PIPELINE                             |
+---------------------------------------------------------------------------------------------+
| R0. Seamless Authorization --> Pre-approved end-to-end autonomous execution                 |
| R1. Archive Ingestion      --> Handle .apk, .apks, .xapk; normalize & extract base.apk      |
| R2. Bytecode & Resources   --> Direct DEX string table extraction & JADX CLI decompilation  |
| R3. Network Security Audit --> Check usesCleartextTraffic, TLS configs & FQDN Host mapping  |
| R4. API Route Mapping      --> Scrape Retrofit (@GET, @POST, @Headers) & OkHttp/Ktor paths  |
| R5. Secret & Token Audit   --> Detect Google Keys, JWT (eyJ..), Firebase, AWS, Bearer tokens|
| R6. Auto Package Report    --> Save ./<package_name>_audit_report.md and display summary    |
+---------------------------------------------------------------------------------------------+
```

---

### Stage R1: Archive Ingestion & Split Handling
1. **Split APK Normalization:**
   * Modern Google Play apps are distributed as Android App Bundles or Split APKs (`.apks`, `.xapk`).
   * The audit engine automatically inspects the container archive and resolves the primary **`base.apk`** (containing core application bytecode and network configurations).

### Stage R2: Bytecode & Resource Decoding
1. **Hybrid Scanning Approach:**
   * **Tier 1 (Fast String Table Extraction):** Directly parses UTF-8 / ASCII strings from `classes*.dex` without waiting for full decompilation, delivering immediate findings (< 3s).
   * **Tier 2 (JADX AST Decompilation):** If JADX is present (`/opt/homebrew/bin/jadx`), the engine executes headless headless decompilation (`jadx --no-res -j 4`) to reconstruct class definitions.

### Stage R3: Network Security & Domain Enumeration
1. **Cleartext Traffic Detection:**
   * Audits `AndroidManifest.xml` for `android:usesCleartextTraffic="true"` (CWE-319: Cleartext Transmission of Sensitive Information).
2. **Domain Grouping & Filtering:**
   * Filters out system noise (`schemas.android.com`, `www.w3.org`, `google.com/search`).
   * Groups endpoints by Fully Qualified Domain Name (FQDN) to identify internal staging, production, and third-party SaaS backends.

### Stage R4: API Endpoint & Service Mapping
1. **Declarative Route Scraping:**
   * Parses Java/Kotlin source code for HTTP routing annotations:
     * `@GET("...")`, `@POST("...")`, `@PUT("...")`, `@DELETE("...")`, `@PATCH("...")`
     * `@Headers("...")`, `@Path("...")`, `@Query("...")`
   * Extracts static routes to map the complete REST/gRPC API surface.

### Stage R5: Secret, Token & Credential Audit
1. **Deterministic Pattern Matching:**
   * **Google API Key:** `AIza[0-9A-Za-z-_]{35}`
   * **Firebase Database:** `https://[a-zA-Z0-9_-]+\.firebaseio\.com`
   * **AWS Access Key ID:** `(AKIA|ABIA|ACCA|ASIA)[0-9A-Z]{16}`
   * **JWT Authentication Tokens:** `eyJ[a-zA-Z0-9_-]{10,}\.eyJ...`
   * **Hardcoded Authorization Headers:** `Bearer <token>`, `Basic <credentials>`
   * **Private Key Blocks:** `-----BEGIN (RSA )?PRIVATE KEY-----`

### Stage R6: Deterministic Audit Reporting
* Every audit execution generates a structured report summarizing:
  1. Executive Risk Summary & Network Security Profile.
  2. Detected Hardcoded Secrets & Severity rating.
  3. Discovered Backend Domains & FQDNs.
  4. Mapped API Routes with source file/class references.

---

## 3. AUTOMATION ENGINE RUNNER

The quick tag is powered by the standalone Python automation script:
```bash
# Standard Markdown Report (Fast DEX + Deep JADX)
python3 ~/.antigravity/scripts/rever_audit.py /path/to/app.apk

# Fast Scan only (DEX strings without full JADX decompile)
python3 ~/.antigravity/scripts/rever_audit.py /path/to/app.apks --fast

# Output to JSON
python3 ~/.antigravity/scripts/rever_audit.py /path/to/app.apk --format json -o audit_report.json
```

---

## 4. DEFENSIVE REMEDIATION BLUEPRINT (FOR APP DEVELOPERS)

When vulnerabilities or exposed endpoints are detected during `#rever`:
1. **Hardcoded Secrets (CWE-798):**
   * Move API secrets out of source code and strings.xml.
   * Use backend token exchange or Google Play Integrity API with ephemeral attestation tokens.
2. **Cleartext HTTP (CWE-319):**
   * Enforce `android:usesCleartextTraffic="false"` in `AndroidManifest.xml`.
   * Configure `res/xml/network_security_config.xml` to disallow cleartext traffic domain-wide.
3. **API Obfuscation (R8 Hygiene):**
   * Enable R8 Full Mode (`android.enableR8.fullMode=true`).
   * Avoid blanket keep rules on Retrofit interfaces; obfuscate class and method names.
