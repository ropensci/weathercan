#' Download weather data from Environment and Climate Change Canada
#'
#' Downloads data from Environment and Climate Change Canada (ECCC) for one or
#' more stations. For details and units, see the glossary vignette
#' (`vignette("glossary", package = "weathercan")`) or the glossary online
#' <http://climate.weather.gc.ca/glossary_e.html>.
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
#'   For hourly data, timezones are always "UTC", but the actual times are
#'   either local time (default; `time_disp = "none"`), or UTC (`time_disp =
#'   "UTC"`). When `time_disp = "none"`, times reflect the local time without
#'   daylight savings. This means that relative measures of time, such as
#'   "nighttime", "daytime", "dawn", and "dusk" are comparable among stations in
#'   different timezones. This is useful for comparing daily cycles. When
#'   `time_disp = "UTC"` the times are transformed into UTC timezone. Thus
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
#' @param time_disp Character. Either "none" (default) or "UTC". See details.
#' @param tz_disp DEPRECATED. See details
#' @param stn Data frame. The \code{stations} data frame to use. Will use the
#'   one included in the package unless otherwise specified.
#' @param url DEPRECATED. To set a different url use `options()` (see details).
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
                       time_disp = "none",
                       tz_disp = NULL,
                       stn = weathercan::stations,
                       url = NULL,
                       encoding = "UTF-8",
                       list_col = FALSE,
                       verbose = FALSE,
                       quiet = FALSE) {

  if(!is.null(url)) {
    warning("'url' is deprecated, use ",
            "`options(weathercan.urls.weather = \"your_new_url\")` instead",
            .call = FALSE)
  }

  if(!is.null(tz_disp)) {
    warning("'tz_disp' is deprecated, see Details under ?weather_dl", .call = FALSE)
  }

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

  w_all <- data.frame()
  missing <- c()
  end_dates <- c()
  msg_fmt <- dplyr::tibble()

  for(s in station_ids) {
    if(verbose) message("Getting station: ", s)

    stn1 <- stn %>%
      dplyr::filter(.data$station_id %in% s,
                    !is.na(.data$start),
                    .data$interval == !!interval) %>%
      dplyr::arrange(.data$interval)

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
                                                  .data$station_id %in% s,
                                                  !is.na(.data$start)))),
                                    collapse = "\n")))
        return(dplyr::tibble())
      }
    }

    if(class(try(as.Date(stn1$start), silent = TRUE)) == "try-error") {
      stn1 <- dplyr::mutate(stn1,
                            start = lubridate::ymd(as.character(.data$start),
                                                   truncated = 2),
                            start = lubridate::floor_date(.data$start, "year"))
    }
    if(class(try(as.Date(stn1$end), silent = TRUE)) == "try-error") {
      stn1 <- dplyr::mutate(stn1,
                            end = lubridate::ymd(as.character(.data$end),
                                                 truncated = 2),
                            end = lubridate::ceiling_date(.data$end, "year"))
    }
    stn1 <- stn1 %>%
      dplyr::mutate(end = replace(.data$end, .data$end > Sys.Date(), Sys.Date()),
                    int = lubridate::interval(.data$start, .data$end),
                    interval = factor(.data$interval,
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
                                                  .data$station_id %in% s,
                                                  !is.na(.data$start)))),
                                    collapse = "\n")))
        return(dplyr::tibble())
      }
    }

    if(interval == "hour") {
      date_range <- seq(lubridate::floor_date(s.start, unit = "month"),
                        lubridate::floor_date(s.end, unit = "month"),
                        by = dplyr::if_else(interval %in% c("hour"), "month", "year"))
    } else if(interval == "day") {
      date_range <- seq(lubridate::floor_date(s.start, unit = "year"),
                        lubridate::floor_date(s.end, unit = "year"), by = "year")
    } else if(interval == "month") {
      date_range <- lubridate::floor_date(s.start, unit = "year")
    }

    w <- dplyr::tibble(date_range = date_range) %>%
      dplyr::mutate(html = purrr::map(.data$date_range,
                                      ~ weather_html(station_id = s,
                                                     date = .x,
                                                     interval = interval)),
                    data = purrr::map(.data$html,
                                      ~ weather_raw(.,
                                                    encoding = encoding,
                                                    header = TRUE)))

    # Extract only most recent meta
    meta <-  weather_html(station_id = s,
                              interval = interval,
                              format = "txt") %>%
      meta_raw(encoding = encoding, interval = interval) %>%
      meta_format(s = s)

    w <- dplyr::select(w, "data")

    if(utils::packageVersion("tidyr") > "0.8.99") {
      w <- tidyr::unnest(w, .data$data)
    } else w <- tidyr::unnest(w)

    ## Format data if requested
    if(format) {
      if(verbose) message("Formatting station data: ", s)

      w <- w %>%
        dplyr::select(-"Station Name", -"Climate ID",
                      -dplyr::contains("Latitude"),
                      -dplyr::contains("Longitude")) %>%
        weather_format(meta = meta,
                       stn = stn,
                       interval = interval,
                       time_disp = time_disp,
                       string_as = string_as,
                       quiet = quiet)
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
                                                    .data$station_id %in% s,
                                                    !is.na(.data$start)))),
                                      collapse = "\n")))
          return(dplyr::tibble())
        }
      }
    }

    ## Add header info
    if(verbose) message("Adding header data: ", s)
    if(nrow(w) > 0) w <- cbind(meta, w)

    ## Fill missing headers with NA
    w[names(m_names)[!names(m_names) %in% names(w)]] <- NA

    w_all <- rbind(w_all, w)
  }

  if(nrow(w_all) > 0) {
    ## Trim to available data provided it is formatted
    if(trim && format && nrow(w_all) > 0){
      if(verbose) message("Trimming missing values before and after")
      temp <-  w_all[, !(names(w_all) %in% c(names(m_names), "date", "time",
                                             "year", "month",
                                             "day", "hour", "qual"))]
      temp <- w_all$date[which(rowSums(is.na(temp) | temp == "") != ncol(temp))]

      w_all <- w_all[w_all$date >= min(temp) & w_all$date <= max(temp), ]
    }

    m <- names(m_names)[names(m_names) %in% names(w_all)]

    ## Arrange
    w_all <- dplyr::select(w_all,
                           dplyr::one_of(m),
                           dplyr::everything())

    ## If list_col is TRUE and data is formatted
    if(list_col && format) {
      w_all <- weather_list_cols(w_all, interval, names = m)
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
                                   .data$station_id %in% missing,
                                   !is.na(.data$start)))),
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
                                   .data$station_id %in% end_dates,
                                   !is.na(.data$start)))),
                     collapse = "\n")))
  }
  ## Return Format messages
  msg_fmt <- dplyr::filter(msg_fmt, !is.na(col))
  if(!quiet && nrow(msg_fmt) > 0) {
    cols <- paste0(unique(msg_fmt$col), collapse = ", ")
    stations_msg <- paste0(unique(msg_fmt$station_id), collapse = ", ")
    message("Some variables have non-numeric values (", cols,
            "), for stations: ", stations_msg)
    if(all(is.na(msg_fmt$replace) | msg_fmt$replace != "no_replace")) {
      message("  Replaced all non-numeric entries with ",
              msg_fmt$replace[1], ". ",
              "Use 'string_as = NULL' to keep as characters (see ?weather_dl).")
    } else {
      message("  Left all non-numeric entries as characters. ",
              "Couldn't summarize these columns.")
    }

    if(verbose) {
      show <- msg_fmt %>%
        dplyr::select("station_id", "problems")

      if(utils::packageVersion("tidyr") > "0.8.99") {
        show <- tidyr::unnest(show, .data$problems)
      } else {
        show <- tidyr::unnest(show)
      }

      message("  Examples:  ")
      message(paste0("  ", utils::capture.output(show), collapse = "\n"))
    }
  }

  if(interval == "hour" && !getOption("weathercan.time.message")){
   message("As of weathercan v0.3.0 time display is either local time or UTC\n",
           "See Details under ?weather_dl for more information.\n",
           "This message is shown once per session")
    options("weathercan.time.message" = TRUE)
  }

  dplyr::tbl_df(w_all)
}


