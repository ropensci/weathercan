#' Fetch normals data from ECCC
#'
#' Makes an API request to download climate normals data for a specific station.
#'
#' @param prov Character. Province code
#' @param station_id Character/Numeric. Station ID
#' @param climate_id Character. Climate ID
#' @param normals_years Character. Normals years in format YYYY-YYYY
#'
#' @returns httr2 response object
#'
#' @noRd
#' @examples
#' r <- normals_html("AB", "1799", "301C3D4", "1981-2010")
#' readr::read_lines(I(httr2::resp_body_string(r)))

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

  get_check(url = getOption("weathercan.urls.normals"), query = q)
}

#' Extract raw normals data from HTML response
#'
#' Extracts and cleans the CSV data from an HTML response body, removing
#' non-ASCII characters.
#'
#' @param html httr2 response object. Response from normals API
#' @param nrows Numeric. Number of rows to read (default -1 for all)
#'
#' @returns Character vector of cleaned CSV lines
#'
#' @noRd
#' @examples
#' r <- normals_html("AB", "1799", "301C3D4", "1981-2010")
#' normals_raw(r)

normals_raw <- function(html, nrows = -1) {
  # Extract file
  html |>
    httr2::resp_body_string(encoding = "latin1") |>
    stringr::str_split(pattern = "\n") |>
    unlist() |>
    # Get rid of all special symbols
    stringr::str_remove_all("[^\001-\177]")
}
