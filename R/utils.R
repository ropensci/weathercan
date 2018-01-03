#' Get timezone from lat/lon
#'
#' @param coords Vector or Data frame. Lat, lon coordinates. Can be a vector for
#'   a set of two, or a data frame or matrix for multiple. Provide either coords
#'   OR lat and lon
#' @param lat Vector. One or more latitudes, must also provide longitude
#' @param lon Vector. One or more longitudes, must also provide latitude
#' @param etc Logical. Return Etc timezone? Non-daylight savings offset only.
#'
#' @examples
#'
#' # Daylight savings
#' tz_calc(lat = 53.881857, lon = -122.786271)
#' tz_calc(coords = c(53.881857, -122.786271))
#'
#' # No daylight savings
#' tz_calc(lat = 53.881857, lon = -122.786271, etc = TRUE)
#' tz_calc(coords = c(53.881857, -122.786271), etc = TRUE)
#'
#' @aliases get_tz
#'
#' @export

tz_calc <- function(coords = NULL, lat = NULL, lon = NULL, etc = FALSE){
  # Based on http://stackoverflow.com/a/23414695

  if(!is.null(coords)) {
    if(is.vector(coords)) {
      x <- data.frame(lat = coords[1], lon = coords[2])
    } else if(is.matrix(coords)) {
      x <- data.frame(coords)
    } else if(is.data.frame(coords)) x <- coords
  } else if(all(!is.null(lat), !is.null(lon))) {
    x <- data.frame(lat = lat, lon = lon)
  } else stop("Must provide lat and lon either as vector to 'coords'",
              "or individual in both 'lat' and 'lon'")

  if(!all(apply(x, 2, is.numeric))) stop("Coordinates must be numeric")

  tz <- vector()
  for(i in seq_len(nrow(x))) {
    time1 <- Sys.time()
    # https://developers.google.com/maps/documentation/timezone/
    apiurl <- paste0("https://maps.googleapis.com/maps/api/timezone/xml?",
                     "location=", x[i,1], ",", x[i,2], "&",
                     "timestamp=", as.numeric(time1), "&",
                     "sensor=false")
    if(!etc) tz <- c(tz, xml2::read_xml(apiurl) %>%
                       xml2::xml_find_all("//time_zone_id") %>%
                       xml2::xml_text())
    if(etc) tz <- c(tz, xml2::read_xml(apiurl) %>%
                      xml2::xml_find_all("//raw_offset") %>%
                      xml2::xml_text())
  }

  if(etc) {
    tz <- as.numeric(tz) / 60 / 60
    if(tz <= 0) tz <- paste0("+", abs(tz)) else tz <- paste0("-", abs(tz))
    tz <- paste0("Etc/GMT", tz)
  }

  tz
}


check_int <- function(interval) {
  if(!all(interval %in% c("hour", "day", "month"))) {
    stop("'interval' can only be 'hour', 'day', or 'month'")
  }
}

#' @export
get_tz <- function(coords = NULL, lat = NULL, lon = NULL, etc = FALSE){
  .Deprecated("tz_calc")
}
