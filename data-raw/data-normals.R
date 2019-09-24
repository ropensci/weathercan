if(!dir.exists("./data-raw/normals/")) dir.create("./data-raw/normals")

# Download all normals to find all measurements and to list measurements taken
# at each station

# Get list of stations with normals data
if(!file.exists("./data-raw/normals/normals_check.csv")) {
  n <- dplyr::filter(stations, normals == TRUE) %>%
    dplyr::select(prov, station_name, climate_id) %>%
    dplyr::distinct() %>%
    dplyr::mutate(checked = FALSE)

  readr::write_csv(n, "./data-raw/normals/normals_check.csv")
}

# Download each station
n <- readr::read_csv("./data-raw/normals/normals_check.csv")
for(i in 1:nrow(n)) {
  if(n[["checked"]][i] == FALSE) {
    message("Trying ", n$climate_id[i])
    data <- normals_dl(climate_ids = n$climate_id[i])
    message("  Good")
    n[["checked"]][i] <- TRUE
    readr::write_rds(data, paste0("./data-raw/normals/normals_",
                                  n$climate_id[i], ".rds"))
    readr::write_csv(n, "./data-raw/normals/normals_check.csv")
  }
}

# Read station data to determine measurements

check_and_load <- function(climate_id) {
  f <- paste0("./data-raw/normals/normals_", climate_id, ".rds")
  if(file.exists(f)) {
    r <- readr::read_rds(f)
  }
  c(names(r$data[[1]]), names(r$frost[[1]]))
}

normals_measurements <- readr::read_csv("./data-raw/normals/normals_check.csv") %>%
  dplyr::mutate(measurement = purrr::map(.data$climate_id, check_and_load)) %>%
  tidyr::unnest(measurement) %>%
  dplyr::filter(measurement != "period") %>%
  dplyr::select(-"checked")

usethis::use_data(normals_measurements, overwrite = TRUE)

