

library(dplyr)

news_csv <- read.csv("https://raw.githubusercontent.com/lmu-osc/osc-website-transfer/refs/heads/main/news_metadata.csv?token=GHSAT0AAAAAADRLIEF73GZ33O3UHNP26NQK2LQYSJA")


news_csv %>%
  tibble() %>%
  write.csv("news/news_metadata.csv")
