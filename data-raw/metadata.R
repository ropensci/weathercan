library(httr2)
library(rvest)
library(dplyr)
library(stringr)


# Flags ---------------------------------
# Add flags data set to package data
# Get legend of flags (same for all intervals where duplicated)
flags <- tibble(
  interval = c("hour", "day", "month"),
  station_id = c(51423, 51423, 43823)
) |>
  mutate(
    flags = purrr::map2(
      .data$station_id,
      .data$interval,
      \(s, i) {
        meta_html(station_id = s, date = as.Date("2025-01-01"), interval = i) |>
          meta_raw(
            interval = i,
            return = "legend"
          )
      }
    )
  ) |>
  tidyr::unnest(flags) |>
  select("code" = "X1", "meaning" = "X2") |>
  distinct() |>
  arrange(code) |>
  mutate(meaning = str_remove(meaning, "\\*"))
usethis::use_data(flags, overwrite = TRUE)

# weather glossary ----------------------------------------------
gloss_url <- list(
  "hour" = c(
    "temp" = "temp",
    "temp_dew" = "dewPnt",
    "rel_hum" = "r_humidity",
    "wind_dir" = "windDir",
    "wind_spd" = "windSpd",
    "visib" = "visibility",
    "pressure" = "stnPre",
    "hmdx" = "humidex",
    "wind_chill" = "windChill",
    "weather" = "weatherState"
  ),
  "day" = c(
    "max_temp" = "maxTemp",
    "min_temp" = "minTemp",
    "mean_temp" = "meanTemp",
    "heat_deg_days" = "hdd",
    "cool_deg_days" = "cooling",
    "total_rain" = "totalRain",
    "total_snow" = "totalSnow",
    "total_precip" = "totalPrec",
    "snow_grnd" = "s_onGround",
    "dir_max_gust" = "d_maxGust",
    "spd_max_gust" = "s_maxGust"
  ),
  "month" = c(
    "mean_max_temp" = "meanMax",
    "mean_min_temp" = "meanMin",
    "mean_temp" = "meanTemp",
    "extr_max_temp" = "extreme_maxtemp",
    "extr_min_temp" = "extreme_mintemp",
    "total_rain" = "totalRain",
    "total_snow" = "totalSnow",
    "total_precip" = "totalPrec",
    "snow_grnd_last_day" = "s_lastDay",
    "dir_max_gust" = "d_maxGust",
    "spd_max_gust" = "s_maxGust"
  )
) |>
  lapply(utils::stack) |>
  lapply(FUN = function(x) mutate(x, ind = as.character(ind)))

gloss_url <- tibble(interval = names(gloss_url), data = gloss_url) |>
  tidyr::unnest(data) |>
  mutate(
    value = paste0("https://climate.weather.gc.ca/glossary_e.html#", values)
  ) |>
  select("interval", "weathercan" = "ind", "ECCC_ref" = "value")


glossary <- tibble(
  interval = c(
    rep("hour", length(w_names$hour)),
    rep("day", length(w_names$day)),
    rep("month", length(w_names$month))
  ),
  ECCC = unlist(w_names, use.names = FALSE),
  weathercan = names(unlist(c(w_names, use.names = FALSE))),
  units = str_replace_all(str_extract(ECCC, "\\(.*\\)"), "\\(|\\)", "")
) |>
  left_join(gloss_url, by = c("interval", "weathercan")) |>
  mutate(
    ECCC_ref = replace(
      ECCC_ref,
      weathercan == "qual",
      "https://climate.weather.gc.ca/climate_data/data_quality_e.html"
    ),
    ECCC_ref = replace(
      ECCC_ref,
      str_detect(weathercan, "_flag"),
      "See `flags` vignette or dataset for more details"
    ),
    ECCC_ref = replace(ECCC_ref, str_detect(ECCC_ref, "#NA"), NA),
    units = replace(
      units,
      weathercan %in% c("year", "month", "day", "hour"),
      weathercan[weathercan %in% c("year", "month", "day", "hour")]
    ),
    ECCC_ref = replace(
      ECCC_ref,
      weathercan %in% c("year", "month", "day", "hour"),
      "https://climate.weather.gc.ca/glossary_e.html#dataInt"
    ),
    units = replace(units, weathercan == "time", "ISO date/time"),
    units = replace(units, weathercan == "date", "ISO date"),
    units = replace(
      units,
      weathercan %in% c("hmdx", "wind_chill"),
      "index"
    ),
    units = replace(
      units,
      str_detect(weathercan, c("(qual)|(_flag)|(weather)")),
      "note"
    )
  ) |>
  mutate(across(everything(), .fns = \(x) str_replace_all(x, "°", "\U00B0")))

