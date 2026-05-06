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

weather_html <- function(station_id, date, interval = "hour") {
  get_html(station_id, date, interval, format = "csv")
}

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
