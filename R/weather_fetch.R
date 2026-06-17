#' Fetch weather data for a single station
#'
#' Downloads and combines weather data for a single station across multiple
#' date ranges, filtering out empty responses.
#'
#' @param station_id Character/Numeric. Station ID to download data for
#' @param date_range Date vector. Dates to download data for
#' @param interval Character. "hour", "day", or "month"
#' @param encoding Character. Encoding to use when reading data
#'
#' @returns Tibble of combined weather data for all date ranges
#'
#' @noRd

weather_single <- function(station_id, date_range, interval, encoding) {
  w <- dplyr::tibble(date_range = date_range)
  w <- dplyr::mutate(
    w,
    html = purrr::map(
      .data$date_range,
      \(d) weather_html(station_id = station_id, date = d, interval = interval),
      .progress = wc_noise("noisy")
    ),
    data = purrr::map(
      .data$html,
      \(w) weather_raw(w, encoding = encoding, header = TRUE),
      .progress = wc_noise("noisy")
    ),
    n = purrr::map_int(.data$data, ncol)
  )

  w <- dplyr::filter(w, .data$n > 1) # Drop requests with no data
  w <- dplyr::select(w, "data")

  if (utils::packageVersion("tidyr") > "0.8.99") {
    w <- tidyr::unnest(w, "data")
  } else {
    w <- tidyr::unnest(w)
  }
  w
}

#' Fetch weather HTML response
#'
#' Makes an API request to download weather data for a specific station and
#' date.
#'
#' @param station_id Character/Numeric. Station ID
#' @param date Date. Date to download data for
#' @param interval Character. "hour", "day", or "month"
#'
#' @returns httr2 response object
#'
#' @noRd

weather_html <- function(station_id, date, interval = "hour") {
  get_html(station_id, date, interval, format = "csv")
}

#' Parse raw weather data from HTML response
#'
#' Extracts and parses CSV weather data from an HTML response body, handling
#' BOM markers, removing special symbols, and correcting flag values.
#'
#' @param html httr2 response object. Response from `weather_html()`
#' @param skip Numeric. Number of rows to skip
#' @param nrows Numeric. Maximum number of rows to read
#' @param header Logical. Whether first row contains headers
#' @param encoding Character. Encoding to use when reading data
#'
#' @returns Tibble of parsed weather data
#'
#' @noRd

weather_raw <- function(
  html,
  skip = 0,
  nrows = Inf,
  header = TRUE,
  encoding = "UTF-8"
) {
  raw <- httr2::resp_body_raw(html)

  # Look for and remove BOM
  if (
    raw[1] == as.raw(0xef) &&
      raw[2] == as.raw(0xbb) &&
      raw[3] == as.raw(0xbf)
  ) {
    raw <- raw[4:length(raw)]
  }

  # Get number of columns
  ncols <- readr::read_csv(
    I(raw),
    n_max = 1,
    col_names = FALSE,
    col_types = readr::cols(),
    progress = FALSE
  ) |>
    ncol()
  readr::local_edition(1)
  suppressWarnings({
    # when some data are missing, final columns not present
    w <- readr::read_csv(
      I(raw),
      n_max = nrows,
      skip = skip,
      col_types = paste(rep("c", ncols), collapse = ""),
      progress = FALSE
    )
  })
  # Get rid of special symbols right away
  w <- remove_sym(w)

  # For some reason the flags "^" are replaced with "I",
  # change back to match flags on ECCC website
  w <- dplyr::mutate(
    w,
    dplyr::across(dplyr::ends_with("Flag"), \(x) gsub("^I$", "^", x))
  )
  w
}
