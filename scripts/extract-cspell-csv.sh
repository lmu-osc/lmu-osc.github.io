#!/usr/bin/env bash
set -euo pipefail

# Extract cspell findings from a GitHub Actions log into a CSV.
# Output columns: file,reason,word
#
# Usage:
#   scripts/extract-cspell-csv.sh INPUT_LOG [OUTPUT_CSV]
#
# Example:
#   scripts/extract-cspell-csv.sh 0_cspell.txt cspell-flagged-words.csv

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  cat <<'EOF'
Extract cspell findings from a CI log into CSV.

Usage:
  scripts/extract-cspell-csv.sh INPUT_LOG [OUTPUT_CSV]

Arguments:
  INPUT_LOG   Path to cspell/CI log text file
  OUTPUT_CSV  Optional output path (default: cspell-flagged-words.csv)
EOF
  exit 0
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Error: expected 1 or 2 arguments." >&2
  echo "Run with --help for usage." >&2
  exit 1
fi

input_log=$1
output_csv=${2:-cspell-flagged-words.csv}

if [[ ! -f "$input_log" ]]; then
  echo "Error: input file not found: $input_log" >&2
  exit 1
fi

tmp_rows=$(mktemp)
trap 'rm -f "$tmp_rows"' EXIT

# Supports both plain lines and timestamp-prefixed GitHub Actions lines.
perl -ne '
  if (/^(?:\S+\s+)?([^:]+):\d+:\d+\s+(Misspelled word|Unknown word|Forbidden word)\s+\(([^)]+)\)/) {
    $file = $1;
    $reason = $2;
    $word = $3;
    $word =~ s/"/""/g;
    print "$file,$reason,\"$word\"\n";
  }
' "$input_log" | awk '!seen[$0]++' > "$tmp_rows"

{
  printf 'file,reason,word\n'
  cat "$tmp_rows"
} > "$output_csv"

entry_count=$(($(wc -l < "$output_csv") - 1))
printf 'Wrote %d entries to %s\n' "$entry_count" "$output_csv"
