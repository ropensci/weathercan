normals_html <- function(prov, station_id, climate_id, normals_years) {
  yrs <- stringr::str_extract(normals_years, "^[0-9]{4}")

  q <- list(
    ffmt = "csv",
    lang = "e",
    prov = prov,
    yr = yrs,
    stnID = station_id,
    climate_id = climate_id, #This keeps changing!
    submit = "Download Data"
  )

  get_check(
    url = getOption("weathercan.urls.normals"),
    query = q,
    task = "access climate normals"
  )
}

normals_raw <- function(html, nrows = -1) {
  # Extract file
  html |>
    httr2::resp_body_string(encoding = "latin1") |>
    stringr::str_split(pattern = "\n") |>
    unlist() |>
    # Get rid of all special symbols
    stringr::str_remove_all("[^\001-\177]")
}
