

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



events_new <- events_new %>%
  mutate(
    event_start = format(as.Date(event_start, format = "%d-%b-%y"), "%Y-%m-%d"),
    event_end = format(as.Date(event_end, format = "%d-%b-%y"), "%Y-%m-%d")
  ) 


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





# Function to recursively merge two lists, with new_list values taking precedence
merge_lists <- function(existing, new) {
  if(is.null(new) || (is.list(new) && length(new) == 0)) {
    return(existing)
  }
  if(is.null(existing)) {
    return(new)
  }
  
  # If both are lists, merge recursively
  if(is.list(existing) && is.list(new)) {
    all_names <- unique(c(names(existing), names(new)))
    result <- existing
    
    for(name in all_names) {
      if(name %in% names(new)) {
        result[[name]] <- merge_lists(existing[[name]], new[[name]])
      }
    }
    return(result)
  }
  
  # Otherwise, new value overwrites
  return(new)
}

# Function to update YAML in a .qmd file
update_event_yaml <- function(file_path, csv_row) {
  # Read the file
  file_lines <- readLines(file_path)
  
  # Find YAML boundaries
  yaml_end <- which(file_lines == "---")[2]
  
  # Parse existing YAML
  yaml_lines <- file_lines[1:yaml_end]
  existing_yaml <- yaml::yaml.load(paste(yaml_lines, collapse = "\n"))
  
  # Get the body content (everything after YAML)
  body_content <- file_lines[(yaml_end + 1):length(file_lines)]
  
  # Helper function to safely get column value
  get_col <- function(col_name) {
    if(col_name %in% names(csv_row)) {
      val <- csv_row[[col_name]]
      # Check if value exists, is not NA, and is not empty string
      if(length(val) > 0) {
        # Use isTRUE to safely check conditions
        if(isTRUE(!is.na(val)) && isTRUE(val != "")) {
          # Always return as character to preserve formatting (especially for dates)
          return(as.character(val))
        }
      }
    }
    return(NULL)
  }
  
  # Build updates from CSV data (only non-null values)
  updates <- list()
  
  # Top-level fields
  if(!is.null(get_col("event_start"))) {
    updates$date <- get_col("event_start")
  }
  if(!is.null(get_col("event_category"))) {
    updates$categories <- list(get_col("event_category"))
  }
  
  # Build event section updates
  event_updates <- list()
  if(!is.null(get_col("event_title"))) event_updates$title <- get_col("event_title")
  if(!is.null(get_col("event_start"))) event_updates$date <- get_col("event_start")
  
  # Handle end_date - if same as start_date, set to empty string
  start_date_val <- get_col("event_start")
  end_date_val <- get_col("event_end")
  if(!is.null(start_date_val) && !is.null(end_date_val) && start_date_val == end_date_val) {
    event_updates$end_date <- ""
  } else if(!is.null(end_date_val)) {
    event_updates$end_date <- end_date_val
  }
  
  # Handle time field - convert NA to empty string
  time_val <- csv_row$event_time
  if(length(time_val) > 0 && !is.na(time_val) && time_val != "") {
    event_updates$time <- as.character(time_val)
  } else {
    event_updates$time <- ""
  }
  
  # Location updates
  location_updates <- list()
  if(!is.null(get_col("location_name"))) location_updates$name <- get_col("location_name")
  if(!is.null(get_col("location_address"))) location_updates$address <- get_col("location_address")
  if(!is.null(get_col("location_map_url"))) location_updates$map_url <- get_col("location_map_url")
  if(length(location_updates) > 0) event_updates$location <- location_updates
  
  # Format updates
  format_updates <- list()
  if(!is.null(get_col("format_type"))) format_updates$type <- get_col("format_type")
  if(!is.null(get_col("format_detail"))) format_updates$detail <- get_col("format_detail")
  if(length(format_updates) > 0) event_updates$format <- format_updates
  
  # Language updates
  language_updates <- list()
  if(!is.null(get_col("language_primary"))) language_updates$primary <- get_col("language_primary")
  if(!is.null(get_col("language_primary_code"))) language_updates$`primary-code` <- get_col("language_primary_code")
  if(!is.null(get_col("language_detail"))) language_updates$detail <- get_col("language_detail")
  if(length(language_updates) > 0) event_updates$language <- language_updates
  
  if(length(event_updates) > 0) updates$event <- event_updates
  
  # Build links section updates
  links_updates <- list()
  if(!is.null(get_col("registration_link"))) links_updates$registration <- get_col("registration_link")
  if(!is.null(get_col("materials_link"))) links_updates$materials <- get_col("materials_link")
  if(!is.null(get_col("workshop_website"))) links_updates$workshop_website <- get_col("workshop_website")
  if(length(links_updates) > 0) updates$links <- links_updates
  
  # Event description
  if(!is.null(get_col("event_description"))) {
    updates$event_description <- list(get_col("event_description"))
  }
  
  # Handle instructors (columns: instructor1, url1_instr, instructor2, url2_instr, etc.)
  instructor_nums <- 1:15
  instructors <- lapply(instructor_nums, function(i) {
    name_col <- paste0("instructor", i)
    url_col <- paste0("url", i, "_instr")
    name_val <- get_col(name_col)
    url_val <- get_col(url_col)
    if(!is.null(name_val)) {
      list(name = name_val, url = if(is.null(url_val)) "" else url_val)
    } else {
      NULL
    }
  }) %>% purrr::compact()
  
  if(length(instructors) > 0) {
    updates$instructors <- instructors
  }
  
  # Handle presenters (columns: presenter1, url_pres1, presenter2, url_pres2, etc.)
  presenter_nums <- 1:15
  presenters <- lapply(presenter_nums, function(i) {
    name_col <- paste0("presenter", i)
    url_col <- paste0("url_pres", i)
    name_val <- get_col(name_col)
    url_val <- get_col(url_col)
    if(!is.null(name_val)) {
      list(name = name_val, url = if(is.null(url_val)) "" else url_val)
    } else {
      NULL
    }
  }) %>% purrr::compact()
  
  if(length(presenters) > 0) {
    updates$presenters <- presenters
  }
  
  # Handle helpers (columns: helper1, url_help1, helper2, url_help2, etc.)
  helper_nums <- 1:15
  helpers <- lapply(helper_nums, function(i) {
    name_col <- paste0("helper", i)
    url_col <- paste0("url_help", i)
    name_val <- get_col(name_col)
    url_val <- get_col(url_col)
    if(!is.null(name_val)) {
      list(name = name_val, url = if(is.null(url_val)) "" else url_val)
    } else {
      NULL
    }
  }) %>% purrr::compact()
  
  if(length(helpers) > 0) {
    updates$helpers <- helpers
  }
  
  # Handle hosts (columns: host1, url_host1, host2, url_host2, etc.)
  host_nums <- 1:15
  hosts <- lapply(host_nums, function(i) {
    name_col <- paste0("host", i)
    url_col <- paste0("url_host", i)
    name_val <- get_col(name_col)
    url_val <- get_col(url_col)
    if(!is.null(name_val)) {
      list(name = name_val, url = if(is.null(url_val)) "" else url_val)
    } else {
      NULL
    }
  }) %>% purrr::compact()
  
  if(length(hosts) > 0) {
    updates$host <- hosts  # Note: singular 'host' for YAML field name
  }
  
  # Build contact section updates
  contact_updates <- list()
  if(!is.null(get_col("contact_name"))) contact_updates$name <- get_col("contact_name")
  if(!is.null(get_col("contact_email"))) contact_updates$email <- get_col("contact_email")
  if(length(contact_updates) > 0) updates$contact <- contact_updates
  
  # Handle organizers (columns: organizers1, url1_org, organizers2, url2_org, etc.)
  organizer_nums <- 1:15
  organizers <- lapply(organizer_nums, function(i) {
    name_col <- paste0("organizers", i)
    url_col <- paste0("url", i, "_org")
    name_val <- get_col(name_col)
    url_val <- get_col(url_col)
    if(!is.null(name_val)) {
      list(name = name_val, url = if(is.null(url_val)) "" else url_val)
    } else {
      NULL
    }
  }) %>% purrr::compact()
  
  if(length(organizers) > 0) {
    updates$organizers <- organizers
  }
  
  # Merge existing YAML with updates
  merged_yaml <- merge_lists(existing_yaml, updates)
  
  # Convert to YAML string
  yaml_string <- yaml::as.yaml(merged_yaml)
  
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


