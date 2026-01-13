

library(stringr)

# Get all profile filenames without extensions
names_from_files <- list.files("people/people", full.names = TRUE) %>%
  grep("(?i)\\.(qmd|rmd|md)$", ., value = TRUE) %>%
  str_remove("people/people/") %>%
  str_remove("(?i)\\.(qmd|rmd|md)$")

# Initialize error tracking
errors_found <- FALSE

# Check 1: Duplicated names
duplicated_names <- names_from_files %>%
  table() %>%
  {. > 1} %>%
  which() %>%
  names()

if (length(duplicated_names) > 0) {
  cat("ERROR: Duplicated profile names found:\n")
  cat(paste("  -", duplicated_names, collapse = "\n"), "\n\n")
  errors_found <- TRUE
}

# Check 2: Files containing hyphens instead of underscores
files_with_hyphens <- names_from_files[grepl("-", names_from_files)]
if (length(files_with_hyphens) > 0) {
  cat("ERROR: Profile names with hyphens found (use underscores instead):\n")
  cat(paste("  -", files_with_hyphens, collapse = "\n"), "\n\n")
  errors_found <- TRUE
}

# Check 3: Files containing spaces
files_with_spaces <- names_from_files[grepl(" ", names_from_files)]
if (length(files_with_spaces) > 0) {
  cat("ERROR: Profile names with spaces found (use underscores instead):\n")
  cat(paste("  -", files_with_spaces, collapse = "\n"), "\n\n")
  errors_found <- TRUE
}

# Check 4: Files containing non-ASCII characters (umlauts, etc.)
files_with_special_chars <- names_from_files[!grepl("^[a-zA-Z0-9_]+$", names_from_files)]
if (length(files_with_special_chars) > 0) {
  cat("ERROR: Profile names with special characters found (use only a-z, A-Z, 0-9, and underscores):\n")
  cat(paste("  -", files_with_special_chars, collapse = "\n"), "\n\n")
  errors_found <- TRUE
}

# Exit with appropriate status
if (errors_found) {
  cat("Profile naming convention checks FAILED.\n")
  cat("Please ensure profile filenames:\n")
  cat("  - Use underscores (_) instead of hyphens or spaces\n")
  cat("  - Contain only ASCII characters (a-z, A-Z, 0-9, _)\n")
  cat("  - Are unique (no duplicates)\n")
  cat("If there are duplicate names, consider adding middle initials to differentiate them.\n")
  cat("If middle initials are already used, consider adding full middle names.\n")
  cat("The final option, if needed, is to append a numeric suffix (e.g., _1, _2) to make names unique.\n")
  quit(status = 1)
} else {
  cat("All profile naming convention checks PASSED.\n")
  quit(status = 0)
} 
