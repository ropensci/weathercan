## Get up-to-date stations data
stations <- stations_all()
devtools::use_data(stations, overwrite = TRUE)

write.csv(stations, "./data-raw/stations.csv", row.names = FALSE)

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
