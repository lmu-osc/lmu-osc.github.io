

library(readr)
library(dplyr)

read_csv("cspell-flagged-words.csv") %>%
  count(word) %>%
  arrange(desc(n)) %>%
  View()


  # dplyr::filter(n > 1) %>%
  # pull(word) %>%
  # paste(collapse = "\n  - ") %>%
  # cat()
  # 
  # 
  # 
  # View()
