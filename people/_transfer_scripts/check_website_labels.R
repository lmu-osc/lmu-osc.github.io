
library(magrittr)


# get all .qmd files, and then read the yaml front matter for websites
all_sites <- list.files("people/people", full.names = T) %>%
  stringr::str_extract_all(".*.qmd") %>%
  unlist() %>%
  purrr::map(function(path) {
    
    lines <- readLines(path, warn = FALSE)
    
    # Find YAML boundaries
    if (length(lines) < 2 || lines[1] != "---") {
      stop("No YAML front matter found")
    }
    
    end <- which(lines[-1] == "---")[1] + 1
    yaml_text <- paste(lines[2:(end - 1)], collapse = "\n")
    
    yaml::yaml.load(yaml_text)$website
    
  }) 


all_sites %>%
  purrr::map(~{
    purrr::map(.x, ~{.x[["label"]]})
  }) %>%
  unlist() %>%
  table()
