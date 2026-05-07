prep_stations <- function(station_ids, interval) {
  stn <- stations_read() |>
    dplyr::filter(
      .data$station_id %in% .env$station_ids,
      !is.na(.data$start),
      .data$interval == .env$interval
    ) |>
    dplyr::arrange(.data$interval)

  # Convert to dates
  stn <- stn |>
    dplyr::mutate(
      start = lubridate::ymd(.data$start, truncated = 2),
      end = lubridate::ymd(.data$end, truncated = 2),
      end = lubridate::ceiling_date(.data$end, "year") # TODO Minus one day?
    ) |>
    # Formatting
    dplyr::mutate(
      int = lubridate::interval(.data$start, .data$end),
      interval = factor(
        .data$interval,
        levels = c("hour", "day", "month"),
        ordered = TRUE
      )
    )
  stn
}

prep_start_end <- function(stn, start, end) {
  # Check start/ends
  min_dt <- as.Date("1840-01-01") # Earliest date API will return

  start_label <- if (is.null(start)) "earliest" else start

  stn <- stn |>
    dplyr::mutate(
      start_use = lubridate::as_date(.env$start %||% .data$start),
      start_label = .env$start_label,
      end_use = lubridate::as_date(.env$end %||% Sys.Date()),
      end_label = .data$end_use
    ) |>
    # Fix start dates
    dplyr::mutate(
      start_use = dplyr::case_when(
        .data$start_use > Sys.Date() ~ Sys.Date(),
        .data$start_use < .env$min_dt ~ .env$min_dt,
        .default = .data$start_use
      )
    ) |>
    # Catch problems - Keep for messaging at the end
    dplyr::mutate(end_before_start = .data$end_use < .data$start_use)

  stn
}

prep_paging <- function(stn, months) {
  stn |>
    dplyr::mutate(
      pages = purrr::pmap(
        list(
          .data$start_use,
          .data$end_use,
          .data$interval,
          .data$end_before_start
        ),
        \(s, e, i, x) {
          if (x) {
            return(NULL)
          }
          if (i == "month") {
            # Monthly data always downloads the entire data set, but still needs full
            # year/month/day data to be submitted, so keep just first month
            pages <- lubridate::floor_date(s, unit = "year")
          } else {
            # hourly downloads by month
            # monthly downlads by year
            page_by <- dplyr::if_else(i == "hour", "month", "year")
            pages <- seq(
              lubridate::floor_date(s, unit = page_by),
              lubridate::floor_date(e, unit = page_by),
              by = page_by
            )
            if (i == "hour" && !is.null(months)) {
              pages <- pages[lubridate::month(pages) %in% months]
            }
          }
          pages
        }
      )
    )
}
