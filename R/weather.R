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
#'   The default is NA. Formatting also replaces data associated with certain
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
#' \donttest{
#' kam <- weather_dl(station_ids = 51423,
#'                   start = "2016-01-01", end = "2016-02-15")
#' }
#'
#' stations_search("Kamloops A$", interval = "hour")
#' stations_search("Prince George Airport", interval = "hour")
#'\donttest{
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
  missing <- c()
  end_dates <- c()
  msg_fmt <- dplyr::tibble()

  for(s in station_ids) {
    if(verbose) message("Getting station: ", s)
    stn1 <- stn %>%
      dplyr::filter(station_id %in% s,
                    !is.na(start),
                    interval == !! interval) %>%
      dplyr::arrange(interval)

    ## Check if station missing that interval
    if(nrow(stn1) == 0) {
      if(length(station_ids) > 1) {
        missing <- c(missing, s)
        if(!quiet) message("No data for station ", s)
        next
      } else {

        if(!quiet) message(paste0("There are no data for station ", s, " ",
                                  "for this interval (", interval, ")",
                                  "\nAvailable Station Data:\n",
                                  paste0(utils::capture.output(print(
                                    dplyr::filter(stn,
                                                  station_id %in% s,
                                                  !is.na(start)))),
                                    collapse = "\n")))
        return(dplyr::tibble())
      }
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

    if(is.null(start)) {
      s.start <- stn1$start
      msg.start <- "earliest date"
    } else {
      s.start <- as.Date(start)
      msg.start <- start
    }

    if(is.null(end)) s.end <- Sys.Date() else s.end <- as.Date(end)
    msg.end <- as.character(s.end)

    dates <- lubridate::interval(s.start, s.end)

    if(lubridate::int_end(dates) < lubridate::int_start(dates)) {
      if(length(station_ids) > 1) {
        if(!quiet) message("End date earlier than start date for station ", s)
        end_dates <- c(end_dates, s)
        next
      } else {
        if(!quiet) message(paste0("The end date (", msg.end, ") ",
                                  "is earlier than the start date (",
                                  as.character(s.start),
                                  ") for station ", s, " for this interval (",
                                  interval, "), ",
                                  "\nAvailable Station Data:\n",
                                  paste0(utils::capture.output(print(
                                    dplyr::filter(stn,
                                                  station_id %in% s,
                                                  !is.na(start)))),
                                    collapse = "\n")))
        return(dplyr::tibble())
      }
    }

    date_range <- seq(lubridate::floor_date(s.start, unit = "month"),
                      lubridate::floor_date(s.end, unit = "month"),
                      by = ifelse(interval %in% c("hour"), "month", "year"))
    #date_range <- dplyr::tibble(date_range = unique(date_range))

    if(interval == "month") date_range <- date_range[1]

    w <- dplyr::tibble(date_range = date_range) %>%
      dplyr::mutate(html = purrr::map(date_range,
                                      ~ weather_html(station_id = s,
                                                     date = .x,
                                                     interval = interval,
                                                     url = url)),
                    preamble = purrr::map(html, ~ preamble_raw(.x,
                                                               encoding =
                                                                 encoding)),
                    skip = purrr::map_dbl(preamble, ~ nrow(.x))) %>%
      dplyr::filter(skip > 3) # No data, if no preamble

    if(nrow(w) > 0) {
      w <- dplyr::mutate(w, data = purrr::map2(html, skip,
                                               ~ weather_raw(.x, .y,
                                                             encoding =
                                                               encoding)))

      # Extract only most recent preamble
      preamble <- preamble_format(w$preamble[nrow(w)][[1]], s = s)

      w <- dplyr::select(w, -date_range, -skip) %>%
        tidyr::unnest(data)

      ## Format data if requested
      if(format) {
        if(verbose) message("Formatting station data: ", s)
        w <- weather_format(w = w,
                            interval = interval,
                            tz_disp = tz_disp,
                            string_as = string_as,
                            quiet = quiet,
                            preamble = preamble)
        # Catch messages
        if(nrow(w$msg) > 0) {
          msg_fmt <- dplyr::bind_rows(dplyr::bind_cols(station_id = s,
                                                       w$msg),
                                      msg_fmt)
        }

        # Get formatted data
        w <- w$data

        ## Trim to match date range
        w <- w[w$date >= s.start & w$date <= s.end, ]
      }

      ## Check if all missing, remove and message
      n <- c("time", "date", "year", "month", "day", "hour")
      temp <- w[, !(names(w) %in% n)]

      if(nrow(temp) == 0 || all(is.na(temp) | temp == "")) {
        if(length(station_ids) > 1) {
          if(!quiet) message("No data for station ", s)
          missing <- c(missing, s)
          next
        } else {
          if(!quiet) message(paste0("There are no data for station ", s, ", ",
                                    "in this time range (", msg.start,
                                    " to ", msg.end, "), for this interval (",
                                    interval, "), ",
                                    "\nAvailable Station Data:\n",
                                    paste0(utils::capture.output(print(
                                      dplyr::filter(stn,
                                                    station_id %in% s,
                                                    !is.na(start)))),
                                      collapse = "\n")))
          return(dplyr::tibble())
        }
      }

      ## Add header info
      if(verbose) message("Adding header data: ", s)
      if(nrow(w) > 0) w <- cbind(preamble, w)

      ## Fill missing headers with NA
      w[names(p_names)[!names(p_names) %in% names(w)]] <- NA


      if(interval == "hour") tz_list <- c(tz_list, lubridate::tz(w$time[1]))
      w_all <- rbind(w_all, w)
    }
  }

  if(nrow(w_all) > 0) {

    # Convert to UTC if multiple timezones
    if(interval == "hour" && is.null(tz_disp) && length(unique(tz_list)) > 1) {
      w_all$time <- lubridate::with_tz(w_all$time, "UTC")
    }


    ## Trim to available data provided it is formatted
    if(trim && format && nrow(w_all) > 0){
      if(verbose) message("Trimming missing values before and after")
      temp <-  w_all[, !(names(w_all) %in% c(names(p_names), "date", "time",
                                             "year", "month",
                                             "day", "hour", "qual"))]
      temp <- w_all$date[which(rowSums(is.na(temp) | temp == "") != ncol(temp))]

      w_all <- w_all[w_all$date >= min(temp) & w_all$date <= max(temp), ]
    }

    p <- names(p_names)[names(p_names) %in% names(w_all)]

    ## Arrange
    w_all <- dplyr::select(w_all,
                           dplyr::one_of(p),
                           dplyr::everything())

    ## If list_col is TRUE and data is formatted
    if(list_col && format){
      w_all <- dplyr::as_tibble(w_all)
      ## Appropriate grouping levels
      if(interval == "hour"){
        w_all <- tidyr::nest(w_all, -dplyr::one_of(p), -date)
      }

      if(interval == "day"){
        w_all <- tidyr::nest(w_all, -dplyr::one_of(p), -month)
      }

      if(interval == "month"){
        w_all <- tidyr::nest(w_all, -dplyr::one_of(p), -year)
      }
    }
  }

  # Return messages
  if(length(missing) > 0 & !quiet) {
    if(all(station_ids %in% missing)) type <- "all" else type <- "some"

    message(paste0("There are no data for ", type, " stations (",
                   paste0(missing, collapse = ", "), "), ",
                   "in this time range (", msg.start, " to ", msg.end, "), ",
                   "for this interval (", interval, ")",
                   "\nAvailable Station Data:\n",
                   paste0(utils::capture.output(print(
                     dplyr::filter(stn,
                                   station_id %in% missing,
                                   !is.na(start)))),
                     collapse = "\n")))
  }

  if(length(end_dates) > 0 & !quiet) {
    if(all(station_ids %in% missing)) type <- "all" else type <- "some"

    message(paste0("The end dates (", msg.end, ") are earlier than the ",
                   "start dates (", msg.start, ") for ", type, " stations (",
                   paste0(end_dates, collapse = ", "),
                   "), for this interval (", interval, "), ",
                   "\nAvailable Station Data:\n",
                   paste0(utils::capture.output(print(
                     dplyr::filter(stn,
                                   station_id %in% end_dates,
                                   !is.na(start)))),
                     collapse = "\n")))
  }
  ## Return Format messages

  msg_fmt <- dplyr::filter(msg_fmt, !is.na(col))
  if(!quiet && nrow(msg_fmt) > 0) {
    cols <- paste0(unique(msg_fmt$col), collapse = ", ")
    stations <- paste0(unique(msg_fmt$station_id), collapse = ", ")
    message("Some variables have non-numeric values (", cols,
            "), for stations: ", stations)
    if(all(!is.null(msg_fmt$replace))) {
      message("  Replaced all non-numeric entries with ",
              msg_fmt$replace[1], ". ",
              "Use 'string_as = NULL' to keep as characters (see ?weather_dl).")
    } else {
      message("  Left all non-numeric entries as characters. ",
              "Couldn't summarize these columns.")
    }

    if(verbose) {
      show <- msg_fmt %>%
        dplyr::select(station_id, problems) %>%
        tidyr::unnest()
      message("  Examples:  ")
      message(paste0("  ", utils::capture.output(show), collapse = "\n"))
    }
  }

  dplyr::tbl_df(w_all)
}


