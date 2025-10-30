

library(dplyr)
library(tidyr)
library(rvest)
library(xml2)

events_file <- readr::read_csv('https://raw.githubusercontent.com/lmu-osc/osc-website-transfer/refs/heads/main/events_metadata.csv?token=GHSAT0AAAAAADNSJCJMRK4LXP7PIKCFHHKE2IDJVWA')


events_file %>%
  names()
  
View(events_file)


to_yyyymmdd <- function(x) format(as.Date(x, format = "%B %d, %Y"), "%Y%m%d")


process_html <- function(html_string) {
  # return empty string for NA / NULL / zero-length
  if (is.null(html_string) || (length(html_string) == 1 && is.na(html_string)) ||
      (!is.character(html_string) && !is.list(html_string))) {
    return("")
  }
  s <- as.character(html_string)
  if (!nzchar(trimws(s))) return("")
  
  doc <- read_html(s)
  
  xpath_wrapper <- "//div[contains(concat(' ', normalize-space(@class), ' '), ' user-html ') and contains(concat(' ', normalize-space(@class), ' '), ' hauptinhalt ')]"
  wrapper_nodes <- xml_find_all(doc, xpath_wrapper)
  
  remove_hinterlegt <- function(node) {
    nodes_to_remove <- xml_find_all(node, ".//p[contains(concat(' ', normalize-space(@class), ' '), ' hinterlegt ')]")
    if (length(nodes_to_remove) > 0) xml_remove(nodes_to_remove)
  }
  
  if (length(wrapper_nodes) > 0) {
    wrapper <- wrapper_nodes[[1]]
    remove_hinterlegt(wrapper)
    children <- xml_children(wrapper)
    out <- paste0(vapply(children, as.character, character(1)), collapse = "")
    return(out)
  } else {
    # no wrapper: remove p.hinterlegt anywhere and return body children
    remove_hinterlegt(doc)
    body <- xml_find_first(doc, "//body")
    if (!is.na(body) && length(xml_children(body)) > 0) {
      out <- paste0(vapply(xml_children(body), as.character, character(1)), collapse = "")
    } else {
      out <- as.character(doc)
    }
    return(out)
  }
}









(mapping <- tribble(
  ~csvNames, ~expectedNames,
  'event_type', 'categories',
  "workshop_title", "event.title",
  "date", "event.date",
  "end_date", "event.end_date",
  "time", "event.time",
  "location", "event.location.name",
  "Language", "event.language.primary",
  "lang_code", "event.language.primary-code",
  "lang_detail", "event.language.detail",
  "Contact", "contact.name",
  "clean_html", "body_content"
))


events_formatted <- events_file %>%
  separate(
    "workshop_date",
    into = c("date", "end_date"),
    sep =  "–",
    remove = FALSE
  ) %>%
  mutate(date = trimws(date) %>%
           as.Date(format = "%d.%m.%Y") %>%
           format(format = "%B %d, %Y"),
         end_date = trimws(end_date) %>%
           as.Date(format = "%d.%m.%Y") %>%
           format(format = "%B %d, %Y")
  ) %>%
  separate(
    Date,
    into = c("preportion", "time"),
    sep =  ",",
    remove = FALSE
  ) %>%
  mutate(
    time = trimws(time)
  ) %>%
  mutate(
    date = if_else(
      is.na(date), 
      trimws(preportion) %>%
        as.Date(format = "%d.%m.%Y") %>%
        format(format = "%B %d, %Y"), 
      date
      )
  ) %>%
  rename(
    location = Place
  ) %>%
  mutate(
    lang_code = case_when(
      Language == "English" ~ "en",
      Language == "German" ~ "de",
      stringr::str_detect(Language, "^German") ~ "de",
      TRUE ~ "en"
    ),
    lang_detail = case_when(
      (Language %in% c("German and English", "German/ English")) ~ "de/en",
      (Language %in% c("English and German", "English/ German")) ~ "en/de",
      TRUE ~ NA_character_
    ),
    .after = Language
  ) %>%
  mutate(
    workshop_title = if_else(is.na(workshop_title), Description, workshop_title)
  ) %>%
  mutate(
    date = case_when(
      stringr::str_detect(preportion, "28.-31.10.2024") ~ "October 28, 2024",
      stringr::str_detect(preportion, "05.-06.10.2023") ~ "October 05, 2023",
      stringr::str_detect(preportion, "Jan. 2018") ~ "January 01, 2018",
      TRUE ~ date
    ),
    end_date = case_when(
      stringr::str_detect(preportion, "28.-31.10.2024") ~ "October 31, 2024",
      stringr::str_detect(preportion, "05.-06.10.2023") ~ "October 06, 2023",
      stringr::str_detect(preportion, "Jan. 2018") ~ "January 01, 2018",
      TRUE ~ date
    )
  ) %>%
  mutate(
    file_name = tolower(workshop_title) %>%
      stringr::str_remove(".*:") %>%
      stringr::str_remove_all("\"") %>%
      stringr::str_remove_all("/") %>%
      stringr::str_remove_all("—|-") %>%
      stringr::str_remove_all("\\”") %>%
      stringi::stri_trans_general("Latin-ASCII") %>%
      stringr::str_remove_all('"') %>%
      stringr::str_remove_all('\\?|\\.') %>%
      stringr::str_remove_all(',') %>%
      stringr::str_replace_all("&", "and") %>%
      trimws("left") %>%
      stringr::str_replace_all(" ", "_"),
    event_date_crushed = to_yyyymmdd(date),
    file_name = paste0(event_date_crushed, "_", file_name, ".qmd"),
    .after = workshop_title
  ) %>%
  mutate(
    workshop_title = stringr::str_replace_all(workshop_title, "'", "''")
  ) %>%
  mutate(clean_html = purrr::map_chr(workshop_page_description, process_html))




