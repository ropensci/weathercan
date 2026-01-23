httr::GET(
  url = "https://climate.weather.gc.ca/climate_normals/station_inventory_e.html?yr=1991"
) |>
  httr::content("text") |>
  readr::read_csv()


getOption("weathercan.urls.normals")


# FOLLOWING WORKS for normals... but how do we get stnID?
q <- list(
  lang = "e",
  prov = "MB",
  yr = "1991",
  stnname = "BRANDON",
  stnID = "219000000",
  climateID = "",
  submit_thread = "Download"
)

get_check(
  url = "https://climate.weather.gc.ca/climate_normals/bulk_data_e.html",
  query = q,
  task = "access climate normals"
) |>
  httr::content("text") |>
  readr::read_csv()


# FOLLOWING WORKS for composite thread data... but how do we get stnID?
q <- list(
  lang = "e",
  prov = "MB",
  yr = "1991",
  stnname = "BRANDON",
  stnID = "219000000",
  climateID = "",
  submit_thread = "Download",
  metathread = "metadata",
  metathread = "threaddata"
)


get_check(
  url = "https://climate.weather.gc.ca/climate_normals/thread_bulk_data_e.html",
  query = q,
  task = "access climate normals",
  httr::write_disk("temp.zip", overwrite = TRUE)
)
unzip("temp.zip")
readr::read_csv("en_1991-2020_Normals_station_metadata_MB_BRANDON.csv")
readr::read_csv("en_1991-2020_Normals_station_threads_MB_BRANDON.csv")
