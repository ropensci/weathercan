## ---- include = FALSE, message = FALSE----------------------------------------
library(weathercan)
library(dplyr)
library(tidyr)

## ---- echo = FALSE--------------------------------------------------------------------------------
old <- options(width = 100)
w <- weather_dl(station_id = 5401, start =  "2017-01-01", 
                interval = "month", format = FALSE)

dplyr::select(w, station_name, `Date/Time`, 
              `Total Precip (mm)`, `Total Precip Flag`,
              `Snow Grnd Last Day (cm)`, `Snow Grnd Last Day Flag`) %>% 
  tail(n = 12)

## ---- echo = FALSE--------------------------------------------------------------------------------
weather_dl(station_id = 5401, start =  "2017-01-01", interval = "month") %>%
  dplyr::select(date, total_precip, total_precip_flag, snow_grnd_last_day, snow_grnd_last_day_flag) %>%
  tail(n = 12)

## ---- echo = FALSE--------------------------------------------------------------------------------
knitr::kable(flags)

## ---- echo = FALSE--------------------------------------------------------------------------------
n <- normals_dl(climate_ids = "5010480") %>%
  unnest(normals)
select(n, period, contains("temp_daily"))

## ---- echo = FALSE--------------------------------------------------------------------------------
knitr::kable(codes)

## ---- include = FALSE---------------------------------------------------------
# Reset options
options(old)

