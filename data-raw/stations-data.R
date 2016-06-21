## Get up-to-date stations data
stations <- stations_all()

write.csv(stations, "./data-raw/stations.csv", row.names = FALSE)
devtools::use_data(stations, overwrite = TRUE)