usethis::use_data(glossary, overwrite = TRUE)


codes <- normals_raw(normals_html(
  prov = "AB",
  station_id = 1839,
  climate_id = "3011240",
  normals_years = "1981-2010"
))
codes <- codes[8:11] |>
  str_replace_all("\"\"", "'") |>
  str_remove_all("\"") |>
  tibble::enframe(name = NULL) |>
  tidyr::separate("value", sep = " = ", into = c("code", "meaning"))
usethis::use_data(codes, overwrite = TRUE)


# new normals ---------------------------------------------
variables_normals_new <- readr::read_csv(normals_file()) |>
  dplyr::select(
    "measurement_type" = "ELEMENT_GROUP",
    "ECCC" = "NORMALS_ELEMENT"
  ) |>
  unique() |>
  dplyr::mutate(weathercan = pretty_names(ECCC))

usethis::use_data(variables_normals_new, overwrite = TRUE)

# normals 1981 and older ----------------------------------
h <- paste0(
  "https://www.canada.ca/en/environment-climate-change/services/",
  "climate-change/canadian-centre-climate-services/display-download/",
  "technical-documentation-climate-normals.html"
)

r <- request(h) |>
  req_perform() |>
  resp_body_html()

ECCC <- html_elements(r, "h3") |>
  html_text() |>
  str_subset(
    "(Environment and Climate Change Canada)|(Government of Canada)",
    negate = TRUE
  )

variables_normals_old <- tibble(
  ECCC,
  description = html_elements(r, "h3+p") |> html_text()
) |>
  filter(!str_detect(ECCC, "Thank you")) |>
  mutate(
    weathercan = c(
      "temp",
      "precip",
      "snow_depth",
      "days",
      "dd",
      "soil_temp",
      "evaporation",
      "frost",
      "hours",
      "wind",
      "sun",
      "humidex",
      "wind_chill",
      "humidity",
      "pressure",
      "rad",
      "visibility",
      "cloud"
    )
  ) |>
  select("ECCC", "weathercan", "description") |>
  bind_rows(select(
    n_names,
    "weathercan" = "new_var",
    "ECCC" = "variable"
  )) |>
  bind_rows(select(
    f_names,
    "weathercan" = "new_var",
    "ECCC" = "variable"
  )) |>
  mutate(
    ECCC = str_to_title(ECCC),
    ECCC = str_replace_all(
      ECCC,
      c(
        "Mm" = "mm",
        "Cm" = "cm",
        "Yyyy" = "YYYY",
        "Dd" = "DD",
        "Km/H" = "km/h",
        "Pm" = "PM",
        "Am Obs" = "AM Obs",
        "Kpa" = "kPa",
        "lst" = "LST",
        "Rf" = "RF",
        "Mj/M2" = "MJ/m2"
      )
    )
  ) |>
  filter(weathercan != "probability")

glossary_normals <- variables_normals_old[1:18, ]
variables_normals_old <- variables_normals_old[-c(1:18), -3]

usethis::use_data(glossary_normals, overwrite = TRUE)
usethis::use_data(variables_normals_old, overwrite = TRUE)
