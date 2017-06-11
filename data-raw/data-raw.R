## Get up-to-date stations data
stations <- stations_all()
devtools::use_data(stations, overwrite = TRUE)

write.csv(stations, "./data-raw/stations.csv", row.names = FALSE)

## Get names expected from stations data download
w_names <- list(
  "hour" = c("time", "year", "month", "day", "hour", "qual", "temp", "temp_flag", "temp_dew", "temp_dew_flag", "rel_hum", "rel_hum_flag", "wind_dir", "wind_dir_flag", "wind_spd", "wind_spd_flag", "visib", "visib_flag", "pressure", "pressure_flag", "hmdx", "hmdx_flag", "wind_chill", "wind_chill_flag", "weather"),

  "day" = c("date", "year", "month", "day", "qual", "max_temp", "max_temp_flag", "min_temp", "min_temp_flag", "mean_temp", "mean_temp_flag", "heat_deg_days", "heat_deg_days_flag", "cool_deg_days", "cool_deg_days_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd", "snow_grnd_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag"),

  "month" = c("date", "year", "month", "mean_max_temp", "mean_max_temp_flag", "mean_min_temp", "mean_min_temp_flag", "mean_temp", "mean_temp_flag", "extr_max_temp", "extr_max_temp_flag", "extr_min_temp", "extr_min_temp_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd_last_day", "snow_grnd_last_day_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag")
)
devtools::use_data(w_names, overwrite = TRUE, internal = TRUE)

kamloops_day <- weather(51423, start = "2016-01-01", end = "2016-06-30", interval = "day")
devtools::use_data(kamloops_day, overwrite = TRUE)

kamloops <- weather(51423, start = "2016-01-01", end = "2016-06-30")
devtools::use_data(kamloops, overwrite = TRUE)

pg <- weather(48370, start = "2016-01-01", end = "2016-06-30")
devtools::use_data(pg, overwrite = TRUE)

# with Daylight savings on March 13th (AM)
finches <- feedr::dl_data(start = "2016-03", end = "2016-03-16")
finches <- tibble::as_tibble(finches)

devtools::use_data(finches, overwrite = TRUE)
