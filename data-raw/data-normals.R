if(!dir.exists("./data-raw/normals/")) dir.create("./data-raw/normals")

# Download all normals to find all measurements and to list measurements taken
# at each station

# Get list of stations with normals data
if(!file.exists("./data-raw/normals/normals_check.csv")) {
  n <- stations() %>%
    dplyr::select("prov", "station_name", "climate_id", "normals_1981_2010", "normals_1971_2000") %>%
    dplyr::distinct() %>%
    tidyr::pivot_longer(cols = dplyr::contains("normals_"),
                        names_to = "normals", values_to = "available") %>%
    dplyr::filter(available) %>%
    dplyr::mutate(checked = FALSE,
                  normals = stringr::str_remove(normals, "normals_"),
                  normals = stringr::str_replace(normals, "_", "-")) %>%
    dplyr::select(-available)

  readr::write_csv(n, "./data-raw/normals/normals_check.csv")
}

# Download each station
n <- readr::read_csv("./data-raw/normals/normals_check.csv")
for(i in 1:seq_len(nrow(n))) {
  if(n[["checked"]][i] == FALSE) {
    message("Trying ", n$climate_id[i], " - ", n$normals[i])
    data <- normals_dl(climate_ids = n$climate_id[i], normals_years = n$normals[i])
    message("  Good")
    readr::write_rds(data, paste0("./data-raw/normals/normals_",
                                  n$normals[i], "_", n$climate_id[i], ".rds"))
    n[["checked"]][i] <- TRUE
    readr::write_csv(n, "./data-raw/normals/normals_check.csv")
  }
}

# Read station data to determine measurements

check_and_load <- function(climate_id, years) {
  f <- paste0("./data-raw/normals/normals_", years, "_", climate_id, ".rds")
  if(file.exists(f)) {
    r <- readr::read_rds(f)
  }
  c(names(r$normals[[1]]), names(r$frost[[1]]))
}

normals_measurements <- readr::read_csv("./data-raw/normals/normals_check.csv") %>%
  dplyr::mutate(measurement = purrr::map2(.data$climate_id, .data$normals,
                                          check_and_load)) %>%
  tidyr::unnest(measurement) %>%
  dplyr::filter(measurement != "period") %>%
  dplyr::select(-"checked")

usethis::use_data(normals_measurements, overwrite = TRUE)

