#' Process one stations worth of data
#'
#' Grab meta data, and all the weather data requested, combine and format.
#'
#' @param station_id Character. Station ID to collect data for.
#' @param start_use Date. Start date, prepared by `prep_start_end()`
#' @param end_use Date. End date, prepared by `prep_start_end()`
#' @param pages Character. Dates (pages) to access from the API
#' @param tz Character. Timezone of the weather data (local timezone w/o
#'   daylight savings)
#' @param interval Character. "hour", "day", "month"
#' @param format Logical. Format the data?
#' @param time_disp Character. Time to display "none" or "UTC" (see [weather_dl()]
#'   details)
#' @param string_as Character. Value to replace character strings with (see
#'   weather_dl() details)
#' @param encoding Character. Text encoding
#' @param ... Only used to ignore extra columns when [weather_dl] passes data
#'   frame through `purrr::pmap()`
#'
#' @returns List with 'data' = Weather data frame with metadata and 'msg' =
#' formatting messages
#'
#' @noRd

weather_combine <- function(
  station_id,
  start_use,
  end_use,
  pages,
  tz,
  interval,
  format,
  time_disp,
  string_as,
  encoding,
  ...
) {
  if (is.null(pages)) {
    return(dplyr::tibble())
  }

  # Extract only most recent meta (i.e. end date)
  wc_progress("Getting station: {station_id}")

  wc_progress("Metadata", add = TRUE)
  meta <- meta_single(
    station_id = station_id,
    end = end_use,
    interval,
    encoding
  )

  wc_progress("Weather data", add = TRUE)
  w <- weather_single(station_id, pages, interval, encoding)
  if (format) {
    wc_progress("Formatting", add = TRUE)
    w <- weather_format(
      w,
      station_id = station_id,
      tz = tz,
      interval = interval,
      start = start_use,
      end = end_use,
      time_disp = time_disp,
      string_as = string_as
    )
  } else {
    w <- list(data = w, msg_fmt = data.frame())
  }

  # Some stations return all NAs depending on time frame...
  #  - If all missing values, omit
  n <- c("time", "date", "year", "month", "day", "hour")
  w_check <- dplyr::select(w$data, -dplyr::any_of(.env$n))
  if (all(is.na(w_check))) {
    w$data <- dplyr::tibble()
  }

  if (nrow(w$data) > 0) {
    w$data <- dplyr::bind_cols(meta, w$data)
    ## Fill missing headers with NA - Synchronizes older meta with new
    w$data[names(m_names)[!names(m_names) %in% names(w$data)]] <- NA
  }

  w
}

weather_arrange <- function(w) {
  dplyr::relocate(w, dplyr::any_of(names(m_names)))
}
