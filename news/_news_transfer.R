

library(dplyr)

news_csv <- read.csv("https://raw.githubusercontent.com/lmu-osc/osc-website-transfer/refs/heads/main/news_metadata.csv?token=GHSAT0AAAAAADRLIEF73GZ33O3UHNP26NQK2LQYSJA")


news_csv %>%
  tibble() %>%
  write.csv("news/news_metadata.csv")

# had Copilot manually generate file names

# ## Naming Patterns Used

# 1. **Newsletters**: Always `newsletter-{month}-{year}`
# 2. **Interviews**: Always `{person}-interview` 
# 3. **Job ads**: `job-ad-` or `stellenausschreibung-` for German
# 4. **New members**: `{number}-new-members` or `{dept}-joins-osc`
# 5. **Awards/Recognition**: Include award name (`enter-award`, `hochschulperle-award`, `dgps-award`)
# 6. **Reports**: `{topic}-report`
# 7. **Events**: Descriptive of the event type
# 8. **Papers**: `{topic}-paper-{status}` (e.g., `preprint`, `published`)

# ## Consistency Features

# - Hyphens only, no underscores
# - All lowercase
# - Removed special characters and German umlauts
# - Kept meaningful keywords from titles
# - Limited to 3-5 words per slug
# - Date format: YYYY-MM-DD

# ## Examples

# - `2025-07-22-newsletter-july-2025.qmd`
# - `2024-01-29-gollwitzer-schneck-interview.qmd`
# - `2024-07-15-job-ad-scientific-coordinator.qmd`
# - `2024-05-10-clusters-excellence-join-osc.qmd`
# - `2024-07-03-enter-award-received.qmd`
# - `2023-12-07-osc-impact-report-2017-2023.qmd`
# - `2021-04-21-multiplicity-paper-published.qmd`

final_news <- read.csv("news/news_metadata.csv") %>%
  tibble()
  
  
final_news %>%
  mutate(
    start_date = as.Date(start_date, format = "%d.%m.%Y")
  ) %>%
  select(
    start_date, news_title, subtitle, body_misc, body, filename
  ) %>%
  purrr::pmap(function(start_date, news_title, subtitle, body_misc, body, filename) {
    
    yaml <- glue::glue(
      "---\n",
      "title: \"{news_title}\"\n",
      "date: {start_date}\n",
      "subtitle: \"{subtitle}\"\n",
      "---\n\n"
    )
    
    content <- glue::glue(
      "{body_misc}\n\n{body}"
    )
    
    full_content <- glue::glue(
      "{yaml}\n{content}"
    )
    
    writeLines(full_content, con = paste0("news/news/", filename))
    
  })




# fix mistake of including NA from body_misc or body when no content from these is present

list.files("news/news", full.names = TRUE)[-1] %>%
  purrr::map(~{
    file <- readLines(.x)
    
    # remove lines that contain just "NA"
    file_cleaned <- file[file != "NA"]
    writeLines(file_cleaned, con = .x)
  })


