
library(dplyr)

event_files <- list.files("events", full.names = T) %>%
  grep(".yml", ., value = TRUE) %>%
  grep("meta", ., value = TRUE, invert = TRUE)


purrr::map(event_files, ~{
  lapply(event_files, function(p) yaml::read_yaml(p)) %>%
    purrr::map(~{ purrr::map(.x, ~{
      title <- gsub(" ", "_", .x$title)
      file_name <- paste0("events/events/", title, ".qmd", collapse = "_")
      yaml::write_yaml(.x, file = file_name)
    })
      })
}
)


event_qmds <- list.files("events/events", full.names = T) %>%
  grep(".qmd", ., value = TRUE)


purrr::map(event_qmds, ~{
  
  file <- readLines(.x)
  
  if (file[1] != "---") {
    file <- c("---", file, "---")
    writeLines(file, .x)
  }
  
})
