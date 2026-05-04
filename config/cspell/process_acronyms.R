
library(magrittr)

current_acronyms <- readLines(
  "config/cspell/acronyms.txt"
)

current_acronyms[order(nchar(current_acronyms))]

# an acronym should never really be shorter than 3 characters...
# at the time of creating this script, no acronyms were filtered out
current_acronyms[nchar(current_acronyms) >= 3]

lowercase_acronyms <- tolower(current_acronyms)


acronyms_all <- c(current_acronyms, lowercase_acronyms) %>%
  unique() %>%
  sort()

writeLines(acronyms_all, "config/cspell/acronyms.txt")
