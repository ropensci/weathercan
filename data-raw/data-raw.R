## Get up-to-date stations data
stations_dl_internal(verbose = TRUE)

kamloops_day <- weather_dl(
  51423,
  start = "2016-01-01",
  end = "2016-06-30",
  interval = "day"
)
usethis::use_data(kamloops_day, overwrite = TRUE)

kamloops <- weather_dl(51423, start = "2016-01-01", end = "2016-06-30")
usethis::use_data(kamloops, overwrite = TRUE)

pg <- weather_dl(48370, start = "2016-01-01", end = "2016-06-30")
usethis::use_data(pg, overwrite = TRUE)

# with Daylight savings on March 13th (AM)
# finches <- feedrUI::dl_data(start = "2016-03", end = "2016-03-16")
# finches <- dplyr::as_tibble(finches)

# Get the timezone back
#finches <- dplyr::mutate(finches, time = lubridate::force_tz(time, "America/Vancouver"))
#usethis::use_data(finches, overwrite = TRUE)
