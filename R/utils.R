tz_offset <- function(tz) {
  t <- as.numeric(difftime(as.POSIXct("2016-01-01 00:00:00", tz = "UTC"),
                           as.POSIXct("2016-01-01 00:00:00", tz = tz), units = "hours"))

  if(t > 0) t <- paste0("Etc/GMT-", t)
  if(t <= 0) t <- paste0("Etc/GMT+", abs(t))
  t
}


check_int <- function(interval) {
  if(!all(interval %in% c("hour", "day", "month"))) {
    stop("'interval' can only be 'hour', 'day', or 'month'")
  }
}

#' DEFUNCT: Get timezone from lat/lon
#'
#' Accessed Google API to determine local timezone from coordinates. Defunct
#' as the API is no longer accessible without a Key.
#'
#' @export
tz_calc <- function(){
  stop("'tz_calc()' has been removed (it relied on a Google API that is ",
       "no longer accesible without a key)", call. = FALSE)
}


#' DEFUNCT: Get timezone from lat/lon
#'
#' @export
get_tz <- function(){
  stop("'get_tz()' has been removed", call. = FALSE)
}
