## ---- include = FALSE----------------------------------------------------
library(weathercan)
library(dplyr)

## ---- asis = TRUE, echo = FALSE------------------------------------------
temp <- glossary %>%
  mutate(http = stringr::str_detect(ECCC_ref, "http"),
         ECCC_ref = replace(ECCC_ref, http & !is.na(http), paste0("[ECCC glossary page](", ECCC_ref[http & !is.na(http)], ")")),
         ECCC_ref = replace(ECCC_ref, !http & !is.na(http), "[See the 'flags' vignette](flags.html)")) %>%
  select(Interval = interval, `ECCC Name` = ECCC_name, `Formatted weathercan name` = weathercan_name, units, Reference = ECCC_ref)
  
knitr::kable(temp)

