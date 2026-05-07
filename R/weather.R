#' Download weather data from Environment and Climate Change Canada
#'
#' Downloads data from Environment and Climate Change Canada (ECCC) for one or
#' more stations. For details and units, see the glossary vignette
#' (`vignette("glossary", package = "weathercan")`) or the glossary online
#' <https://climate.weather.gc.ca/glossary_e.html>.
#'
#' @details Data can be returned 'raw' (format = FALSE) or can be formatted.
#'   Formatting transforms dates/times to date/time class, renames columns, and
#'   converts data to numeric where possible. If character strings are contained
#'   in traditionally numeric fields (e.g., weather speed may have values such
#'   as "< 30"), they can be replaced with a character specified by `string_as`.
#'   The default is NA. Formatting also replaces data associated with certain
#'   flags with NA (M = Missing), if they are not already marked as NA.
#'
#'   Start and end date can be specified, but if not, it will default to the
#'   start and end date of the range (this could result in downloading a lot of
#'   data!).
#'
#'   For hourly data, timezones are always marked "UTC", but the actual times
#'   are either local time (default; `time_disp = "none"`), or UTC
#'   (`time_disp = "UTC"`). When `time_disp = "none"`, times reflect the local
#'   time without daylight savings. This means that relative measures of time,
#'   such as "nighttime", "daytime", "dawn", and "dusk" are comparable among
#'   stations in different timezones. This is useful for comparing daily cycles.
#'   When `time_disp = "UTC"` the times are transformed into UTC timezone. Thus
#'   midnight in Kamloops would register as 08:00:00 (Pacific time is 8 hours
#'   behind UTC). This is useful for tracking weather events through time, but
#'   will result in odd 'daily' measures of weather (e.g., data collected in the
#'   afternoon on Sept 1 in Kamloops will be recorded as being collected on Sept
#'   2 in UTC).
#'
#'   Files are downloaded from the url stored in
#'   `getOption("weathercan.urls.weather")`. To change this location use
#'   `options(weathercan.urls.weather = "your_new_url")`.
#'
#'   Data is downloaded from ECCC as a series of files which are then bound
#'   together. Each file corresponds to a different month, or year, depending on
#'   the interval. Metadata (station name, lat, lon, elevation, etc.) is
#'   extracted from the start of the most recent file (i.e. most recent dates)
#'   for a given station. Note that important data (i.e. station name, lat, lon)
#'   is unlikely to change between files (i.e. dates), but some data may or may
#'   not be available depending on the date of the file (e.g., station operator
#'   was added as of April 1st 2018, so will be in all data which includes dates
#'   on or after April 2018).
#'
#'   # Verbosity
#'   Verbosity (how 'chatty' weathercan is) can be specified using the option
#'   `weathercan.verbosity`. Which takes "standard" (default), "quiet" (suppress
#'   all messages including those regarding missing data, etc.), or "verbose"
#'   (extra progress messages).
#'
#' @param station_ids Numeric/Character. A vector containing the ID(s) of the
#'   station(s) you wish to download data from. See the \code{\link{stations}}
#'   data frame or the \code{\link{stations_search}} function to find IDs.
#' @param start Date/Character. The start date of the data in YYYY-MM-DD format
#'   (applies to all stations_ids). Defaults to start of range.
#' @param end Date/Character. The end date of the data in YYYY-MM-DD format
#'   (applies to all station_ids). Defaults to end of range.
#' @param interval Character. Interval of the data, one of "hour", "day",
#'   "month".
#' @param months Numeric vector. Can supply 1-12 to optionally filter the data
#'   to only specific months. For "hour" interval, this selectively downloads
#'   data by month so can speed up downloads. For intervals of "day" and "month"
#'   this only filters the data after full years or full data ranges have been
#'   downloaded.
#' @param trim Logical. Trim missing values from the start and end of the
#'   weather dataframe. Only applies if `format = TRUE`
#' @param trim_by_stn Logical. Data from different stations are generally padded
#'   with NAs to have the same date range. If this isn't desirable, use `trim =
#'   TRUE` and `trim_by_stn = TRUE` to trim `NA`s from the start and end of each
#'   station. `trim_by_stn = FALSE` (default), only the sides of the entire
#'   range are trimmed.
#' @param format Logical. If TRUE, formats data for immediate use. If FALSE,
#'   returns data exactly as downloaded from Environment and Climate Change
#'   Canada. Useful for dealing with changes by Environment Canada to the format
#'   of data downloads.
#' @param string_as Character. What value to replace character strings in a
#'   numeric measurement with. See Details.
#' @param time_disp Character. Either "none" (default) or "UTC". See details.
#' @param encoding Character. Text encoding for download.
#' @param list_col Logical. Return data as nested data set? Defaults to FALSE.
#'   Only applies if `format = TRUE`
#'
#' @return A tibble with station ID, name and weather data.
#'
#' @examplesIf check_eccc()
#'
#' kam <- weather_dl(station_ids = 51423,
#'                   start = "2016-01-01", end = "2016-02-15")
#'
#' stations_search("Kamloops A$", interval = "hour")
#' stations_search("Prince George Airport", interval = "hour")
#'
#' kam.pg <- weather_dl(station_ids = c(48248, 51423),
#'                      start = "2016-01-01", end = "2016-02-15")
#'
#' library(ggplot2)
#'
#' ggplot(data = kam.pg, aes(x = time, y = temp,
#'                           group = station_name,
#'                           colour = station_name)) +
#'        geom_line()
#'
#' # Download only January and December
#' kam <- weather_dl(
#'   station_ids = 51423,
#'   start = "2016-01-01",
#'   end = "2018-02-15",
#'   months = c(1, 10)
#' )
#'
#' @aliases weather
#'
#' @export

weather_dl <- function(
  station_ids,
  start = NULL,
  end = NULL,
  interval = "hour",
  months = NULL,
  trim = TRUE,
  trim_by_stn = FALSE,
  format = TRUE,
  string_as = NA,
  time_disp = "none",
  encoding = "UTF-8",
  list_col = FALSE
) {
  check_dates(start, end)
  check_int(interval, n = 1)

  stn <- prep_stations(station_ids, interval) |>
    prep_start_end(start, end) |>
    prep_paging(months)

  weather <- purrr::pmap(stn, \(...) {
    weather_combine(
      ...,
      months = months,
      format = format,
      time_disp = time_disp,
      string_as = string_as,
      encoding = encoding
    )
  })
  msg_fmt <- purrr::map(weather, "msg") |>
    purrr::list_rbind()

  weather <- purrr::map(weather, "data") |>
    purrr::list_rbind() |>
    weather_trim(format, trim, trim_by_stn) |>
    weather_arrange() |>
    weather_list_cols(interval, list_col, format)

  # Messages
  weather_msgs(station_ids, stn, weather, interval, start, end)
  if (!nrow(weather)) {
    return(weather)
  }

  weather_fmt_msgs(msg_fmt)

  if (interval == "hour" && !getOption("weathercan.time.message")) {
    wc_inform(
      "As of weathercan v0.3.0 time display is either local time or UTC\n",
      "See Details under {.help [{.fun weather_dl}](weather_dl)} for more information.\n",
      "This message is shown once per session"
    )
    options("weathercan.time.message" = TRUE)
  }

  weather
}

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
  months,
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
      months = months,
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
