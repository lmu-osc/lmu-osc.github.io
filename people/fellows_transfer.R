

library(readr)
library(dplyr)
library(stringr)
library(purrr)
library(magrittr)


fellows_raw_url <- "https://raw.githubusercontent.com/lmu-osc/osc-website-transfer/refs/heads/main/fellow_members.csv?token=GHSAT0AAAAAADNSJCJN27JINPKVSEU3HAME2HXHRYQ"

fellows_table <- read_csv(fellows_raw_url) %>%
  mutate(email = str_remove(email, "mailto:")) %>%
  tidyr::separate('Surname, First name', into = c('surname', 'first_name'), sep = ', ') %>%
  mutate(description_section_2 = if_else(
    description_section_1 != "<em><strong>Mission Statement:</strong></em>",
    description_section_1,
    description_section_2)
    )


fellows_table %<>%
  mutate(
    Position = if_else(first_name == "Maximilian" & surname == "Kristen",
                       "MSc Student",
                       Position),
    Position = if_else(first_name == "Leonhard" & surname == "Schramm",
                       "MSc Student",
                       Position),
    Position = if_else(str_detect(Position, "PhD"),
                       "PhD Candidate",
                       Position),
    Position = str_remove_all(Position, "\\."),
    Title = if_else(is.na(Title), Position, Title) %>%
      str_remove_all("\\.")
  )

View(fellows_table)




template_body <- readLines("./people/people/00001_felix_schoenbrodt.qmd")
template_body[64:99] %>%
  paste(collapse = "\n")


temp <- fellows_table %>%
  select(surname, first_name, Title, Position, Faculty, Department, email,
         matches("website"), matches("description")) %>%
  pmap(function(surname, first_name, Title, Position, Faculty, Department, email,
                website_1, website_2, description_section_1, description_section_2,
                description_section_3, description_section_4, description_section_5) {
  
  
  yaml <- glue::glue(
    "---\n",
    "title: {first_name} {surname}\n",
    "academic_title: {Title}\n",
    "name: {first_name} {surname}\n",
    "surname: {surname}\n",
    "first_name: {first_name}\n",
    "position: {Position}\n",
    "faculty: {Faculty}\n",
    "membertype: ['fellow']\n",
    "photo: NULL\n",
    "email: {email}\n"
  )
  
  if (!is.na(website_1)) {
    yaml <- glue::glue(
      yaml, "\n",
      "website:\n",
      "  - label: 'Website 1'\n",
      "    url: {website_1}\n"
    )
  }
  
  if (!is.na(website_2)) {
    yaml <- glue::glue(
      yaml, "\n",
      "  - label: 'Website 2'\n",
      "    url: {website_2}\n"
    )
  }
  
  yaml <- glue::glue(
   yaml, "\n",
   "social_media:\n",
   "  ORCID: 'https://orcid.org/0000-0000-0000-0000'"
  )
  
  if (!is.na(description_section_2)) {
    yaml <- glue::glue(
      yaml, "\n",
      "mission_statement:\n",
      "  - {description_section_2}\n",
    )
  }
  
  if (!is.na(description_section_3)) {
    yaml <- glue::glue(
      yaml, "\n",
      "  - {description_section_3}\n",
    )
  }
  
  if (!is.na(description_section_4)) {
    yaml <- glue::glue(
      yaml, "\n",
      "  - {description_section_4}\n",
    )
  }
  
  if (!is.na(description_section_5)) {
    yaml <- glue::glue(
      yaml, "\n",
      "  - {description_section_5}\n",
    )
  }
  
  yaml <- glue::glue(yaml, "\n---\n")
  
  yaml_plus_body <- paste0(
    yaml,
    "\n",
    template_body[64:99] %>%
      paste(collapse = "\n")
  )

  
  return(yaml_plus_body)
  
})




# temp[[1]] %>%
#   writeLines("./people/people/00003_example_fellow.qmd")
# 
# 
# 
# list.files("./people/people") %>%
#   grep("^\\d{5}_", ., value = TRUE) %>%
#   str_extract("\\d{5}") %>%
#   as.numeric() %>%
#   max()




pmap(list(temp, fellows_table$first_name, fellows_table$surname), ~{
  
  current_max_id <- list.files("./people/people") %>%
    grep("^\\d{5}_", ., value = TRUE) %>%
    str_extract("\\d{5}") %>%
    as.numeric() %>%
    max()
  
  new_id <- str_pad(as.character(current_max_id + 1), width = 5, side = "left", pad = "0")
  
  file_name <- glue::glue("./people/people/{new_id}_{..2}_{..3}.qmd") %>%
    str_to_lower() %>%
    str_replace_all(" ", "_") %>%
    str_replace_all("ä", "ae") %>%
    str_replace_all("ö", "oe") %>%
    str_replace_all("ü", "ue") %>%
    str_replace_all("ß", "ss")

  
  writeLines(..1, file_name)
  
})
