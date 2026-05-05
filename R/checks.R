check_int <- function(interval) {
  if (!all(interval %in% c("hour", "day", "month"))) {
    wc_stop("'interval' can only be 'hour', 'day', or 'month'")
  }
}

check_ids <- function(ids, stn, type) {
  if (!all(ids %in% stn[[type]])) {
    if (type == "climate_id" && any(nchar(as.character(ids)) != 7)) {
      wc_stop(
        "'climate_id's expect an id with 7 characters (e.g., 301AR54). ",
        "Did you use 'station_id' by accident?"
      )
    }
    wc_stop(
      "'{type}' {paste0(ids[!ids %in% stn[[type]]], collapse = ', ')} ",
      "are not present in the stations data frame"
    )
  }
}

check_normals <- function(normals_years, null_ok = FALSE) {
  if (null_ok && is.null(normals_years)) {
    return(normals_years)
  }

  if (normals_years == "current") {
    wc_inform(
      "The most current normals available for download by weathercan are '1991-2020'"
    )
    normals_years <- "1991-2020"
  }

  if (
    is.null(normals_years) ||
      !is.character(normals_years) ||
      !stringr::str_detect(normals_years, "^[0-9]{4}-[0-9]{4}$")
  ) {
    wc_stop(
      "'normals_years' must be either 'current' or a text string in the format YYYY-YYYY e.g., '1991-2020'"
    )
  }
  normals_years
}
