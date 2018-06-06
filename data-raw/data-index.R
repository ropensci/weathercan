library(magrittr)

## Get names expected from stations data download

p_names <- c("station_name", "station_id", "prov", "lat", "lon", "elev",
             "climate_id", "WMO_id", "TC_id")

w_names <- list(
  "hour" = c("time" = "Date/Time", "year" = "Year", "month" = "Month",
             "day" = "Day", "hour" = "Time",
             "qual" = "Data Quality",
             "temp" = paste0("Temp (\U00B0","C)"), "temp_flag" = "Temp Flag",
             "temp_dew" = paste0("Dew Point Temp (\U00B0","C)"),
             "temp_dew_flag" = "Dew Point Temp Flag",
             "rel_hum" = "Rel Hum (%)", "rel_hum_flag" = "Rel Hum Flag",
             "wind_dir" = "Wind Dir (10s deg)",
             "wind_dir_flag" = "Wind Dir Flag",
             "wind_spd" = "Wind Spd (km/h)", "wind_spd_flag" = "Wind Spd Flag",
             "visib" = "Visibility (km)", "visib_flag" = "Visibility Flag",
             "pressure" = "Stn Press (kPa)", "pressure_flag" = "Stn Press Flag",
             "hmdx" = "Hmdx", "hmdx_flag" = "Hmdx Flag",
             "wind_chill" = "Wind Chill", "wind_chill_flag" = "Wind Chill Flag",
             "weather" = "Weather"),
  "day" = c("date" = "Date/Time", "year" = "Year",
            "month" = "Month", "day" = "Day",
            "qual" = "Data Quality",
            "max_temp" = paste0("Max Temp (\U00B0","C)"), "max_temp_flag" = "Max Temp Flag",
            "min_temp" = paste0("Min Temp (\U00B0","C)"), "min_temp_flag" = "Min Temp Flag",
            "mean_temp" = paste0("Mean Temp (\U00B0","C)"), "mean_temp_flag" = "Mean Temp Flag",
            "heat_deg_days" = paste0("Heat Deg Days (\U00B0","C)"),
            "heat_deg_days_flag" = "Heat Deg Days Flag",
            "cool_deg_days" = paste0("Cool Deg Days (\U00B0","C)"),
            "cool_deg_days_flag" = "Cool Deg Days Flag",
            "total_rain" = "Total Rain (mm)",
            "total_rain_flag" = "Total Rain Flag",
            "total_snow" = "Total Snow (cm)",
            "total_snow_flag" = "Total Snow Flag",
            "total_precip" = "Total Precip (mm)",
            "total_precip_flag" = "Total Precip Flag",
            "snow_grnd" = "Snow on Grnd (cm)",
            "snow_grnd_flag" = "Snow on Grnd Flag",
            "dir_max_gust" = "Dir of Max Gust (10s deg)",
            "dir_max_gust_flag" = "Dir of Max Gust Flag",
            "spd_max_gust" = "Spd of Max Gust (km/h)",
            "spd_max_gust_flag" = "Spd of Max Gust Flag"),
  "month" = c("date" = "Date/Time", "year" = "Year", "month" = "Month",
              "mean_max_temp" = paste0("Mean Max Temp (\U00B0","C)"),
              "mean_max_temp_flag" = "Mean Max Temp Flag",
              "mean_min_temp" = paste0("Mean Min Temp (\U00B0","C)"),
              "mean_min_temp_flag" = "Mean Min Temp Flag",
              "mean_temp" = paste0("Mean Temp (\U00B0","C)"),
              "mean_temp_flag" = "Mean Temp Flag",
              "extr_max_temp" = paste0("Extr Max Temp (\U00B0","C)"),
              "extr_max_temp_flag" = "Extr Max Temp Flag",
              "extr_min_temp" = paste0("Extr Min Temp (\U00B0","C)"),
              "extr_min_temp_flag" = "Extr Min Temp Flag",
              "total_rain" = "Total Rain (mm)",
              "total_rain_flag" = "Total Rain Flag",
              "total_snow" = "Total Snow (cm)",
              "total_snow_flag" = "Total Snow Flag",
              "total_precip" = "Total Precip (mm)",
              "total_precip_flag" = "Total Precip Flag",
              "snow_grnd_last_day" = "Snow Grnd Last Day (cm)",
              "snow_grnd_last_day_flag" = "Snow Grnd Last Day Flag",
              "dir_max_gust" = "Dir of Max Gust (10's deg)",
              "dir_max_gust_flag" = "Dir of Max Gust Flag",
              "spd_max_gust" = "Spd of Max Gust (km/h)",
              "spd_max_gust_flag" = "Spd of Max Gust Flag")
)

# w_names <- list(
#   "hour" = c("time", "year", "month", "day", "hour", "qual", "temp", "temp_flag", "temp_dew", "temp_dew_flag", "rel_hum", "rel_hum_flag", "wind_dir", "wind_dir_flag", "wind_spd", "wind_spd_flag", "visib", "visib_flag", "pressure", "pressure_flag", "hmdx", "hmdx_flag", "wind_chill", "wind_chill_flag", "weather"),
#
#   "day" = c("date", "year", "month", "day", "qual", "max_temp", "max_temp_flag", "min_temp", "min_temp_flag", "mean_temp", "mean_temp_flag", "heat_deg_days", "heat_deg_days_flag", "cool_deg_days", "cool_deg_days_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd", "snow_grnd_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag"),
#
#   "month" = c("date", "year", "month", "mean_max_temp", "mean_max_temp_flag", "mean_min_temp", "mean_min_temp_flag", "mean_temp", "mean_temp_flag", "extr_max_temp", "extr_max_temp_flag", "extr_min_temp", "extr_min_temp_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd_last_day", "snow_grnd_last_day_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag")
# )

