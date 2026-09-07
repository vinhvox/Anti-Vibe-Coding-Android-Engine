#!/usr/bin/env python3
import sys
import json
import os

def read_file_safe(path):
    if os.path.exists(path):
        try:
            with open(path, "r", encoding="utf-8") as f:
                return f.read().strip()
        except Exception:
            return ""
    return ""

def main():
    stdin_data = {}
    try:
        if not sys.stdin.isatty():
            raw_input = sys.stdin.read()
            if raw_input:
                stdin_data = json.loads(raw_input)
    except Exception:
        pass

    base_dir = "${ANTIGRAVITY_HOME:-$HOME/.antigravity}"
    
    mandate = read_file_safe(os.path.join(base_dir, "rules", "00-system-mandate.md"))
    workflow = read_file_safe(os.path.join(base_dir, "workflow", "00-master-workflow.md"))
    user_pref = read_file_safe(os.path.join(base_dir, "memory", "06-user-preference-memory.md"))
    task_mem = read_file_safe(os.path.join(base_dir, "memory", "03-task-memory.md"))
    proj_mem = read_file_safe(os.path.join(base_dir, "memory", "01-project-memory.md"))
    decision_mem = read_file_safe(os.path.join(base_dir, "memory", "04-decision-memory.md"))

    parts = ["[AUTOMATIC HOOK] Core Mandate, Workflow & Memory Loaded from ~/.antigravity/:"]

    if mandate:
        parts.append(f"=== SYSTEM MANDATE ===\n{mandate}")
    if workflow:
        parts.append(f"=== MASTER WORKFLOW ===\n{workflow}")
    if user_pref:
        parts.append(f"=== USER PREFERENCES ===\n{user_pref}")
    if proj_mem:
        parts.append(f"=== PROJECT MEMORY ===\n{proj_mem}")
    if task_mem:
        parts.append(f"=== TASK MEMORY ===\n{task_mem}")
    if decision_mem:
        parts.append(f"=== DECISION MEMORY ===\n{decision_mem}")

    ephemeral_text = "\n\n".join(parts)

    output = {
        "injectSteps": [
            {
                "ephemeralMessage": ephemeral_text
            }
        ]
    }

    print(json.dumps(output, ensure_ascii=False))

if __name__ == "__main__":
    main()
