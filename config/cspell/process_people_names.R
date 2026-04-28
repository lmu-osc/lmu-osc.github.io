

library(dplyr)
library(stringr)
library(stringi)


expand_german_umlauts <- function(x) {
  x |>
    stri_replace_all_fixed("Ä", "Ae") |>
    stri_replace_all_fixed("Ö", "Oe") |>
    stri_replace_all_fixed("Ü", "Ue") |>
    stri_replace_all_fixed("ä", "ae") |>
    stri_replace_all_fixed("ö", "oe") |>
    stri_replace_all_fixed("ü", "ue") |>
    stri_replace_all_fixed("ß", "ss")
}



people_files <- list.files("people/people", full.names = T, pattern = ".qmd")

yaml::yaml.load_file(people_files[1])

names_table <- people_files %>%
  purrr::map(~{
    try({
      yaml_data <- yaml::yaml.load_file(.x) 
      tibble::tibble(
        surname = yaml_data$surname,
        first_name = yaml_data$first_name
      )
    })
  }) %>%
  dplyr::bind_rows()


names_vec <- c(names_table$first_name, names_table$surname) %>%
  str_split(" ") %>%
  unlist() 

names_vec[order(nchar(names_vec))]


names_no_letters <- names_vec %>%
  setdiff(
    c("G.", "L.", "F.", "C.J.", "I.", "W.")
  ) 

names_original <- names_no_letters
names_original_expanded_umlauts <- expand_german_umlauts(names_original)
names_original_latinized <- stri_trans_general(names_original_expanded_umlauts, "Latin-ASCII")
names_lowercase <- tolower(names_no_letters)
names_lowercase_expanded_umlauts <- expand_german_umlauts(names_lowercase)
names_lowercase_latinized <- stri_trans_general(names_lowercase_expanded_umlauts, "Latin-ASCII")


# safeguard for names that do not exist in the People section
existing_lines <- readLines("config/cspell/names.txt") 

names_all <- c(names_original, names_original_expanded_umlauts, names_original_latinized, names_lowercase, names_lowercase_expanded_umlauts, names_lowercase_latinized, existing_lines) %>%
  unique() %>%
  sort()


writeLines(names_all, "config/cspell/names.txt")
