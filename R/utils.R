tz_offset <- function(tz, as = "tz") {
  t <- as.numeric(difftime(as.POSIXct("2016-01-01 00:00:00", tz = "UTC"),
                           as.POSIXct("2016-01-01 00:00:00", tz = tz), units = "hours"))

  if(as == "tz"){
    if(t > 0) t <- paste0("Etc/GMT-", t)
    if(t <= 0) t <- paste0("Etc/GMT+", abs(t))
  }
  t
}

tz_hours <- function(tz) {
  as.numeric(stringr::str_extract(tz, "[0-9+-.]{1,4}"))
}

check_url <- function(url, task = paste0("access ", url)) {
  httr::stop_for_status(httr::GET(url), task = task)
}

check_int <- function(interval) {
  if(!all(interval %in% c("hour", "day", "month"))) {
    stop("'interval' can only be 'hour', 'day', or 'month'")
  }
}

check_ids <- function(ids, stn, type){
  if(any(!ids %in% stn[[type]])) {
    if(type == "climate_id" & any(nchar(as.character(ids)) != 7)) {
      stop("'climate_id's expect an id with 7 characters (e.g., 301AR54). ",
           "Did you use 'station_id' by accident?", call. = FALSE)
    }
    stop("'", type, "'", paste0(ids[!ids %in% stn[[type]]], collapse = ", "),
         "are not present in the stations data frame", call. = FALSE)
  }
}

check_normals <- function(normals_years) {
 if(!is.character(normals_years) ||
    !stringr::str_detect(normals_years, "^[0-9]{4}-[0-9]{4}$")) {
   stop("'normals_years' must be a text string in the format YYYY-YYYY e.g., '1981-2010'",
        call. = FALSE)
 }
}

find_line <- function(headings, cols) {
  grep(paste0("(.*?)", paste0("(", cols, ")", collapse = "(.*?)"), "(.*?)"),
       headings)
}

na_tibble <- function(cols) {
  n <- as.list(rep(as.numeric(NA), length(cols))) %>%
    stats::setNames(cols)
  dplyr::tibble(!!n)
}

tibble_to_list <- function(tbl) {
  stats::setNames(tbl[[2]], tbl[[1]])
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
