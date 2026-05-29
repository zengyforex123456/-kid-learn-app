#!/usr/bin/env python3
"""UserPromptSubmit hook — inject SDLC phase context into prompt."""
import sys, os, re

PHASE_FILE = os.path.expanduser("~") + "/.claude/project-state.md"

def get_state():
    try:
        with open(PHASE_FILE) as f:
            return f.read()
    except Exception:
        return ""

def main():
    state = get_state()
    phase = "P1"
    task = "waiting"
    m = re.search(r'current_phase:\s*"(\w+)"', state)
    if m:
        phase = m.group(1)
    m = re.search(r'task_description:\s*"([^"]*)"', state)
    if m:
        task = m.group(1)

    context = f"\n[SDLC Phase: {phase} | Task: {task}]"
    print(context)

if __name__ == "__main__":
    main()