weather_html <- function(station_id,
                         date,
                         interval = "hour",
                         url = NULL) {

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
  return(html)
}

weather_raw <- function(html, skip = 0,
                        nrows = -1,
                        header = TRUE,
                        encoding = "UTF-8") {
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

  ## Trim to match names in data
  n <- n[n %in% names(w)]

  w <- dplyr::rename(w, !!!n)

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
    m <- paste0(names(num)[warn], collapse = ", ")
    non_num <- dplyr::tibble(col = names(num)[warn])
    for(i in names(num)[warn]) {
      problems <- w[grep("<|>|\\)|\\(", w[,i]),
                    names(w) %in% c("date", "year", "month",
                                    "day", "hour", "time", i)]
      if(nrow(problems) > 20) rows <- 20 else rows <- nrow(problems)
      non_num$problems <- list(problems[1:rows,])
    }
    if(!is.null(string_as)) {
      non_num$replace <- string_as
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
      m <- paste0(names(num)[warn],
                  collapse = ", ")
      non_num$replace <- NULL

      replace <- c("date", "year", "month", "day",
                   "hour", "time", "qual", "weather",
                   grep("flag", names(w), value = TRUE),
                   names(num)[warn])

      w[, !(names(w) %in% replace)] <- num[!warn]
    }
  } else {
    non_num <- data.frame()
    w[, !(names(w) %in% c("date", "year", "month", "day",
                          "hour", "time", "qual", "weather",
                          grep("flag", names(w), value = TRUE)))] <- num
  }

  list(data = w, msg = non_num)
}

preamble_raw <- function(html, nrows = 30, search_key = "Date/Time", encoding) {
  preamble <- weather_raw(html, nrows = nrows,
                          header = FALSE, encoding = encoding)
  preamble[1:grep("Date/Time", preamble$V1), ]
}

preamble_format <- function(preamble, s) {

  p <- paste0("(", paste0(p_names, collapse = ")|("), ")")

  preamble <- preamble %>%
    dplyr::mutate(V1 = stringr::str_extract(V1, pattern = p)) %>%
    dplyr::filter(!is.na(V1)) %>%
    tidyr::spread(V1, V2)

  p <- p_names[p_names %in% names(preamble)]

  preamble %>%
    dplyr::select(p) %>%
    dplyr::mutate(station_id = s,
                  prov = factor(province[prov], levels = province),
                  lat = as.numeric(as.character(lat)),
                  lon = as.numeric(as.character(lon)),
                  elev = as.numeric(as.character(elev)))
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
