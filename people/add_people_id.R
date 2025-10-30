

file2 <- c("00001_felix example 2.qmd", 
           "00002_felix example 3.qmd",
           "00003_felix example 4.qmd")


# check if file already has 5 leading digits
str_detect(file2, "\\d{5}.*.qmd")

# create string for new max value
find_and_pad_next_id <- function(files) {
  # Extract the numeric part from the file names
  ids <- str_extract(file2, "\\d{5}") %>%
    as.numeric()
  
  # Find the maximum ID and increment it by 1
  next_id <- max(ids, na.rm = TRUE) + 1
  
  # Format the new ID with leading zeros
  str_pad(as.character(next_id), width = 5, side = "left", pad = "0")
}
# str_extract(file2, "\\d{5}") %>%
#     as.numeric() %>%
#     {max(.) + 1} %>%
#     str_pad(width = 5, side = "left", pad = "0") 


# find_current_max_id(file2)

# files <- c(list.files("./people/profiles"), file2)

# untagged_files <- files[!str_detect(files, "\\d{5}.*.qmd")]

# find_and_pad_next_id(file2)

find_current_max_id <- function(files) {
  # Extract the numeric part from the file names
  ids <- str_extract(files, "\\d{5}") %>%
    as.numeric()
  
  # Find the maximum ID
  if (all(is.na(ids)) | length(ids) == 0) {
    return(0)  # If no IDs found, return 0
  }
  max(ids, na.rm = TRUE)
}

tag_files <- function(files) {
    untagged_files <- files[!str_detect(files, "\\d{5}.*.qmd")]
    current_max_id <- find_current_max_id(files)
    new_labels <- vector("character", length(untagged_files))
    vec_position <- 0
    for (file in untagged_files) {
        vec_position <- vec_position + 1
        current_max_id <- current_max_id + 1
        new_label <- str_pad(as.character(current_max_id), width = 5, side = "left", pad = "0")
        new_labels[vec_position] <- paste0(new_label, "_", file)
    }
    return(new_labels)
}

# provided a vector with existing number tags
tag_files(files)

# bootstrap from 0 i.e. none of the # files have a 5 digit number tag
files[!str_detect(files, "\\d{5}.*.qmd")] %>%
tag_files()





   
