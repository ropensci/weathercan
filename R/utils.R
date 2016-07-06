#' Get timezone from lat/lon
#'
#' @param coords Vector or Data frame. Lat, lon coordinates. Can be a vector for
#'   a set of two, or a data frame or matrix for multiple. Provide either coords OR lat and lon
#' @param lat Vector. One or more latitudes, must also provide longitude
#' @param lon Vector. One or more longitudes, must also provide latitude
#' @param etc Logical. Return Etc timezone? Non-daylight savings offset only.
#'
#' @examples
#'
#' lat = 53.881857
#' lon = -122.786271
#'
#' @import magrittr
#' @export

get_tz <- function(coords = NULL, lat = NULL, lon = NULL, etc = FALSE){
  # Based on http://stackoverflow.com/a/23414695

  if(!is.null(coords)) {
    if(is.vector(coords)) {
      x <- data.frame(lat = coords[1], lon = coords[2])
    } else if(is.matrix(coords)) {
      x <- data.frame(coords)
    } else if(is.data.frame(coords)) x <- coords
  } else if(all(!is.null(lat), !is.null(lon))) {
    x <- data.frame(lat = lat, lon = lon)
  } else stop("Must provide lat and lon either as vector to 'coords' or individual in both 'lat' and 'lon'")

  if(!all(apply(x, 2, is.numeric))) stop("Coordinates must be numeric")

  tz <- vector()
  for(i in 1:nrow(x)) {
    time1 <- Sys.time()
    # https://developers.google.com/maps/documentation/timezone/
    apiurl <- paste0("https://maps.googleapis.com/maps/api/timezone/xml?",
                     "location=", x[i,1], ",", x[i,2], "&",
                     "timestamp=", as.numeric(time1), "&",
                     "sensor=false")
    if(!etc) tz <- c(tz, xml2::read_xml(apiurl) %>% xml2::xml_find_all("//time_zone_id") %>% xml2::xml_text())
    if(etc) tz <- c(tz, xml2::read_xml(apiurl) %>% xml2::xml_find_all("//raw_offset") %>% xml2::xml_text())
  }

  if(etc) {
    tz <- as.numeric(tz) / 60 / 60
    if(tz <= 0) tz <- paste0("+", abs(tz)) else tz <- paste0("-", abs(tz))
    tz <- paste0("Etc/GMT", tz)
  }
  return(tz)
}

w_names <- list(
  "hour" = c("time", "year", "month", "day", "hour", "qual", "temp", "temp_flag", "temp_dew", "temp_dew_flag", "rel_hum", "rel_hum_flag", "wind_dir", "wind_dir_flag", "wind_spd", "wind_spd_flag", "visib", "visib_flag", "pressure", "pressure_flag", "hmdx", "hmdx_flag", "wind_chill", "wind_chill_flag", "weather"),

  "month" = c("date", "year", "month", "day", "qual", "max_temp", "max_temp_flag", "min_temp", "min_temp_flag", "mean_temp", "mean_temp_flag", "heat_deg_days", "heat_deg_days_flag", "cool_deg_days", "cool_deg_days_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd_last_day", "snow_grnd_last_day_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag"),

  "year" = c("date", "year", "month", "mean_max_temp", "mean_max_temp_flag", "mean_min_temp", "mean_min_temp_flag", "mean_temp", "mean_temp_flag", "extr_max_temp", "extr_max_temp_flag", "extr_min_temp", "extr_min_temp_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd_last_day", "snow_grnd_last_day_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag")
)
