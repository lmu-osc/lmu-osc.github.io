
library(magrittr)
library(stringr)
library(yaml)
library(dplyr)



extract_yaml <- function(path) {
  lines <- readLines(path, warn = FALSE)
  
  if (length(lines) < 2 || lines[1] != "---") {
    return(NULL)
  }
  
  end <- which(lines[-1] == "---")[1] + 1
  yaml::yaml.load(paste(lines[2:(end - 1)], collapse = "\n"))
}



template <- list.files("events/events", full.names = TRUE) %>%
  grep("(?i)\\.(qmd|rmd|md)$", ., value = TRUE) %>%
  purrr::map(~{
    yaml_content <- extract_yaml(.x)
    dplyr::tibble(event_title = yaml_content[["event"]][["title"]],
      event_start = yaml_content[["event"]][["date"]],
      event_end = yaml_content[["event"]][["end_date"]]) 
  }) %>%
  dplyr::bind_rows() %>%
  mutate(
    instructor1 = NA,
    url1 = NA,
    instructor2 = NA,
    url2 = NA,
    instructor3 = NA,
    url3 = NA,
    instructor4 = NA,
    url4 = NA,
    instructor5 = NA,
    url5 = NA,
    helper1 = NA,
    helper2 = NA,
    helper3 = NA,
    helper4 = NA,
    helper5 = NA,
    presenter1 = NA,
    presenter2 = NA,
    presenter3 = NA,
    presenter4 = NA,
    presenter5 = NA,
    host1 = NA,
    host2 = NA,
    host3 = NA,
    host4 = NA,
    host5 = NA,
    organizers1 = NA,
    organizers2 = NA,
    organizers3 = NA,
    organizers4 = NA,
    organizers5 = NA
  ) 
