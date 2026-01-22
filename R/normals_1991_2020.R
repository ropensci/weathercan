# R/normals_1991_2020.R
# 1991–2020 climate normals helpers

#' Stations with 1991–2020 climate normals
#'
#' Filter the stations table to those with 1991–2020 climate normals.
#'
#' @param province Optional province/territory. Two-letter code
#'   (e.g., "MB") or full name (e.g., "Manitoba"), case-insensitive.
#' @return A tibble of stations with 1991–2020 normals.
#' @export
get_normals_1991_2020_stations <- function(province = NULL) {
  s <- weathercan::stations
  s <- dplyr::filter(s, .data$normals_1991_2020)
  
  if (!is.null(province)) {
    province_input <- toupper(province)
    
    prov_codes <- c(
      "AB" = "ALBERTA",
      "BC" = "BRITISH COLUMBIA",
      "MB" = "MANITOBA",
      "NB" = "NEW BRUNSWICK",
      "NL" = "NEWFOUNDLAND AND LABRADOR",
      "NT" = "NORTHWEST TERRITORIES",
      "NS" = "NOVA SCOTIA",
      "NU" = "NUNAVUT",
      "ON" = "ONTARIO",
      "PE" = "PRINCE EDWARD ISLAND",
      "QC" = "QUEBEC",
      "SK" = "SASKATCHEWAN",
      "YT" = "YUKON"
    )
    
    if (province_input %in% prov_codes) {
      province_code <- names(prov_codes)[prov_codes == province_input]
    } else if (province_input %in% names(prov_codes)) {
      province_code <- province_input
    } else {
      warning("Province '", province, "' not recognized. Returning all provinces.")
      return(s)
    }
    
    s <- dplyr::filter(s, .data$prov == province_code)
  }
  
  s
}

#' Download 1991–2020 climate normals from ECCC
#'
#' Currently experimental: uses climate_id as stnID because the
#' dedicated station ID for 1991–2020 normals is not yet exposed.
#'
#' @param station Station name (character) or climate_id (character/number).
#' @param format Either "csv" or "json".
#' @param ... Extra arguments passed to readr::read_csv when format = "csv".
#' @return A tibble or list with normals data, or NULL if not available.
#' @export
normals_dl_1991_2020 <- function(station, format = "csv", ...) {
  stopifnot(format %in% c("csv", "json"))
  
  s <- weathercan::stations
  s <- dplyr::filter(s, .data$normals_1991_2020)
  
  if (is.character(station)) {
    s <- dplyr::filter(
      s,
      grepl(station, station_name, ignore.case = TRUE)
    )
  } else {
    s <- dplyr::filter(s, .data$climate_id == as.character(station))
  }
  
  if (nrow(s) == 0L) {
    message("No 1991-2020 normals available for station: ", station)
    return(NULL)
  }
  
  # NOTE: This is a placeholder; stnID may not equal climate_id.
  base_url <- "https://climate.weather.gc.ca/climate_normals/"
  url <- paste0(
    base_url,
    "results_1991_2020_", tolower(format),
    "?stnID=", s$climate_id[1]
  )
  
  resp <- httr::GET(url)
  if (resp$status_code != 200) {
    stop("Failed to download normals. HTTP ", resp$status_code)
  }
  
  if (format == "csv") {
    readr::read_csv(httr::content(resp, as = "text"), ...)
  } else {
    jsonlite::fromJSON(httr::content(resp, as = "text"))
  }
}
