library(magrittr)
## Get names expected from stations data download
w_names <- list(
  "hour" = c("time", "year", "month", "day", "hour", "qual", "temp", "temp_flag", "temp_dew", "temp_dew_flag", "rel_hum", "rel_hum_flag", "wind_dir", "wind_dir_flag", "wind_spd", "wind_spd_flag", "visib", "visib_flag", "pressure", "pressure_flag", "hmdx", "hmdx_flag", "wind_chill", "wind_chill_flag", "weather"),

  "day" = c("date", "year", "month", "day", "qual", "max_temp", "max_temp_flag", "min_temp", "min_temp_flag", "mean_temp", "mean_temp_flag", "heat_deg_days", "heat_deg_days_flag", "cool_deg_days", "cool_deg_days_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd", "snow_grnd_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag"),

  "month" = c("date", "year", "month", "mean_max_temp", "mean_max_temp_flag", "mean_min_temp", "mean_min_temp_flag", "mean_temp", "mean_temp_flag", "extr_max_temp", "extr_max_temp_flag", "extr_min_temp", "extr_min_temp_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd_last_day", "snow_grnd_last_day_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag")
)

devtools::use_data(w_names, overwrite = TRUE, internal = TRUE)

gloss <- list(
  "hour" = c(NA, NA, NA, NA, NA, NA, "temp", NA, "dewPnt", NA, "r_humidity", NA, "windDir", NA, "windSpd", NA, "visibility", NA, "stnPre", NA, "humidex", NA, "windChill", NA, "weatherState"),

  "day" = c(NA, NA, NA, NA, NA, "maxTemp", NA, "minTemp", NA, "meanTemp", NA, "hdd", NA, "cooling", NA, "totalRain", NA, "totalSnow", NA, "totalPrec", NA, "s_onGround", NA, "d_maxGust", NA, "s_maxGust", NA),

  "month" = c(NA, NA, NA, "meanMax", NA, "meanMin", NA, "meanTemp", NA, "extreme_maxtemp", NA, "extreme_mintemp", NA, "totalRain", NA, "totalSnow", NA, "totalPrec", NA, "s_lastDay", NA, "d_maxGust", NA, "s_maxGust", NA)
)

# Add flags data set to package data
# Get legend of flags (same for all intervals where duplicated)
flags <- dplyr::bind_rows(weather_dl(station_id = 51423,  date = as.Date("2014-01-01"),
                                     interval = "hour", nrows = 25, header = FALSE)[11:14,],
                          weather_dl(station_id = 51423,  date = as.Date("2014-01-01"),
                                     interval = "day", nrows = 25, header = FALSE)[10:23,],
                          weather_dl(station_id = 43823,  date = as.Date("2014-01-01"),
                                     interval = "month", nrows = 25, header = FALSE)[10:16,]) %>%
  dplyr::rename(code = V1, meaning = V2) %>%
  dplyr::distinct() %>%
  tibble::as_tibble()
devtools::use_data(flags, overwrite = TRUE)


wd1 <- weather_dl(station_id = 51423, date = as.Date("2014-01-01"), skip = 15, interval = "hour")
wd2 <- weather_dl(station_id = 51423, date = as.Date("2014-01-01"), skip = 25, interval = "day")
wd3 <- weather_dl(station_id = 43823, date = as.Date("2005-01-01"), skip = 17, interval = "month")

n <- c(names(wd1), names(wd2), names(wd3))

glossary <- tibble::tibble(interval = c(rep("hour", length(names(wd1))),
                                             rep("day", length(names(wd2))),
                                             rep("month", length(names(wd3)))),
                                ECCC_name = n,
                                weathercan_name = unlist(w_names),
                                units = stringr::str_replace_all(stringr::str_extract(n, "\\(.*\\)"),
                                                                 "\\(|\\)", ""),
                                ECCC_ref = paste0("http://climate.weather.gc.ca/glossary_e.html#", unlist(gloss))) %>%
  dplyr::mutate(ECCC_ref = replace(ECCC_ref,
                                   weathercan_name == "qual",
                                   "http://climate.weather.gc.ca/climate_data/data_quality_e.html"),
                ECCC_ref = replace(ECCC_ref, stringr::str_detect(weathercan_name, "_flag"), "See `flags` vignette or dataset for more details"),
                ECCC_ref = replace(ECCC_ref, stringr::str_detect(ECCC_ref, "#NA"), NA),
                units = replace(units, weathercan_name %in% c("year", "month", "day", "hour"),
                                weathercan_name[weathercan_name %in% c("year", "month", "day", "hour")]),
                ECCC_ref = replace(ECCC_ref, weathercan_name %in% c("year", "month", "day", "hour"),
                                   "http://climate.weather.gc.ca/glossary_e.html#dataInt"),
                units = replace(units, weathercan_name == "time", "ISO date/time"),
                units = replace(units, weathercan_name == "date", "ISO date"),
                units = replace(units, weathercan_name %in% c("hmdx", "wind_chill"), "index"),
                units = replace(units, stringr::str_detect(weathercan_name, c("(qual)|(_flag)|(weather)")), "note"))
devtools::use_data(glossary, overwrite = TRUE)


# Technical documentation: ftp://ftp.tor.ec.gc.ca/Pub/Documentation_Technical/Technical_Documentation.pdf