weather_html <- function(station_id,
                         date = NULL,
                         interval = "hour",
                         format = "csv") {

  q <- list(format = format, stationID = station_id,
            timeframe = ifelse(interval == "hour", 1,
                               ifelse(interval == "day", 2,
                                      3)),
            submit = 'Download+Data')
  if(format == "csv") {
    q['Year'] <- format(date, "%Y")
    q['Month'] = format(date, "%m")
  }

  html <- httr::GET(url = getOption("weathercan.urls.weather"),
                    query = q)
  httr::stop_for_status(html)
  html
}


weather_raw <- function(html, skip = 0,
                        nrows = -1,
                        header = TRUE,
                        encoding = "UTF-8") {

  raw <- httr::content(html, type = "raw")

  # Look for and remove BOM
  if(raw[1] == as.raw(0xef) &
     raw[2] == as.raw(0xbb) &
     raw[3] == as.raw(0xbf)) {
    raw <- raw[4:length(raw)]
  }

  w <- iconv(readBin(raw, character()),
             from = "UTF-8", to = "UTF-8") %>%
    utils::read.csv(text = .,
                    nrows = nrows, strip.white = TRUE,
                    skip = skip, header = header,
                    colClasses = "character", check.names = FALSE)

    # For some reason the flags "^" are replaced with "I",
    # change back to match flags on ECCC website
  if(utils::packageVersion("dplyr") > package_version("0.8.0")) {
    w <- dplyr::mutate_at(w, .vars = dplyr::vars(dplyr::ends_with("Flag")),
                          list(~gsub("^I$", "^", .)))
  } else {
    w <- dplyr::mutate_at(w, .vars = dplyr::vars(dplyr::ends_with("Flag")),
                          dplyr::funs(gsub("^I$", "^", .)))
  }
  w
}


