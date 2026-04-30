# cSpell Configuration and Dictionaries

This folder contains project-specific helper files for the repository's spell-checking setup. The CI workflow and editor tools read the main `cspell.config.yaml` at the repository root.

---

## Files in this folder

| File | Purpose |
|------|---------|
| `british-english-exceptions.txt` | British spellings allowed for proper nouns (one per line) |
| `names.txt`, `acronyms.txt`, `german.txt`, `other.txt` | Project-specific dictionaries (one word per line) |
| `ignore-paths.yaml` | Paths and patterns excluded from spell checking |
| `process_acronyms.R` | R script to normalize and expand acronyms |
| `process_people_names.R` | R script to extract and process people names |

---

## How cSpell uses these files

- The root `cspell.config.yaml` references all dictionaries via `dictionaryDefinitions` and imports `ignore-paths.yaml`
- Dictionaries with `addWords: true` are added to cSpell at runtime
- cSpell is case-insensitive for dictionary lookups

---

## Flagged words (forbidden words)

The root config defines `flagWords:` to enforce US spellings. Important behavior:

- Flagged words generate "Forbidden word" warnings even if they appear in a dictionary
- **Flagged words always win** — if a word is in both `flagWords` and a dictionary, it's still forbidden
- To allow a word: remove it from `flagWords` in [cspell.config.yaml](../cspell.config.yaml#L21)

---

## Quick start: Adding or changing words

### Add an allowed word
Append to the appropriate file (one word per line):
```
echo "NewTerm" >> config/cspell/names.txt
```

### Allow a British spelling
Remove from `flagWords` in [cspell.config.yaml](../cspell.config.yaml#L21). Example:
```yaml
# Remove 'centre' from this list to allow it:
flagWords:
  - colour
  # - centre  ← remove or comment out
```

### Block a word project-wide
Add to `flagWords` in [cspell.config.yaml](../cspell.config.yaml#L21)

---

## Filenames and tokens

cSpell tokenizes text in content and inline strings (including filenames in front matter):
- If `newsletter_2022_october.pdf` contains an unknown token (`october`), it's reported as unknown
- Solution: add the token to a dictionary file

---

## R scripts

### `process_acronyms.R`
Normalizes acronyms by adding lowercase variants and sorting. Run from repo root:
```bash
Rscript config/cspell/process_acronyms.R
```
**Dependencies:** `magrittr`  
**Output:** Updates `config/cspell/acronyms.txt` in place

### `process_people_names.R`
Extracts first and last names from `people/people` files, expands umlaut variants, and latinizes:
```bash
Rscript config/cspell/process_people_names.R
```
**Dependencies:** `dplyr`, `stringr`, `stringi`, `yaml`, `purrr`, `tibble`  
**Output:** Updates `config/cspell/names.txt` in place

#### Install dependencies
```R
install.packages(c("dplyr","stringr","stringi","yaml","purrr","tibble","magrittr"))
```

Or restore the project environment:
```bash
Rscript -e 'renv::restore()'
```

---

## Security notes

- These scripts read project `.qmd` files — only run on trusted clones
- Scripts write directly to dictionary files in place

---

## Workflow integration

- The GitHub Action at `.github/workflows/spell-check.yml` uses the root `cspell.config.yaml`
- To move the config: update `config:` path in the workflow or set `use_cspell_files: true`
- German dictionary (`@cspell/dict-de-de`) is installed at workflow runtime

---

## Editor tips

VS Code's cSpell extension prefers `.cspell.json` at the repo root, but `cspell.config.yaml` works fine. To convert:
1. Generate `cspell.json` from current YAML
2. Update the workflow `config:` path if needed
