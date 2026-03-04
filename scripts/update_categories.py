#!/usr/bin/env python3
import os
import re

base_dir = 'people/people'

def strip_quotes(s):
    s = s.strip()
    if (s.startswith('"') and s.endswith('"')) or (s.startswith("'") and s.endswith("'")):
        return s[1:-1]
    return s

for root, dirs, files in os.walk(base_dir):
    for fname in files:
        if not fname.endswith('.qmd'):
            continue
        path = os.path.join(root, fname)
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        if not content.startswith('---'):
            continue
        parts = content.split('\n')
        # find frontmatter bounds
        try:
            fm_start = 0
            fm_end = parts.index('---', 1)
        except ValueError:
            continue
        front = parts[fm_start+1:fm_end]
        # find memberships line index
        mem_idx = None
        for i, line in enumerate(front):
            if re.match(r"^\s*memberships:\s*$", line):
                mem_idx = i
                break
        # find first faculty value
        faculty_val = None
        for i, line in enumerate(front):
            m = re.match(r"^\s*faculty:\s*(.+)$", line)
            if m:
                faculty_val = strip_quotes(m.group(1)).strip()
                if faculty_val:
                    break
        if not faculty_val:
            # nothing to do
            continue
        if faculty_val.upper() == 'NA':
            continue
        # prepare categories block
        cat_block = ['categories:','  - ' + faculty_val]
        # remove existing categories block if present
        new_front = []
        skip = False
        i = 0
        while i < len(front):
            line = front[i]
            if re.match(r"^\s*categories:\s*$", line):
                # skip this line and any following list items or indented lines
                i += 1
                while i < len(front) and (re.match(r"^\s*-\s*", front[i]) or re.match(r"^\s+", front[i])):
                    i += 1
                continue
            else:
                new_front.append(line)
                i += 1
        # insert categories block just above memberships or at end if no memberships
        insert_at = mem_idx if mem_idx is not None else len(new_front)
        # ensure we don't duplicate if already present with same value
        # (we removed old categories, so insert fresh)
        new_front = new_front[:insert_at] + cat_block + new_front[insert_at:]
        # reconstruct file
        new_content = '\n'.join(['---'] + new_front + ['---'] + parts[fm_end+1:])
        if new_content != content:
            with open(path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print('Updated', path)
print('Done')
