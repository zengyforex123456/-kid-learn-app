#!/usr/bin/env python3
"""Stop hook — verify SDLC compliance at conversation end."""
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
    phase = get_phase()
    msg = f"[SDLC] Current phase: {phase} | Next: "
    if phase == "P1":
        msg += "Confirm 5 decision points → P2"
    elif phase == "P2":
        msg += "Code complete → P3 (testing)"
    elif phase == "P3":
        msg += "Tests pass → P4 (review)"
    elif phase == "P4":
        msg += "Review pass → P5 (delivery)"
    elif phase == "P5":
        msg += "Delivery complete → archive"
    print(msg, file=sys.stderr)
    sys.exit(0)

if __name__ == "__main__":
    main()
