#' Check intervals
#'
#' @param interval Character vector of intervals to validate
#' @param n Integer. Max number of intervals allowed
#' @param .envir Environment for error reporting
#'
#' @returns Nothing, errors if not valid
#'
#' @noRd
#' @examplesIf interactive()
#' check_int("hour")
#' check_int(c("hour", "day"))
#' check_int(c("hour", "day"), n = 1) # Error

check_int <- function(interval, n = Inf, .envir = rlang::caller_env()) {
  if (length(interval) > n || !all(interval %in% c("hour", "day", "month"))) {
    if (n < Inf) {
      m <- paste0("'interval' can only have ", n, " of ")
    } else {
      m <- "'interval' can only contain "
    }
    wc_stop(m, "'hour', 'day', or 'month'", .envir = .envir)
  }
}

#' Check if a date is valid
#'
#' @param dt Date to check
#'
#' @returns Logical. TRUE if date is invalid or cannot be coerced to Date
#'
#' @noRd

check_date <- function(dt) {
  !is.null(dt) &&
    tryCatch(!lubridate::is.Date(as.Date(dt)), error = \(err) TRUE)
}

#' Check start and end dates
#'
#' Validates that start and end dates are valid date formats and that the end
#' date is not earlier than the start date.
#'
#' @param start Start date to validate
#' @param end End date to validate
#' @param .envir Environment for error reporting
#'
#' @returns Nothing, errors if dates are invalid
#'
#' @noRd

check_dates <- function(start, end, .envir = rlang::caller_env()) {
  if (check_date(start) || check_date(end)) {
    wc_stop(
      "'start' and 'end' must be either a standard date format ",
      "(YYYY-MM-DD) or `NULL`",
      .envir = .envir
    )
  }

  if (
    length(start) &&
      length(end) &&
      lubridate::as_date(end) < lubridate::as_date(start)
  ) {
    wc_stop("'end' date is earlier than the 'start' date", .envir = .envir)
  }
}

#' Check station IDs
#'
#' Validates that station/climate IDs are present in the stations data frame.
#'
#' @param ids Station IDs to check
#' @param stn Stations data frame
#' @param type Character. Type of ID ("station_id" or "climate_id")
#' @param .envir Environment for error reporting
#'
#' @returns Nothing, errors if IDs are not found
#'
#' @noRd
#' @examplesIf interactive
#' check_ids("301AR54", stations(), type = "climate_id") # Okay
#' check_ids("xxx", stations(), type = "climate_id")     # Error
#' check_ids("1797", stations(), type = "station_id") # Okay
#' check_ids("xxx", stations(), type = "station_id") # Error

check_ids <- function(ids, stn, type, .envir = rlang::caller_env()) {
  if (!all(ids %in% stn[[type]])) {
    if (type == "climate_id" && any(nchar(as.character(ids)) != 7)) {
      wc_stop(
        "'climate_id's expect an id with 7 characters (e.g., 301AR54). ",
        "Did you use 'station_id' by accident?",
        .envir = .envir
      )
    }

    wc_stop(
      "'{type}' {paste0(ids[!ids %in% stn[[type]]], collapse = ', ')} ",
      "are not present in the stations data frame",
      call = .envir # call only, because 'type' is in this env, not the parent
    )
  }
}

#' Check normals years format
#'
#' Validates that normals_years is in the correct format (YYYY-YYYY) or "current".
#' Converts "current" to the most recent available normals period.
#'
#' @param normals_years Character. Normals years to validate
#' @param null_ok Logical. Whether NULL is acceptable
#' @param .envir Environment for error reporting
#'
#' @returns Validated normals_years string or NULL if null_ok is TRUE
#'
#' @noRd
#' @examplesIf interactive()
#' check_normals("xxx") # Error
#' check_normals("1991-2020")
#' check_normals("current")

check_normals <- function(
  normals_years,
  null_ok = FALSE,
  .envir = rlang::caller_env()
) {
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
      "'normals_years' must be either 'current' or a text string in the format YYYY-YYYY e.g., '1991-2020'",
      .envir = .envir
    )
  }
  normals_years
}
