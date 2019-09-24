## ---- include = FALSE-------------------------------------------------------------------
knitr::opts_chunk$set(cache = FALSE)
options(tibble.max_extra_cols = 0, width = 90)

## ---- message = FALSE-------------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(weathercan)

## ---------------------------------------------------------------------------------------
head(stations)

## ---------------------------------------------------------------------------------------
stations_search("Kamloops")

## ---------------------------------------------------------------------------------------
stations_search("Kamloops", interval = "hour")

## ---------------------------------------------------------------------------------------
stations_search("Kamloops", interval = c("hour", "month"))

## ---------------------------------------------------------------------------------------
stations_search(coords = c(50.667492, -120.329049), dist = 20, interval = "hour")

## ----search_crit------------------------------------------------------------------------
BCstations <- stations %>%
  filter(prov %in% c("BC")) %>%
  filter(interval == "hour") %>%
  filter(lat > 49 & lat < 49.5) %>%
  filter(lon > -119 & lon < -116) %>%
  filter(start <= 2002) %>%
  filter(end >= 2016)
BCstations

## weather_dl() accepts numbers so we can create a vector to input into weather:
stn_vector <- BCstations$station_id 
stn_vector

## ---- eval = FALSE----------------------------------------------------------------------
#  s <- stations_dl() # Download complete stations list
#  stations_search("Saskatoon", stn = s) # Specify the new stations list to search

## ---------------------------------------------------------------------------------------
kam <- weather_dl(station_ids = 51423, start = "2016-01-01", end = "2016-02-15")
                    
kam

## ---------------------------------------------------------------------------------------
kam.pg <- weather_dl(station_ids = c(48248, 51423), start = "2016-01-01", end = "2016-02-15")
                    
kam.pg

## ---- fig.height=6, fig.width=12--------------------------------------------------------
ggplot(data = kam.pg, aes(x = time, y = temp, group = station_name, colour = station_name)) +
  theme(legend.position = "top") +
  geom_line() +
  theme_minimal()

## ----vector_input-----------------------------------------------------------------------
stn_vec_df <- weather_dl(station_ids = stn_vector, start = "2016-01-01", end = "2016-02-15")

stn_vec_df

