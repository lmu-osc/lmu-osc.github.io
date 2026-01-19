#!/usr/bin/env python3

import os
import re
import sys
from pathlib import Path
from collections import Counter

# Get all profile filenames without extensions
profile_dir = Path("people/people")
names_from_files = []

if profile_dir.exists():
    for file in profile_dir.iterdir():
        if file.is_file() and re.search(r'\.(qmd|rmd|md)$', file.name, re.IGNORECASE):
            # Remove the extension
            name = re.sub(r'\.(qmd|rmd|md)$', '', file.name, flags=re.IGNORECASE)
            names_from_files.append(name)

# Initialize error tracking
errors_found = False

# Check 1: Duplicated names
name_counts = Counter(names_from_files)
duplicated_names = [name for name, count in name_counts.items() if count > 1]

if duplicated_names:
    print("ERROR: Duplicated profile names found:")
    for name in duplicated_names:
        print(f"  - {name}")
    print()
    errors_found = True

# Check 2: Files containing hyphens instead of underscores
files_with_hyphens = [name for name in names_from_files if '-' in name]
if files_with_hyphens:
    print("ERROR: Profile names with hyphens found (use underscores instead):")
    for name in files_with_hyphens:
        print(f"  - {name}")
    print()
    errors_found = True

# Check 3: Files containing spaces
files_with_spaces = [name for name in names_from_files if ' ' in name]
if files_with_spaces:
    print("ERROR: Profile names with spaces found (use underscores instead):")
    for name in files_with_spaces:
        print(f"  - {name}")
    print()
    errors_found = True

# Check 4: Files containing non-ASCII characters (umlauts, etc.)
files_with_special_chars = [name for name in names_from_files if not re.match(r'^[a-zA-Z0-9_]+$', name)]
if files_with_special_chars:
    print("ERROR: Profile names with special characters found (use only a-z, A-Z, 0-9, and underscores):")
    for name in files_with_special_chars:
        print(f"  - {name}")
    print()
    errors_found = True

# Exit with appropriate status
if errors_found:
    print("Profile naming convention checks FAILED.")
    print("Please ensure profile filenames:")
    print("  - Use underscores (_) instead of hyphens or spaces")
    print("  - Contain only ASCII characters (a-z, A-Z, 0-9, _)")
    print("  - Are unique (no duplicates)")
    print("If there are duplicate names, consider adding middle initials to differentiate them.")
    print("If middle initials are already used, consider adding full middle names.")
    print("The final option, if needed, is to append a numeric suffix (e.g., _1, _2) to make names unique.")
    sys.exit(1)
else:
    print("All profile naming convention checks PASSED.")
    sys.exit(0)
