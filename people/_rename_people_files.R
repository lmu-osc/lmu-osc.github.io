

people_files <- list.files("people/people", full.names = T) %>%
  grep(".*.qmd", ., value = TRUE)


new_names <- people_files %>%
  stringr::str_replace_all("__", "_") %>%
  stringr::str_replace_all("_", "-")


file.rename(people_files, new_names)
