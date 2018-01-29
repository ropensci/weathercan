#' Download weather data from Environment Canada
#'
#' Downloads data from Environment Canada for one or more stations. For details
#' and units, see the glossary vignette (\code{vignette("glossary", package =
#' "weathercan")}) or the glossary online
#' \url{http://climate.weather.gc.ca/glossary_e.html}.
#'
#' @details Data can be returned 'raw' (format = FALSE) or can be formatted.
#'   Formatting transforms dates/times to date/time class, renames columns, and
#'   converts data to numeric where possible. If character strings are contained
#'   in traditionally numeric fields (e.g., weather speed may have values such
#'   as "< 30"), they can be replaced with a character specified by `string_as`.
#'   The default is NA. Formating also replaces data associated with certain
#'   flags with NA (M = Missing).
#'
#'   Start and end date can be specified, but if not, it will default to the
#'   start and end date of the range (this could result in downloading a lot of
#'   data!).
#'
#'   Times are returned as the Etc/GMT offset timezone corresponding to the
#'   location. This does not include daylight savings. However, for
#'   compatibility with other data sets, timezones can be converted by
#'   specifying the desired timezone in `tz_disp`.
#'
#'   By default, downloads from
#'   "http://climate.weather.gc.ca/climate_data/bulk_data_e.html"
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
#' @param trim Logical. Trim missing values from the start and end of the
#'   weather dataframe. Only applies if `format = TRUE`
#' @param format Logical. If TRUE, formats data for immediate use. If FALSE,
#'   returns data exactly as downloaded from Environment and Climate Change
#'   Canada. Useful for dealing with changes by Environment Canada to the format
#'   of data downloads.
#' @param string_as Character. What value to replace character strings in a
#'   numeric measurement with. See Details.
#' @param tz_disp Character. What timezone to display times in (must be one of
#'   \code{OlsonNames()}).
#' @param stn Data frame. The \code{stations} data frame to use. Will use the
#'   one included in the package unless otherwise specified.
#' @param url Character. Url from which to grab the weather data. If NULL uses
#'   default url (see details)
#' @param encoding Character. Text encoding for download.
#' @param list_col Logical. Return data as nested data set? Defaults to FALSE.
#'   Only applies if `format = TRUE`
#' @param verbose Logical. Include progress messages
#' @param quiet Logical. Suppress all messages (including messages regarding
#'   missing data, etc.)
#'
#' @return A tibble with station ID, name and weather data.
#'
#' @examples
#'
#' \dontrun{
#' kam <- weather_dl(station_ids = 51423,
#'                   start = "2016-01-01", end = "2016-02-15")
#' }
#'
#' stations_search("Kamloops A$", interval = "hour")
#' stations_search("Prince George Airport", interval = "hour")
#'\dontrun{
#' kam.pg <- weather_dl(station_ids = c(48248, 51423),
#'                      start = "2016-01-01", end = "2016-02-15")
#'
#' library(ggplot2)
#'
#' ggplot(data = kam.pg, aes(x = time, y = temp,
#'                           group = station_name,
#'                           colour = station_name)) +
#'        geom_line()
#'}
#'
#' @aliases weather
#'
#' @export
weather_dl <- function(station_ids,
                    start = NULL, end = NULL,
                    interval = "hour",
                    trim = TRUE,
                    format = TRUE,
                    string_as = NA,
                    tz_disp = NULL,
                    stn = weathercan::stations,
                    url = NULL,
                    encoding = "UTF-8",
                    list_col = FALSE,
                    verbose = FALSE,
                    quiet = FALSE) {

  if(is.null(url)) url <- paste0("http://climate.weather.gc.ca/",
                                 "climate_data/bulk_data_e.html")

  # Address as.POSIXct...
  if((!is.null(start) &
      class(try(as.Date(start), silent = TRUE)) == "try-error") |
     (!is.null(end) &
      class(try(as.Date(end), silent = TRUE)) == "try-error")) {
    stop("'start' and 'end' must be either a standard date format ",
         "(YYYY-MM-DD) or NULL")
  }

  if(length(interval) > 1) {
    stop("'interval' must be either 'hour', 'day', OR 'month'")
  }

  check_int(interval)

  tz_list <- c()
  w_all <- data.frame()

  for(s in station_ids) {
    if(verbose) message("Getting station: ", s)
    stn1 <- stn %>%
      dplyr::filter(station_id %in% s,
                    !is.na(start),
                    interval == !! interval) %>%
      dplyr::arrange(interval)

    if(nrow(stn1) == 0) {
      if(!quiet) {
        message("There are no data for station ", s, " for interval by '",
                interval, "'.", "\nAvailable Station Data:\n",
                paste0(utils::capture.output(print(
                  dplyr::filter(stn, station_id %in% s, !is.na(start)))),
                  collapse = "\n"))
      }
      if(length(station_ids) > 1) next else return(tibble::tibble())
    }

    if(class(try(as.Date(stn1$start), silent = TRUE)) == "try-error") {
      stn1 <- dplyr::mutate(stn1,
                            start = lubridate::ymd(as.character(start),
                                                   truncated = 2),
                            start = lubridate::floor_date(start, "year"))
    }
    if(class(try(as.Date(stn1$end), silent = TRUE)) == "try-error") {
      stn1 <- dplyr::mutate(stn1,
                            end = lubridate::ymd(as.character(end),
                                                 truncated = 2),
                            end = lubridate::ceiling_date(end, "year"))
    }
    stn1 <- stn1 %>%
      dplyr::mutate(end = replace(end, end > Sys.Date(), Sys.Date()),
                    int = lubridate::interval(start, end),
                    interval = factor(interval,
                                      levels = c("hour", "day", "month"),
                                      ordered = TRUE))

    if(is.null(start)) s.start <- stn1$start else s.start <- as.Date(start)
    if(is.null(end)) s.end <- Sys.Date() else s.end <- as.Date(end)
    dates <- lubridate::interval(s.start, s.end)

    date_range <- seq(lubridate::floor_date(s.start, unit = "month"),
                      lubridate::floor_date(s.end, unit = "month"),
                      by = ifelse(interval %in% c("hour"), "month", "year"))
    date_range <- unique(date_range)

    if(interval == "month") date_range <- date_range[1]

    preamble <- weather_raw(station_id = s, date = date_range[1],
                           interval = interval, nrows = 25, url = url,
                           header = FALSE, encoding = encoding,)

    skip <- grep("Date/Time", preamble[, 1])

    preamble <- preamble[1:skip,] %>%
      tidyr::spread(V1, V2) %>%
      dplyr::select(station_name = `Station Name`,
                    lat = Latitude, lon = Longitude, elev = Elevation,
                    climate_id = `Climate Identifier`,
                    WMO_id = `WMO Identifier`, TC_id = `TC Identifier`) %>%
      dplyr::mutate(station_id = s,
                    prov = unique(stn1$prov),
                    lat = as.numeric(as.character(lat)),
                    lon = as.numeric(as.character(lon)),
                    elev = as.numeric(as.character(elev)))

    if(verbose) message("Downloading station data")
    w <- data.frame()
    for(i in seq_along(date_range)){
      w <- rbind(w, weather_raw(station_id = s,
                               date = date_range[i],
                               interval = interval,
                               skip = skip,
                               url = url,
                               encoding = encoding))
    }

    ## Format data if requested
    if(format) {
      if(verbose) message("Formating station data")
      w <- weather_format(w = w,
                          interval = interval,
                          tz_disp = tz_disp,
                          string_as = string_as,
                          quiet = quiet,
                          preamble = preamble)

      ## Trim to match date range
      w <- w[w$date >= s.start & w$date <= s.end, ]
    }

    ## Add header info
    if(verbose) message("Adding header data")
    if(nrow(w) > 0) w <- cbind(preamble, w)

    if(interval == "hour") tz_list <- c(tz_list, lubridate::tz(w$time[1]))
    w_all <- rbind(w_all, w)
  }

  # Convert to UTC if multiple timezones
  if(interval == "hour" && is.null(tz_disp) && length(unique(tz_list)) > 1) {
    w_all$time <- lubridate::with_tz(w_all$time, "UTC")
  }

  if(nrow(w_all) == 0) {
    if(!quiet) message("There are no data for these stations (",
                       paste0(station_ids, collapse = ", "),
                       ") in this time range (",
                       as.character(lubridate::int_start(dates)), " to ",
                       as.character(lubridate::int_end(dates)), ").",
                       "\nAvailable Station Data:\n",
                       paste0(utils::capture.output(print(
                         dplyr::filter(stn,
                                       station_id %in% station_ids,
                                       !is.na(start)))),
                         collapse = "\n"))
    return(tibble::tibble())
  }

  ## Trim to available data provided it is formatted
  if(trim && format){
    if(verbose) message("Trimming missing values before and after")
    temp <-  w_all[, !(names(w_all) %in% c("date", "time", "prov",
                                           "station_name", "station_id",
                                           "lat", "lon", "year", "month",
                                           "day", "hour", "qual","elev",
                                           "climate_id", "WMO_id", "TC_id"))]
    temp <- w_all$date[which(rowSums(is.na(temp) | temp == "") != ncol(temp))]

    if(length(temp) == 0) {
      if(!quiet) message("There are no data for these stations (",
                         paste0(station_ids, collapse = ", "),
                         ") in this time range (",
                         as.character(lubridate::int_start(dates)), " to ",
                         as.character(lubridate::int_end(dates)), ").",
                         "\nAvailable Station Data:\n",
                         paste0(utils::capture.output(print(
                           dplyr::filter(stn,
                                         station_id %in% station_ids,
                                         !is.na(start)))),
                           collapse = "\n"))
      return(tibble::tibble())
    }

    w_all <- w_all[w_all$date >= min(temp) & w_all$date <= max(temp), ]
  }

  ## Arrange
  w_all <- dplyr::select(w_all, station_name, station_id, dplyr::everything())

  ## If list_col is TRUE and data is formatted
  if(list_col && format){

    ## Appropriate grouping levels
    if(interval == "hour"){
      w_all <- tidyr::nest(w_all,
                           -station_name, -station_id, -lat, -lon, -date)
    }

    if(interval == "day"){
      w_all <- tidyr::nest(w_all,
                           -station_name, -station_id, -lat, -lon, -month)
    }

    if(interval == "month"){
      w_all <- tidyr::nest(w_all,
                           -station_name, -station_id, -lat, -lon, -year)
    }

  }

  dplyr::tbl_df(w_all)
}


