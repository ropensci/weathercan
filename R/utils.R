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

tz_hours <- function(tz) {
  as.numeric(stringr::str_extract(tz, "[0-9+-.]{1,4}"))
}

find_line <- function(headings, cols) {
  grep(
    paste0("(.*?)", paste0("(", cols, ")", collapse = "(.*?)"), "(.*?)"),
    headings
  )
}

na_tibble <- function(cols) {
  as.list(rep(as.numeric(NA), length(cols))) |>
    stats::setNames(cols) |>
    dplyr::as_tibble(.rows = 0)
}


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

wc_read <- function(path) {
  readr::read_csv(path, show_col_types = FALSE, progress = FALSE)
}

remove_sym <- function(df) {
  dplyr::rename_with(df, \(x) {
    stringr::str_remove_all(x, "\\u00BB|\\u00BF|\\u00EF|\\u00C2|\\u00B0")
  })
}
