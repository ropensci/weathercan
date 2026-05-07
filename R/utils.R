#' Calculate timezone difference from UTC
#'
#' Calculates the difference between a given timezone and UTC, returning either
#' as Etc/GMT format or as numeric hours.
#'
#' @param tz Character. Timezone name
#' @param as Character. Output format - "tz" for Etc/GMT format or anything else
#'   for numeric hours
#'
#' @returns Character timezone string (Etc/GMT format) or numeric hours difference
#'
#' @noRd

tz_diff <- function(tz, as = "tz") {
  if (!is.na(tz)) {
    t <- as.numeric(difftime(
      as.POSIXct("2016-01-01 00:00:00", tz = "UTC"),
      as.POSIXct("2016-01-01 00:00:00", tz = tz),
      units = "hours"
    ))

    if (as == "tz") {
      if (t > 0) {
        t <- paste0("Etc/GMT-", t)
      }
      if (t <= 0) t <- paste0("Etc/GMT+", abs(t))
    }
  } else {
    t <- NA_character_
  }
  t
}

#' Extract numeric hours from timezone string
#'
#' Extracts the numeric hour offset from a timezone string (e.g., "Etc/GMT-5").
#'
#' @param tz Character. Timezone string
#'
#' @returns Numeric. Hour offset from timezone string
#'
#' @noRd

tz_hours <- function(tz) {
  as.numeric(stringr::str_extract(tz, "[0-9+-.]{1,4}"))
}

#' Find line number matching column pattern
#'
#' Searches for a line in text that contains all specified column names in any order.
#'
#' @param headings Character vector. Lines of text to search
#' @param cols Character vector. Column names to find
#'
#' @returns Numeric. Line number(s) matching the pattern
#'
#' @noRd

find_line <- function(headings, cols) {
  grep(
    paste0("(.*?)", paste0("(", cols, ")", collapse = "(.*?)"), "(.*?)"),
    headings
  )
}

#' Create empty tibble with NA columns
#'
#' Creates a zero-row tibble with specified column names, all initialized to NA.
#'
#' @param cols Character vector. Column names for the tibble
#'
#' @returns Tibble with zero rows and specified columns
#'
#' @noRd

na_tibble <- function(cols) {
  as.list(rep(as.numeric(NA), length(cols))) |>
    stats::setNames(cols) |>
    dplyr::as_tibble(.rows = 0)
}

#' Minimum value handling empty inputs
#'
#' Calculates minimum value but returns empty numeric vector if all inputs
#' are empty, rather than erroring.
#'
#' @param ... Numeric values to find minimum of
#' @param na.rm Logical. Whether to remove NA values
#'
#' @returns Numeric. Minimum value or empty numeric vector
#'
#' @noRd

min_na <- function(..., na.rm = TRUE) {
  l <- list(...)
  if (all(lengths(l) == 0)) {
    r <- numeric()
  } else {
    r <- min(..., na.rm = na.rm)
  }
  r
}


#' Check access to ECCC
#'
#' Checks if whether there is internet access, weather data, normals data,
#' and eccc sites are available and accessible, and whether we're NOT running
#' on cran
#'
#' @return FALSE if not, TRUE if so
#' @export
#'
#' @examples
#' check_eccc()

check_eccc <- function() {
  (Sys.getenv("NOT_CRAN") == "" || isTRUE(Sys.getenv("NOT_CRAN"))) &&
    is_up(getOption("weathercan.urls.weather")) &&
    is_up("https://climate.weather.gc.ca")
}

#' Check if URL is accessible
#'
#' Sends a HEAD request to check if a URL is accessible and returns a
#' successful response.
#'
#' @param x Character. URL to check
#'
#' @returns Logical. TRUE if URL is accessible, FALSE otherwise
#'
#' @noRd

is_up <- function(x) {
  err <- httr2::request(x) |>
    httr2::req_method("HEAD") |>
    httr2::req_perform() |>
    httr2::resp_is_error()

  !err
}

#' Make pretty column names
#'
#' @param x Character string of column names to prettify
#'
#' @returns Character string of pretty names
#'
#' @noRd
#' @examples
#' pretty_names(
#'   c(
#'     "Maximum Daily Mean (°C) Date (yyyy/mm/dd)",
#'     "Extreme Daily Precipitation (mm) Date (yyyy/mm/dd)",
#'     "Days with Maximum Temperature <= -20 °C",
#'     "Probability of last temperature in spring <= 0°C, on or after indicated date (10%)"
#'   )
#' )

pretty_names <- function(x) {
  x |>
    tolower() |>
    stringr::str_remove_all("[^a-z0-9 _\\-\\<\\>\\=]+") |>
    stringr::str_replace_all(c("\\%" = "perc", "date yyyymmdd" = "date")) |>
    stringr::str_squish() |>
    stringr::str_replace_all(" |-|_", "_") |>
    stringr::str_replace_all("_+", "_")
}

#' Read CSV file with weathercan defaults
#'
#' Wrapper around [readr::read_csv()] with `show_col_types` and `progress`
#' disabled.
#'
#' @param path Character. Path to CSV file
#'
#' @returns Tibble of CSV data
#'
#' @noRd

wc_read <- function(path) {
  readr::read_csv(path, show_col_types = FALSE, progress = FALSE)
}

#' Remove special symbols from column names
#'
#' Removes specific Unicode symbols from data frame column names.
#'
#' @param df Data frame. Data frame with column names to clean
#'
#' @returns Data frame with cleaned column names
#'
#' @noRd

remove_sym <- function(df) {
  dplyr::rename_with(df, \(x) {
    stringr::str_remove_all(x, "\\u00BB|\\u00BF|\\u00EF|\\u00C2|\\u00B0")
  })
}

#' Get variable or non-variable column names
#'
#' Extracts either measurement variable names or metadata/flag column names
#' from a vector of column names.
#'
#' @param names Character vector. Column names to filter
#' @param variable Logical. If `TRUE`, return variable names; if `FALSE`, return
#'   non-variable names (metadata and flags)
#'
#' @returns Character vector of filtered column names
#'
#' @noRd

var_names <- function(names, variable = TRUE) {
  # fmt: skip
  non_var <- c(
    "date", "year", "month", "day", "hour", "time", "qual", "weather",
    stringr::str_subset(names, "_flag$")
  )

  if (variable) {
    v <- names[!names %in% non_var]
  } else {
    v <- non_var
  }

  v
}
