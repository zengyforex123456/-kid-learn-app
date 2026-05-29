#!/usr/bin/env python3
"""PreToolUse hook — block Edit/Write in non-P2 phases."""
import json, sys, os, re

PHASE_FILE = os.path.expanduser("~") + "/.claude/project-state.md"

def get_phase():
    try:
        with open(PHASE_FILE) as f:
            content = f.read()
        m = re.search(r'current_phase:\s*"(\w+)"', content)
        return m.group(1) if m else "P1"
    except Exception:
        return "P1"

def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        sys.exit(0)

    tool_name = data.get("tool_name", "")
    tool_input = data.get("tool_input", {})
    phase = get_phase()

    # P2 allows all Edit/Write
    if phase in ("P2",):
        sys.exit(0)

    # P3 allows Edit/Write for test files
    if phase == "P3":
        fp = tool_input.get("file_path", "")
        if fp and ("test" in fp.lower() or "spec" in fp.lower() or "__tests__" in fp):
            sys.exit(0)

    # P4 allows Edit/Write only for fixes
    if phase == "P4":
        sys.exit(2)  # warning only

    if tool_name in ("Edit", "Write"):
        print(f"BLOCKED: {tool_name} is not allowed in phase {phase}. Use /phase to advance.")
        sys.exit(1)

    sys.exit(0)

if __name__ == "__main__":
    main()
