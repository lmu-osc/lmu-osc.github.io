

library(magrittr)
library(dplyr)
library(stringr)

file_paths <- list.files("events/events", full.names = TRUE) %>%
  stringr::str_subset(".qmd")


lines <- readLines(file_paths[1])

# Extract all URLs from each line
urls <- unlist(str_extract_all(lines, "https?://[^\\s)>\"]+"))

# Remove duplicates (optional)
urls <- unique(urls)

print(urls)


extracted_links_by_file <- purrr::map(file_paths, function(file_path) {
  lines <- readLines(file_path)
  
  # Extract all URLs from each line
  urls <- unlist(str_extract_all(lines, "https?://[^\\s)>\"]+"))
  
  # Remove duplicates (optional)
  urls <- unique(urls)
  
  
  return(urls)
}) %>%
  purrr::map(~{
    str_remove_all(.x, "</a")
  })




named_links <- extracted_links_by_file %>%
  purrr::map(~{
    for (i in seq_along(.x)) {
      names(.x)[i] <- paste0("link", i)
    }
    .x
  })


links_table <- tibble(
  file = file_paths,
  links = named_links
) %>%
  tidyr::unnest_wider(links) %>%
  mutate(
    n_links = rowSums(!is.na(select(., starts_with("link"))))
  ) 


write.csv(links_table, "events/events/events_links.csv", row.names = FALSE)

