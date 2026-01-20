

library(magrittr)
library(stringr)
library(yaml)
library(dplyr)


faculties <- c(
  "Catholic Theology",
  "Protestant Theology",
  "Law",
  "Business Administration - Munich School of Management",
  "Economics",
  "Medicine",
  "Veterinary Medicine",
  "History and the Arts",
  "Philosophy, Philosophy of Science and Religious Studies",
  "Psychology and Educational Sciences",
  "Study of Culture",
  "Languages and Literatures",
  "Social Sciences",
  "Mathematics, Informatics and Statistics",
  "Physics",
  "Chemistry and Pharmacy",
  "Biology",
  "Geosciences"
)

extract_yaml <- function(path) {
  lines <- readLines(path, warn = FALSE)
  
  if (length(lines) < 2 || lines[1] != "---") {
    return(NULL)
  }
  
  end <- which(lines[-1] == "---")[1] + 1
  yaml::yaml.load(paste(lines[2:(end - 1)], collapse = "\n"))
}


people_files <- list.files("./people/people", full.names = TRUE) %>%
  grep(".qmd", ., value = TRUE) 


people_files %>%
  purrr::map(~{
    card_yaml <- extract_yaml(.x)
    
    if (is.null(card_yaml[["faculty"]])) {
      return("no faculty field")
    } else {
      return(card_yaml[["faculty"]])
    }
  }) %>%
  unlist() %>%
  tibble(title = .) %>%
  group_by(title) %>%
  count() %>%
  arrange(desc(n)) %>%
  View()
