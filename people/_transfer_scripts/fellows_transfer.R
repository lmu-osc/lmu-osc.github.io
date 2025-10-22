

library(readr)
library(dplyr)
library(stringr)
library(purrr)
library(magrittr)


fellows_raw_url <- "https://raw.githubusercontent.com/lmu-osc/osc-website-transfer/refs/heads/main/fellow_members.csv?token=GHSAT0AAAAAADNSJCJM2J2Y2IVCMODKVVSS2HXJ3QQ"

fellows_table <- read_csv(fellows_raw_url) %>%
  mutate(email = str_remove(email, "mailto:")) %>%
  mutate(description_section_2 = if_else(
    description_section_1 != "<em><strong>Mission Statement:</strong></em>",
    description_section_1,
    description_section_2)
    )


fellows_table %<>%
  mutate(
    Position = if_else(First_name == "Maximilian" & Surname == "Kristen",
                       "MSc Student",
                       Position),
    Position = if_else(First_name == "Leonhard" & Surname == "Schramm",
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


quarto_page <- fellows_table %>%
  select(Surname, First_name, Title, Position, Faculty, Department, email,
         matches("website"), matches("description"), new_image_name) %>%
  pmap(function(Surname, First_name, Title, Position, Faculty, Department, email,
                website_1, website_2, description_section_1, description_section_2,
                description_section_3, description_section_4, description_section_5,
                new_image_name) {
  
  
  yaml <- glue::glue(
    "---\n",
    "title: {First_name} {Surname}\n",
    "academic_title: {Title}\n",
    "name: {First_name} {Surname}\n",
    "surname: {Surname}\n",
    "first_name: {First_name}\n",
    "position: {Position}\n",
    "faculty: {Faculty}\n",
    "membertype: ['fellow']\n",
    "email: {email}\n"
  )
  
  if (!is.na(new_image_name)) {
    yaml <- glue::glue(
      yaml, "\n",
      "photo: 'images/{new_image_name}'\n"
    )
  }
  
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




# quarto_page[[1]] %>%
#   writeLines("./people/people/00003_example_fellow.qmd")
# 
# 
# 
# list.files("./people/people") %>%
#   grep("^\\d{5}_", ., value = TRUE) %>%
#   str_extract("\\d{5}") %>%
#   as.numeric() %>%
#   max()




pmap(list(quarto_page, fellows_table$First_name, fellows_table$Surname), ~{
  
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
    str_replace_all("ß", "ss") %>%
    stringi::stri_trans_general("Latin-ASCII")

  
  writeLines(..1, file_name)
  
})
