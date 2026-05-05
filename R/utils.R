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

check_int <- function(interval) {
  if (!all(interval %in% c("hour", "day", "month"))) {
    stop("'interval' can only be 'hour', 'day', or 'month'")
  }
}

check_ids <- function(ids, stn, type) {
  if (!all(ids %in% stn[[type]])) {
    if (type == "climate_id" && any(nchar(as.character(ids)) != 7)) {
      stop(
        "'climate_id's expect an id with 7 characters (e.g., 301AR54). ",
        "Did you use 'station_id' by accident?",
        call. = FALSE
      )
    }
    stop(
      "'",
      type,
      "'",
      paste0(ids[!ids %in% stn[[type]]], collapse = ", "),
      "are not present in the stations data frame",
      call. = FALSE
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
    stop(
      "'normals_years' must be either 'current' or a text string in the format YYYY-YYYY e.g., '1991-2020'",
      call. = FALSE
    )
  }
  normals_years
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

get_check <- function(url, query = NULL, task = NULL) {
  req <- httr2::request(url)
  if (!is.null(query)) {
    req <- httr2::req_url_query(req, !!!query)
  }
  req <- httr2::req_perform(req)

  if (grepl("^https://climate.weather.gc.ca/error", req$url)) {
    stop("Service is currently down!")
  } else if (any(grepl("error was found", httr2::resp_body_string(req)))) {
    stop(
      "API could not fetch data with this query\n",
      "Please, open an issue on https://github.com/ropensci/weathercan/issues and share ",
      "the details of your attempted download.",
      call. = FALSE
    )
  }
  req
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