weather_raw <- function(station_id,
                       date,
                       interval = "hour",
                       skip = 0,
                       nrows = -1,
                       header = TRUE,
                       url = NULL,
                       encoding = "UTF-8") {

  if(is.null(url)) url <- paste0("http://climate.weather.gc.ca/",
                                 "climate_data/bulk_data_e.html")

  html <- httr::GET(url,
                    query = list(format = 'csv',
                                 stationID = station_id,
                                 timeframe = ifelse(interval == "hour", 1,
                                                    ifelse(interval == "day", 2,
                                                           3)),
                                 Year = format(date, "%Y"),
                                 Month = format(date, "%m"),
                                 submit = 'Download+Data'))

  httr::stop_for_status(html)

  utils::read.csv(text = httr::content(html, as = "text",
                                            type = "text/csv",
                                            encoding = encoding),
                       nrows = nrows, strip.white = TRUE,
                       skip = skip, header = header,
                       colClasses = "character", check.names = FALSE) %>%
    # For some reason the flags "^" are replaced with "I",
    # change back to match flags on ECCC website
    dplyr::mutate_at(.vars = dplyr::vars(dplyr::ends_with("Flag")),
                     dplyr::funs(gsub("^I$", "^", .)))
}

weather_format <- function(w, interval = "hour", string_as = "NA", preamble,
                           tz_disp = NULL, quiet = FALSE) {

  ## Get names from stored name list
  n <- w_names[[interval]]

  names(w) <- n

  if(interval == "day") w <- dplyr::mutate(w, date = as.Date(date))
  if(interval == "month") {
    w <- dplyr::mutate(w, date = as.Date(paste0(date, "-01")))
  }

  ## Get correct timezone
  if(interval == "hour"){
    tz <- tz_calc(coords = unique(preamble[, c("lat", "lon")]), etc = TRUE)
    w$time <- as.POSIXct(w$time, tz = tz)
    w$date <- as.Date(w$time, tz = tz)
    if(!is.null(tz_disp)){
      w$time <- lubridate::with_tz(w$time, tz = tz_disp) ## Display in timezone
    }
  }

  ## Replace some flagged values with NA
  w <- w %>%
    tidyr::gather("variable", "value",
                  names(w)[!(names(w) %in% c("date", "year", "month", "day",
                                             "hour", "time", "qual",
                                             "weather"))]) %>%
    tidyr::separate(variable, into = c("variable", "type"),
                    sep = "_flag", fill = "right") %>%
    dplyr::mutate(type = replace(type, type == "", "flag"),
                  type = replace(type, is.na(type), "value")) %>%
    tidyr::spread(type, value) %>%
    dplyr::mutate(value = replace(value, value == "", NA),  ## No data
                  value = replace(value, flag == "M", NA))  ## Missing

  if("qual" %in% names(w)){
    w <- dplyr::mutate(w,
                       # Convert to ascii
                       qual = stringi::stri_escape_unicode(qual),
                       qual = replace(qual, qual == "\\u2020",
                                      "Only preliminary quality checking"),
                       qual = replace(qual, qual == "\\u2021",
                                      paste0("Partner data that is not subject",
                                             " to review by the National ",
                                             "Climate Archives")))
  }
  w <- w %>%
    tidyr::gather(type, value, flag, value) %>%
    dplyr::mutate(variable = replace(variable, type == "flag",
                                     paste0(variable[type == "flag"],
                                            "_flag"))) %>%
    dplyr::select(date, dplyr::everything(), -type) %>%
    tidyr::spread(variable, value)

  ## Can we convert to numeric?
  #w$wind_spd[c(54, 89, 92)] <- c(">3", ">5", ">10")

  num <- apply(w[, !(names(w) %in% c("date", "year", "month",
                                     "day", "hour", "time", "qual",
                                     "weather",
                                     grep("flag", names(w), value = TRUE)))],
               MARGIN = 2,
               FUN = function(x) tryCatch(as.numeric(x),
                                          warning = function(w) w))

  warn <- vapply(num,
                 FUN = function(x) methods::is(x, "warning"),
                 FUN.VALUE = TRUE)
  if(any(warn)) {
    if(!quiet) {
      m <- paste0(names(num)[warn], collapse = ", ")
      message("Some variables have non-numeric values (", m, ")")
    }
    for(i in names(num)[warn]) {
      problems <- w[grep("<|>|\\)|\\(", w[,i]),
                    names(w) %in% c("date", "year", "month",
                                    "day", "hour", "time", i)]
      if(nrow(problems) > 20) rows <- 20 else rows <- nrow(problems)
      if(!quiet) {
        message(paste0(utils::capture.output(problems[seq_along(rows),]),
                       collapse = "\n"), if (rows < nrow(problems)) "\n...")
      }
    }
    if(!is.null(string_as)) {
      if(!quiet) message("Replacing with ", string_as,
                         ". Use 'string_as = NULL' to keep ",
                         "as characters (see ?weather).")

      suppressWarnings({
        valid_cols <- c("date", "year", "month", "day",
                        "hour", "time", "qual", "weather",
                        grep("flag", names(w), value = TRUE))

        replacement <- apply(w[, !(names(w) %in% valid_cols)],
                             MARGIN = 2,
                             FUN = as.numeric)

        w[, !(names(w) %in% valid_cols)] <- replacement
      })
    } else {
      if(!quiet) {
        m <- paste0(names(num)[warn],
                    collapse = ", ")
        message("Leaving as characters (", m,
                "). Cannot summarize these values.")
      }

      replace <- c("date", "year", "month", "day",
                   "hour", "time", "qual", "weather",
                   grep("flag", names(w), value = TRUE),
                   names(num)[warn])

      w[, !(names(w) %in% replace)] <-
        num[!warn]
    }
  } else {
    w[, !(names(w) %in% c("date", "year", "month", "day",
                          "hour", "time", "qual", "weather",
                          grep("flag", names(w), value = TRUE)))] <- num
  }

  w
}

#' @export
weather <- function(station_ids,
                       start = NULL, end = NULL,
                       interval = "hour",
                       trim = TRUE,
                       format = TRUE,
                       string_as = NA,
                       tz_disp = NULL,
                       stn = weathercan::stations,
                       url = NULL,
                       encoding = "UTF-8",
                       list_col = FALSE,
                       verbose = FALSE,
                       quiet = FALSE) {
  .Deprecated("weather_dl")
}
