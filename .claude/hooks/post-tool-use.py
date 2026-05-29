#!/usr/bin/env python3
"""PostToolUse hook — auto-format code and track modified files."""
import json, sys, os, re
from datetime import datetime

STATE_FILE = os.path.expanduser("~") + "/.claude/project-state.md"

def update_modified_files(file_path):
    try:
        with open(STATE_FILE) as f:
            content = f.read()
    except Exception:
        return

    m = re.search(r'modified_files:\s*\[(.*?)\]', content, re.DOTALL)
    existing = []
    if m:
        items = m.group(1)
        existing = [x.strip().strip('"\'') for x in re.findall(r'"([^"]*)"', items)]

    rel_path = file_path.replace(os.path.expanduser("~") + "/", "")
    if rel_path not in existing:
        existing.append(rel_path)

    new_list = "\n".join(f'  - "{p}"' for p in existing[-20:])
    new_content = re.sub(
        r'modified_files:\s*\[.*?\]',
        f'modified_files:\n{new_list}',
        content,
        flags=re.DOTALL
    )
    new_content = re.sub(
        r'modified_files_count:\s*\d+',
        f'modified_files_count: {len(existing)}',
        new_content
    )

    try:
        with open(STATE_FILE, 'w') as f:
            f.write(new_content)
    except Exception:
        pass

def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        sys.exit(0)

    tool_name = data.get("tool_name", "")
    tool_input = data.get("tool_input", {})
    file_path = tool_input.get("file_path", "")

    if tool_name in ("Edit", "Write") and file_path:
        update_modified_files(file_path)

    sys.exit(0)

if __name__ == "__main__":
    main()
