## ---- include = FALSE---------------------------------------------------------
library(weathercan)
library(dplyr)
library(tidyr)
library(stringr)

## ---- asis = TRUE, echo = FALSE-----------------------------------------------
glossary_normals[1:18,] %>%
  mutate(description = stringr::str_replace_all(description, "\\n", " ")) %>%
  knitr::kable()

## ---- echo = FALSE------------------------------------------------------------
g <- glossary_normals[19:nrow(glossary_normals),] %>%
  select(-description) %>%
  mutate(group = str_detect(weathercan_name, "title"),
         group = cumsum(group)) %>%
  filter(weathercan_name != "probability") %>%
  group_by(group) %>% 
  mutate(title = ECCC_name[1]) %>%
  group_by(title) %>%
  filter(!str_detect(weathercan_name, "title")) %>%
  select(-group) %>%
  nest()

## ---- results = "asis", echo = FALSE------------------------------------------
for(t in 1:nrow(g)) {
  cat("<center><h4>", str_to_title(g$title[t]), "</h3></center>\n")
  print(knitr::kable(g$data[[t]], format = "html"))
  cat("\n")
}

