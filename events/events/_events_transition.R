

library(tidyr)
library(dplyr)
library(readxl)
library(stringr)

events_new <- read_excel("events/events/_event_data_collector.xlsx")
events_current_file_names <- list.files("events/events/") %>%
  str_subset(".qmd") %>%
  tibble(current_file_names = .,
         current_name = TRUE) %>%
  mutate(current_file_names = paste0("events/events/", current_file_names))



# events_new %>%
#   select(file_paths) %>%
#   full_join(events_current_file_names, by = c("file_paths" = "current_file_names"), keep = TRUE) %>%
#   dplyr::filter(is.na(current_name) | is.na(file_paths)) %>%
#   rename(proposed_new_paths = file_paths) %>%
#   View()


# events_new %>%
#   select(file_paths) %>%
#   left_join(events_current_file_names, by = c("file_paths" = "current_file_names"), keep = TRUE) %>%
#   View()





# Function to update YAML in a .qmd file
update_event_yaml <- function(file_path, csv_row) {
  # Read the file
  file_lines <- readLines(file_path)
  
  # Find YAML boundaries
  yaml_end <- which(file_lines == "---")[2]
  
  # Get the body content (everything after YAML)
  body_content <- file_lines[(yaml_end + 1):length(file_lines)]
  
  # Helper function to safely get column value
  get_col <- function(col_name) {
    if(col_name %in% names(csv_row)) {
      val <- csv_row[[col_name]]
      if(length(val) > 0 && !is.na(val) && val != "") return(val)
    }
    return(NULL)
  }
  
  # Build new YAML structure from CSV data
  new_yaml <- list(
    date = get_col("event_start"),
    categories = if(!is.null(get_col("event_category"))) list(get_col("event_category")) else list()
  )
  
  # Build event section
  new_yaml$event <- list(
    title = get_col("event_title"),
    date = get_col("event_start"),
    end_date = get_col("event_end"),
    time = get_col("event_time"),
    location = list(
      name = get_col("location_name"),
      address = get_col("location_address"),
      map_url = get_col("location_map_url")
    ),
    format = list(
      type = get_col("format_type"),
      detail = get_col("format_detail")
    ),
    language = list(
      primary = get_col("language_primary"),
      `primary-code` = get_col("language_primary_code"),
      detail = get_col("language_detail")
    )
  )
  
  # Build links section
  new_yaml$links <- list(
    registration = get_col("registration_link"),
    materials = get_col("materials_link"),
    workshop_website = get_col("workshop_website")
  )
  
  new_yaml$event_description <- if(!is.null(get_col("event_description"))) {
    list(get_col("event_description"))
  } else {
    list()
  }
  
  # Handle instructors (columns: instructor1, url1_instr, instructor2, url2_instr, etc.)
  instructor_nums <- 1:10
  instructors <- lapply(instructor_nums, function(i) {
    name_col <- paste0("instructor", i)
    url_col <- paste0("url", i, "_instr")
    name_val <- get_col(name_col)
    url_val <- get_col(url_col)
    if(!is.null(name_val)) {
      list(name = name_val, url = url_val)
    } else {
      NULL
    }
  }) %>% purrr::compact()
  
  if(length(instructors) > 0) {
    new_yaml$instructors <- instructors
  }
  
  # Handle helpers (columns: helper1, helper2, etc.)
  helper_nums <- 1:10
  helpers <- lapply(helper_nums, function(i) {
    name_col <- paste0("helper", i)
    name_val <- get_col(name_col)
    if(!is.null(name_val)) {
      list(name = name_val)
    } else {
      NULL
    }
  }) %>% purrr::compact()
  
  if(length(helpers) > 0) {
    new_yaml$helpers <- helpers
  }
  
  # Build contact section
  new_yaml$contact <- list(
    name = get_col("contact_name"),
    email = get_col("contact_email")
  )
  
  # Handle organizers (columns: organizers1, url1_org, organizers2, url2_org, etc.)
  organizer_nums <- 1:10
  organizers <- lapply(organizer_nums, function(i) {
    name_col <- paste0("organizers", i)
    name_val <- get_col(name_col)
    if(!is.null(name_val)) {
      list(name = name_val)
    } else {
      NULL
    }
  }) %>% purrr::compact()
  
  if(length(organizers) > 0) {
    new_yaml$organizers <- organizers
  }
  
  # Convert to YAML string
  yaml_string <- yaml::as.yaml(new_yaml)
  
  # Write the file back
  writeLines(c("---", yaml_string, "---", body_content), file_path)
  
  return(TRUE)
}

# Process all events
for(i in seq_len(nrow(events_new))) {
  csv_row <- events_new[i, ]
  file_path <- csv_row$file_paths
  
  if(!is.na(file_path) && file.exists(file_path)) {
    message("Updating: ", file_path)
    update_event_yaml(file_path, csv_row)
  } else {
    message("Skipping - File not found or NA: ", file_path)
  }
}


