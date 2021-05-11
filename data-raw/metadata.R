library(rvest)
library(dplyr)
library(stringr)

# Add flags data set to package data
# Get legend of flags (same for all intervals where duplicated)
flags <- tibble(interval = c("hour", "day", "month"),
                station_id = c(51423, 51423, 43823)) %>%
  mutate(flags = purrr::map2(.data$station_id, .data$interval,
                             ~ meta_raw(meta_html(station_id = .x,
                                                  interval = .y),
                                        interval = .y, return = "legend"))) %>%
  tidyr::unnest(flags) %>%
  select(code = "X1", meaning = "X2") %>%
  distinct() %>%
  arrange(code) %>%
  mutate(meaning = str_remove(meaning, "\\*"))
usethis::use_data(flags, overwrite = TRUE)


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
  lapply(., FUN = function(x) mutate(x, ind = as.character(ind))) %>%
  tibble(interval = names(.), data = .) %>%
  tidyr::unnest(data) %>%
  mutate(value = paste0("https://climate.weather.gc.ca/glossary_e.html#",
                        values)) %>%
  select(interval, weathercan_name = ind, ECCC_ref = value)


glossary <- tibble(interval = c(rep("hour", length(w_names$hour)),
                                rep("day", length(w_names$day)),
                                rep("month", length(w_names$month))),
                   ECCC_name = unlist(w_names, use.names = FALSE),
                   weathercan_name = names(unlist(c(w_names, use.names = FALSE))),
                   units = str_replace_all(str_extract(ECCC_name, "\\(.*\\)"),
                                           "\\(|\\)", "")) %>%
  left_join(gloss_url, by = c("interval", "weathercan_name")) %>%
  mutate(ECCC_ref = replace(ECCC_ref,
                            weathercan_name == "qual",
                            "https://climate.weather.gc.ca/climate_data/data_quality_e.html"),
         ECCC_ref = replace(ECCC_ref, str_detect(weathercan_name, "_flag"), "See `flags` vignette or dataset for more details"),
         ECCC_ref = replace(ECCC_ref, str_detect(ECCC_ref, "#NA"), NA),
         units = replace(units, weathercan_name %in% c("year", "month", "day", "hour"),
                         weathercan_name[weathercan_name %in% c("year", "month", "day", "hour")]),
         ECCC_ref = replace(ECCC_ref, weathercan_name %in% c("year", "month", "day", "hour"),
                            "https://climate.weather.gc.ca/glossary_e.html#dataInt"),
         units = replace(units, weathercan_name == "time", "ISO date/time"),
         units = replace(units, weathercan_name == "date", "ISO date"),
         units = replace(units, weathercan_name %in% c("hmdx", "wind_chill"), "index"),
         units = replace(units, str_detect(weathercan_name, c("(qual)|(_flag)|(weather)")), "note")) %>%
  mutate_all(.funs = ~str_replace_all(., "°", "\U00B0"))

usethis::use_data(glossary, overwrite = TRUE)


codes <- normals_raw(normals_html(prov = "AB", station_id = 1839,
                                  climate_id = "3011240",
                                  normals_years = "1981-2010")) %>%
  .[8:11] %>%
  str_replace_all("\"\"", "'") %>%
  str_remove_all("\"") %>%
  tibble::enframe(name = NULL) %>%
  tidyr::separate(value, sep = " = ", into = c("code", "meaning"))
usethis::use_data(codes, overwrite = TRUE)


h <- paste0("https://www.canada.ca/en/environment-climate-change/services/",
            "climate-change/canadian-centre-climate-services/display-download/",
            "technical-documentation-climate-normals.html") %>%
  xml2::read_html()

glossary_normals <- tibble(ECCC_name = html_nodes(h, "h3") %>% html_text(),
                           description = html_nodes(h, "h3+p") %>% html_text()) %>%
  filter(!str_detect(ECCC_name, "Thank you")) %>%
  mutate(weathercan_name =
           c("temp", "precip", "snow_depth", "days", "dd", "soil_temp",
             "evaporation", "frost", "hours", "wind", "sun", "humidex",
             "wind_chill", "humidity", "pressure", "rad", "visibility",
             "cloud")) %>%
  select(ECCC_name, weathercan_name, description) %>%
  bind_rows(select(n_names, weathercan_name = new_var, ECCC_name = variable)) %>%
  bind_rows(select(f_names, weathercan_name = new_var, ECCC_name = variable)) %>%
  mutate(ECCC_name = str_to_title(ECCC_name),
         ECCC_name = str_replace_all(ECCC_name, c("Mm" = "mm",
                                                  "Cm" = "cm",
                                                  "Yyyy" = "YYYY",
                                                  "Dd" = "DD",
                                                  "Km/H" = "km/h",
                                                  "Pm" = "PM",
                                                  "Am Obs" = "AM Obs",
                                                  "Kpa" = "kPa",
                                                  "lst" = "LST",
                                                  "Rf" = "RF",
                                                  "Mj/M2" = "MJ/m2"))) %>%
  filter(weathercan_name != "probability")

usethis::use_data(glossary_normals, overwrite = TRUE)