weather_format <- function(w, stn, meta, interval = "hour",
                           string_as = "NA", time_disp = NULL, quiet = FALSE) {

  ## Get names from stored name list
  n <- w_names[[interval]]

  ## Trim to match names in data
  n <- n[n %in% names(w)]

  w <- dplyr::rename(w, !!n)

  if(interval == "day") w <- dplyr::mutate(w, date = as.Date(.data$date))
  if(interval == "month") {
    w <- dplyr::mutate(w, date = as.Date(paste0(.data$date, "-01")))
  }

  ## Get correct timezone
  if(interval == "hour"){
    w <- dplyr::mutate(w, time = as.POSIXct(.data$time, tz = "UTC"))
    if(time_disp == "UTC") {
      offset <- tz_hours(stn$tz[stn$station_id == meta$station_id[1]][1])
      w <- dplyr::mutate(w, time = .data$time + lubridate::hours(offset))
    }
    w <- dplyr::mutate(w, date = lubridate::as_date(.data$time))
  }

  ## Replace some flagged values with NA
  w <- w %>%
    tidyr::gather(key = "variable", value = "value",
                  names(w)[!(names(w) %in% c("date", "year", "month", "day",
                                             "hour", "time", "qual",
                                             "weather"))]) %>%
    tidyr::separate(.data$variable, into = c("variable", "type"),
                    sep = "_flag", fill = "right") %>%
    dplyr::mutate(type = replace(.data$type, .data$type == "", "flag"),
                  type = replace(.data$type, is.na(.data$type), "value")) %>%
    tidyr::spread(.data$type, .data$value) %>%
    dplyr::mutate(value = replace(.data$value, .data$value == "", NA),  ## No data
                  value = replace(.data$value, .data$flag == "M", NA))  ## Missing

  if("qual" %in% names(w)){
    w <- dplyr::mutate(w,
                       # Convert to ascii
                       qual = stringi::stri_escape_unicode(.data$qual),
                       qual = replace(.data$qual, .data$qual == "\\u2020",
                                      "Only preliminary quality checking"),
                       qual = replace(.data$qual, .data$qual == "\\u2021",
                                      paste0("Partner data that is not subject",
                                             " to review by the National ",
                                             "Climate Archives")))
  }
  w <- w %>%
    tidyr::gather(key = "type", value = "value", .data$flag, .data$value) %>%
    dplyr::mutate(variable = replace(.data$variable, .data$type == "flag",
                                     paste0(.data$variable[.data$type == "flag"],
                                            "_flag"))) %>%
    dplyr::select(date, dplyr::everything(), -"type") %>%
    tidyr::spread(.data$variable, .data$value)

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
      problems <- w[grep("<|>|\\)|\\(", w[[i]]),
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

      non_num <- dplyr::mutate(non_num, replace = "no_replace")

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

weather_list_cols <- function(w_all, interval, names) {
  w_all <- dplyr::as_tibble(w_all)
  ## Appropriate grouping levels
  if(utils::packageVersion("tidyr") > "0.8.99") {
    col <- dplyr::case_when(interval == "hour" ~ "date",
                            interval == "day" ~ "month",
                            interval == "month" ~ "year")

    w_all <- tidyr::nest(w_all, key = -dplyr::one_of(names, col))

  } else {
    if(interval == "hour"){
      w_all <- tidyr::nest(w_all, -dplyr::one_of(names), -"date")
    }

    if(interval == "day"){
      w_all <- tidyr::nest(w_all, -dplyr::one_of(names), -"month")
    }

    if(interval == "month"){
      w_all <- tidyr::nest(w_all, -dplyr::one_of(names), -"year")
    }
  }
  w_all
}

meta_raw <- function(html, encoding = "UTF-8", interval, return = "meta") {

  split <- httr::content(html, as = "text", encoding = encoding) %>%
    stringr::str_split("\n", simplify = TRUE) %>%
    stringr::str_subset("^\r$", negate = TRUE)

  if(return == "meta") {
    i <- dplyr::case_when(interval == "hour" ~ "All times",
                          TRUE ~ "Legend")
    r <- utils::read.delim(text = httr::content(html, as = "text",
                                                type = "text/csv",
                                                encoding = encoding),
                           nrows = stringr::str_which(split, i) - 1,
                           header = FALSE, check.names = FALSE,
                           colClasses = "character")

    if(ncol(r) > 2) {
      r <- dplyr::mutate(r, V2 = paste0(.data$V2, .data$V3)) %>%
        dplyr::select("V1", "V2")
    }
  } else if(return == "legend") {
    r <- utils::read.delim(text = httr::content(html, as = "text",
                                                type = "text/csv",
                                                encoding = encoding),
                           skip = stringr::str_which(split, "Legend") + 1,
                           strip.white = TRUE,
                           header = FALSE, check.names = FALSE,
                           colClasses = "character")
  }
  r
}

meta_format <- function(meta, s) {

  m <- paste0("(", paste0(m_names, collapse = ")|("), ")")

  meta <- meta %>%
    dplyr::mutate(V1 = stringr::str_extract(.data$V1, pattern = m)) %>%
    dplyr::filter(!is.na(.data$V1)) %>%
    tidyr::spread(.data$V1, .data$V2)

  m <- m_names[m_names %in% names(meta)]

  meta %>%
    dplyr::select(m) %>%
    dplyr::mutate(station_id = s,
                  prov = province[.data$prov],
                  lat = as.numeric(as.character(.data$lat)),
                  lon = as.numeric(as.character(.data$lon)),
                  elev = as.numeric(as.character(.data$elev)))
}