devtools::use_data(w_names, p_names, overwrite = TRUE, internal = TRUE)

# Add flags data set to package data
# Get legend of flags (same for all intervals where duplicated)
flags <- dplyr::bind_rows(weather_raw(station_id = 51423,  date = as.Date("2014-01-01"),
                                      interval = "hour", nrows = 25, header = FALSE)[11:14,],
                          weather_raw(station_id = 51423,  date = as.Date("2014-01-01"),
                                      interval = "day", nrows = 25, header = FALSE)[10:23,],
                          weather_raw(station_id = 43823,  date = as.Date("2014-01-01"),
                                      interval = "month", nrows = 25, header = FALSE)[10:16,]) %>%
  dplyr::rename(code = V1, meaning = V2) %>%
  dplyr::distinct() %>%
  dplyr::as_tibble()
devtools::use_data(flags, overwrite = TRUE)


gloss_url <- list(
  "hour" = c("temp" = "temp", "temp_dew" = "dewPnt", "rel_hum" = "r_humidity",
             "wind_dir" = "windDir", "wind_spd" = "windSpd",
             "visib" = "visibility", "pressure" = "stnPre", "hmdx" = "humidex",
             "wind_chill" = "windChill", "weather" = "weatherState"),
  "day" = c("max_temp" = "maxTemp", "min_temp" = "minTemp",
            "mean_temp" = "meanTemp", "heat_deg_days" = "hdd",
            "cool_deg_days" = "cooling", "total_rain" = "totalRain",
            "total_snow" = "totalSnow", "total_precip" = "totalPrec",
            "snow_grnd" = "s_onGround", "dir_max_gust" = "d_maxGust",
            "spd_max_gust" = "s_maxGust"),
  "month" = c("mean_max_temp" = "meanMax", "mean_min_temp" = "meanMin",
              "mean_temp" = "meanTemp", "extr_max_temp" = "extreme_maxtemp",
              "extr_min_temp" = "extreme_mintemp", "total_rain" = "totalRain",
              "total_snow" = "totalSnow", "total_precip" = "totalPrec",
              "snow_grnd_last_day" = "s_lastDay", "dir_max_gust" = "d_maxGust",
              "spd_max_gust" = "s_maxGust")
) %>%
  lapply(., utils::stack) %>%
  lapply(., FUN = function(x) dplyr::mutate(x, ind = as.character(ind))) %>%
  dplyr::tibble(interval = names(.), data = .) %>%
  tidyr::unnest() %>%
  dplyr::mutate(value = paste0("http://climate.weather.gc.ca/glossary_e.html#",
                               values)) %>%
  dplyr::select(interval, weathercan_name = ind, ECCC_ref = value)

# gloss_url <- list(
#   "hour" = c(NA, NA, NA, NA, NA, NA, "temp", NA, "dewPnt", NA, "r_humidity", NA, "windDir", NA, "windSpd", NA, "visibility", NA, "stnPre", NA, "humidex", NA, "windChill", NA, "weatherState"),
#
#   "day" = c(NA, NA, NA, NA, NA, "maxTemp", NA, "minTemp", NA, "meanTemp", NA, "hdd", NA, "cooling", NA, "totalRain", NA, "totalSnow", NA, "totalPrec", NA, "s_onGround", NA, "d_maxGust", NA, "s_maxGust", NA),
#
#   "month" = c(NA, NA, NA, "meanMax", NA, "meanMin", NA, "meanTemp", NA, "extreme_maxtemp", NA, "extreme_mintemp", NA, "totalRain", NA, "totalSnow", NA, "totalPrec", NA, "s_lastDay", NA, "d_maxGust", NA, "s_maxGust", NA)
# )

#wd1 <- weather_raw(station_id = 51423, date = as.Date("2014-01-01"), skip = 15, interval = "hour")
#wd2 <- weather_raw(station_id = 51423, date = as.Date("2014-01-01"), skip = 25, interval = "day")
#wd3 <- weather_raw(station_id = 43823, date = as.Date("2005-01-01"), skip = 17, interval = "month")

#n <- c(names(wd1), names(wd2), names(wd3))

glossary <- dplyr::tibble(interval = c(rep("hour", length(w_names$hour)),
                                         rep("day", length(w_names$day)),
                                         rep("month", length(w_names$month))),
                            ECCC_name = unlist(w_names, use.names = FALSE),
                            weathercan_name = names(unlist(c(w_names, use.names = FALSE))),
                            units = stringr::str_replace_all(stringr::str_extract(ECCC_name, "\\(.*\\)"),
                                                             "\\(|\\)", "")) %>%
  dplyr::left_join(gloss_url, by = c("interval", "weathercan_name")) %>%
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
                units = replace(units, stringr::str_detect(weathercan_name, c("(qual)|(_flag)|(weather)")), "note")) %>%
  dplyr::mutate_all(.funs = dplyr::funs(stringr::str_replace_all(., "°", "\U00B0")))
devtools::use_data(glossary, overwrite = TRUE)


# Technical documentation: ftp://ftp.tor.ec.gc.ca/Pub/Documentation_Technical/Technical_Documentation.pdf