events_formatted_final <- events_formatted %>%
  select(
    all_of(mapping$csvNames)
  ) %>%
  rename_with(~mapping$expectedNames) 



purrr::pmap(events_formatted_final, function(categories, event.title, event.date, event.end_date,
                                             event.time, event.location.name, event.language.primary,
                                             `event.language.primary-code`, event.language.detail, contact.name, 
                                             body_content, ...) {
  
yaml <- glue::glue(
"---\n",
"format:
    html:
        table-of-contents: false
        css: event-page-styles.css
page-layout: full"
)
  
  yaml <- glue::glue(yaml, "\n", "pagetitle:", " '", event.title, "'")
  
  yaml <- glue::glue(yaml, "\n\n", "# Event categories\n")
  yaml <- glue::glue(yaml, "\n", "event:\n")
  yaml <- glue::glue(yaml, "\n", "  title:", " '", event.title, "'")
  yaml <- glue::glue(yaml, "\n", "  description: \"\"")
  yaml <- glue::glue(yaml, "\n", "  categories: ", " '", categories, "'")
  yaml <- glue::glue(yaml, "\n", "  date:", " \"", event.date, "\"")
  yaml <- glue::glue(yaml, "\n", "  end_date:", " \"", event.end_date, "\"")
  yaml <- glue::glue(yaml, "\n", "  time:", " \"", event.time, "\"")
  
  
  yaml <- glue::glue(yaml, "\n", "  location:\n")
  yaml <- glue::glue(yaml, "\n", "    name:", " \"", event.location.name, "\"")
  yaml <- glue::glue(yaml, "\n", "    address: \"\"")
  yaml <- glue::glue(yaml, "\n", "    map_url: \"\"")
  
  yaml <- glue::glue(yaml, "\n", "  format:\n")
  yaml <- glue::glue(yaml, "\n", "    type:", " '", categories, "'")
  yaml <- glue::glue(yaml, "\n", "    detail: \"\"")
  
  yaml <- glue::glue(yaml, "\n", "  language:\n")
  yaml <- glue::glue(yaml, "\n", "    primary:", " \"", event.language.primary, "\"")
  yaml <- glue::glue(yaml, "\n", "    primary-code:", " \"", `event.language.primary-code`, "\"")
  yaml <- glue::glue(yaml, "\n", "    detail:", " \"", event.language.detail, "\"")
  
  yaml <- glue::glue(yaml, "\nlinks:")
  yaml <- glue::glue(yaml, "\n  registration: \"\"")
  yaml <- glue::glue(yaml, "\n  materials: \"\"")
  yaml <- glue::glue(yaml, "\n  workshop_website: \"\"")
  
  yaml <- glue::glue(yaml, "\n\nevent_description:")
  yaml <- glue::glue(yaml, "\n  - \"\"")
  
  yaml <- glue::glue(yaml, "\n\ninstructors:")
  yaml <- glue::glue(yaml, "\n  - name: \"\"")
  yaml <- glue::glue(yaml, "\n    url: \"\"")
  
  yaml <- glue::glue(yaml, "\n\nhelpers:")
  yaml <- glue::glue(yaml, "\n  - name: \"\"")
  
  yaml <- glue::glue(yaml, "\n\ncontact:")
  yaml <- glue::glue(yaml, "\n  name: \"\"")
  yaml <- glue::glue(yaml, "\n  email: \"\"")
  
  yaml <- glue::glue(yaml, "\n---\n")
  
  whole_file <- glue::glue(
    yaml,
    "\n",
    '<!-- MANDAORY SECTION START  -->
<link rel = "stylesheet"  href = "https://cdn.jsdelivr.net/npm/bootstrap-icons@5.6.2/font/bootstrap-icons.css">

<h1 class="fs-1 text-primary"> {{{{< meta event.title >}}}} </h1>

{{{{< include templates/_setup.qmd >}}}}
{{{{< include templates/_info_boxes.qmd >}}}}
{{{{< include templates/_register_button.qmd >}}}}
<!-- MANDAORY SECTION END  -->



<!-- DETAILED EVENT DESCRIPTION HERE OR USE THE TEMPLATE BELOW TO INCLUDE THE STANDARD DESCRIPTION SECTION -->
<!-- {{{{< include templates/_event_description.qmd >}}}} -->

{body_content}



<!-- MANDAORY SECTION START  -->
<!-- _event_description.qmd template should always be at bottom -->
{{{{< include templates/_instructors_helpers_contact.qmd >}}}}
<!-- MANDAORY SECTION END  -->'
  )
  
  return(whole_file)
  
}) %>%
  purrr::walk2(events_formatted$file_name, ~{
    writeLines(.x, con = file.path("events/events", .y))
  })





