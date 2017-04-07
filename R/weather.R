#' Download weather data from Environment Canada
#'
#' Downloads data from Environment Canada for one or more stations.
#'
#' @details Data can be returned 'raw' (format = FALSE) or can be formatted.
#' Formatting transforms dates/times to date/time class, renames columns, and
#' converts data to numeric where possible. If character strings are contained in
#' traditionally numeric fields (e.g., weather speed may have values such as "<
#' 30"), they can be replaced with a character specified by `string_as`. The
#' default is NA. Formating also replaces data associated with certain flags
#' with NA (M = Missing).
#'
#' Start and end date can be specified, but if not, it will
#' default to the start and end date of the range (this could result in
#' downloading a lot of data!).
#'
#' Times are returned as the Etc/GMT offset timezone corresponding to the
#' location. This doesn't include daylight savings. However, for compatibility
#' with other data sets, timezones can be converted by specifying the desired
#' timezone in `tz_disp`.
#'
#' @param station_ids Numeric/Character. A vector containing the ID(s) of the
#'  station(s) you wish to download data from. See the \code{\link{stations}}
#'  data frame or the \code{\link{stations_search}} function to find IDs.
#' @param start Date/Character. The start date of the data in YYYY-MM-DD format
#'  (applies to all stations_ids). Defaults to start of range.
#' @param end Date/Character. The end date of the data in YYYY-MM-DD format
#'  (applies to all station_ids). Defaults to end of range.
#' @param interval Character. Interval of the data, one of "hour", "day",
#'  "month".
#' @param trim Logical. Trim missing values from the start and end of the weather
#'  dataframe.
#' @param avg Character. (NOT USEABLE) Whether and how to average the data
#' @param best Logical. (NOT USEABLE) If TRUE, returns data at the best frame to
#'  maximize data according to the date range (this could result in less data
#'  from other weather measurements, see Details). If FALSE, returns data from
#'  exact interval specified.
#' @param format Logical. If TRUE, formats data for immediate use. If FALSE,
#'  returns data exactly as downloaded from Environment Canda. Useful for
#'  dealing with changes by Environment Canada to the format of data downloads.
#' @param string_as Character. What value to replace character strings in a
#'  numeric measurement with. See Details.
#' @param tz_disp Character. What timezone to display times in (must be one of
#'  \code{OlsonNames()}).
#' @param stations_data Data frame. The \code{stations} data frame to use. Will use the one
#'  included in the package unless otherwise specified.
#' @param url Character. Url from which to grab the weather data
#' @param encoding Character. Text encoding for download.
#' @param verbose Logical. Include messages
#'
#' @return A tibble with station ID, name and weather data.
#'
#' @examples
#'
#' \dontrun{
#' kam <- weather(station_ids = 51423,
#'                start = "2016-01-01", end = "2016-02-15")
#' }
#'
#' stations_search("Kamloops A$", interval = "hour")
#' stations_search("Prince George Airport", interval = "hour")
#'\dontrun{
#' kam.pg <- weather(station_ids = c(48248, 51423),
#'                   start = "2016-01-01", end = "2016-02-15")
#'
#' library(ggplot2)
#'
#' ggplot(data = kam.pg, aes(x = time, y = temp, group = station_name, colour = station_name)) +
#'        geom_line()
#'}
#'
#' @export
#' @import lubridate
#' @import magrittr
weather <- function(station_ids,
                    start = NULL, end = NULL,
                    interval = "hour",
                    trim = TRUE,
                    avg = "none",
                    best = FALSE,
                    format = TRUE,
                    string_as = NA,
                    tz_disp = NULL,
                    stations_data = NULL,
                    url = "http://climate.weather.gc.ca/climate_data/bulk_data_e.html",
                    encoding = "UTF-8",
                    verbose = FALSE) {

  # station_id = 51423; start = "2016-01-01"; end = "2016-02-15"; format = FALSE; interval = "hour"; avg = "none"; string_as = NA; stn = NULL; url = "http://climate.weather.gc.ca/climate_data/bulk_data_e.html"

   #station_ids = 54398; start = "2016-01-01"; end = NULL; format = FALSE; interval = "day"; avg = "none"; string_as = NA; stn = NULL; url = "http://climate.weather.gc.ca/climate_data/bulk_data_e.html"

  #'
  ## AVERAGE CAN ONLY BE day, month, year
  ## AVERAGE Has to be larger interval than interval

  ## Address as.POSIXct...
  if((!is.null(start) & class(try(as.Date(start), silent = TRUE)) == "try-error") |
     (!is.null(end) & class(try(as.Date(end), silent = TRUE)) == "try-error")) {
    stop("'start' and 'end' must be either a standard date format (YYYY-MM-DD) or NULL")
  }

  if(length(interval) > 1) stop("'interval' must be either 'hour', 'day', OR 'month'")
  if(!(interval %in% c("hour", "day", "month"))) stop("'interval' must be either 'hour', 'day', OR 'month'")

  w_all <- data.frame()
  for(s in station_ids) {
    if(verbose) message("Getting station: ", s)
    if(is.null(stations_data)) stn <- envirocan::stations else stn <- stations_data
    stn <- stn %>%
      dplyr::filter_(lazyeval::interp("station_id %in% x & !is.na(start)", x = s),
                     lazyeval::interp("interval == x", x = interval)) %>%
      dplyr::arrange(interval)

    if(nrow(stn) == 0) {
      message("There are no data for station ", s, " for interval by '", interval, "'.",
           "\nAvailable Station Data:\n",
           paste0(utils::capture.output(print(envirocan::stations %>%
                                                dplyr::filter_(lazyeval::interp("station_id %in% x & !is.na(start)", x = s)))), collapse = "\n"))
      next
    }

    if(class(try(as.Date(stn$start), silent = TRUE)) == "try-error") {
      stn <- dplyr::mutate(stn, start = floor_date(as_date(as.character(start), "%Y"), "year"))
    }
    if(class(try(as.Date(stn$end), silent = TRUE)) == "try-error") {
      stn <- dplyr::mutate(stn, end = ceiling_date(as_date(as.character(end), "%Y"), "year"))
    }
    stn <- stn %>%
      dplyr::mutate(end = replace(end, end > Sys.Date(), Sys.Date()),
                    int = interval(start, end),
                    interval = factor(interval, levels = c("hour", "day", "month"), ordered = TRUE))

    if(is.null(start)) s.start <- stn$start else s.start <- as.Date(start)
    if(is.null(end)) s.end <- Sys.Date() else s.end <- as.Date(end)
    dates <- interval(s.start, s.end)

    ## If the selected time frame is not complely available change the parameters and warn

    if(best == TRUE){
      message("The 'best' option is currently unavailable")
      best <- FALSE
    }

    date_range <- seq(floor_date(s.start, unit = "month"),
                      floor_date(s.end, unit = "month"),
                      by = ifelse(interval %in% c("hour"), "month", "year"))
    date_range <- unique(date_range)

    if(interval == "month") date_range <- date_range[1]

    preamble <- weather_dl(station_id = s, date = date_range[1], interval = interval, nrows = 25, header = FALSE, encoding = encoding)
    skip <- grep("Date/Time", preamble[, 1])

    if(verbose) message("Downloading station data")
    w <- data.frame()
    for(i in 1:length(date_range)){
      w <- rbind(w, weather_dl(station_id = s,
                               date = date_range[i],
                               interval = interval,
                               skip = skip,
                               url = url,
                               encoding = encoding))
    }

    ## Add header info
    if(verbose) message("Adding header data")
    w <- w %>%
      dplyr::mutate(prov = unique(stn$prov),
                    station_name = preamble[1, 2], ##Deal BOM in collected metadata
                    station_id = s,
                    lat = as.numeric(as.character(preamble$V2[preamble$V1 %in% "Latitude"])),
                    lon = as.numeric(as.character(preamble$V2[preamble$V1 %in% "Longitude"])),
                    elev = as.numeric(as.character(preamble$V2[preamble$V1 %in% "Elevation"])),
                    climat_id = preamble$V2[preamble$V1 %in% "Climate Identifier"],
                    WMO_id = preamble$V2[preamble$V1 %in% "WMO Identifier"],
                    TC_id = preamble$V2[preamble$V1 %in% "TC Identifier"]
      )

    ## Format data if requested
    if(format) {
      if(verbose) message("Formating station data")
      w <- weather_format(w = w,
                          interval = interval,
                          tz_disp = tz_disp,
                          string_as = string_as)
    }

    ## Trim to match date range
    w <- w[w$date >= s.start & w$date <= s.end, ]


    w_all <- rbind(w_all, w)
  }

  ## Trim to available data
  if(trim & nrow(w_all) > 0){
    if(verbose) message("Trimming missing values before and after")
    temp <-  w_all[, !(names(w_all) %in% c("date", "time", "prov", "station_name", "station_id", "lat", "lon", "year", "month", "day", "qual","elev", "climat_id", "WMO_id", "TC_id"))]
    temp <- w_all$date[which(rowSums(is.na(temp) | temp == "") != ncol(temp))]
    w_all <- w_all[w_all$date >= min(temp) & w_all$date <= max(temp), ]
  }

  if(nrow(w_all) > 0){

    ## Average if requested
    if(avg != "none"){
      if(verbose) message("Averaging station data")
      message("Averaging is currently unavailable")
    }

    ## Arrange
    w_all <- dplyr::select(w_all, station_name, station_id, dplyr::everything())
  }

  return(dplyr::tbl_df(w_all))
}


weather_dl <- function(station_id,
                   date,
                   interval = "hour",
                   skip = 0,
                   nrows = -1,
                   header = TRUE,
                   url = "http://climate.weather.gc.ca/climate_data/bulk_data_e.html",
                   encoding = "UTF-8") {

  html <- httr::GET(url, query = list(format = 'csv',
                              stationID = station_id,
                              timeframe = ifelse(interval == "hour", 1, ifelse(interval == "day", 2, 3)),
                              Year = format(date, "%Y"),
                              Month = format(date, "%m"),
                              submit = 'Download+Data'))

  utils::read.csv(text = httr::content(html, as = "text", type = "text/csv", encoding = encoding),
                  nrows = nrows, strip.white = TRUE, skip = skip, header = header, colClasses = "character")
}




#' @import magrittr

weather_format <- function(w, interval = "hour", string_as = "NA", tz_disp = NULL) {

  ## Get names from stored name list
  n <- w_names[[interval]]

  # Omit preamble stuff for now
  preamble <- w[, names(w) %in% c("prov", "station_name", "station_id", "lat", "lon", "elev", "climat_id", "WMO_id", "TC_id")]
  w <- w[, !(names(w) %in% names(preamble))]

  names(w) <- n

  if(interval == "day") w <- dplyr::mutate(w, date = as.Date(date))
  if(interval == "month") w <- dplyr::mutate(w, date = as.Date(paste0(date, "-01")))

  ## Get correct timezone
  if(interval == "hour"){
    tz <- get_tz(coords = unique(preamble[, c("lat", "lon")]), etc = TRUE)
    w$time <- as.POSIXct(w$time, tz = tz)
    w$date <- as.Date(w$time, tz = tz)
    if(!is.null(tz_disp)){
      w$time <- lubridate::with_tz(w$time, tz = tz_disp)    ## Display in timezone
    }
  }

  ## Replace some flagged values with NA
  w <- w %>%
    tidyr::gather_("variable", "value", names(w)[!(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather"))]) %>%
    tidyr::separate(variable, into = c("variable", "type"), sep = "_flag", fill = "right") %>%
    dplyr::mutate(type = replace(type, type == "", "flag"),
                  type = replace(type, is.na(type), "value")) %>%
    tidyr::spread(type, value) %>%
    dplyr::mutate(value = replace(value, value == "", NA),  ## No data
                  value = replace(value, flag == "M", NA))  ## Missing

  if("qual" %in% names(w)){
    w <- dplyr::mutate(w,
                       qual = stringi::stri_escape_unicode(qual), # Convert to ascii
                       qual = replace(qual, qual == "\\u2020", "Only preliminary quality checking"),
                       qual = replace(qual, qual == "\\u2021", "Partner data that is not subject to review by the National Climate Archives"))
  }
  w <- w %>%
    tidyr::gather(type, value, flag, value) %>%
    dplyr::mutate(variable = replace(variable, type == "flag", paste0(variable[type == "flag"], "_flag")))   %>%
    dplyr::select(date, dplyr::everything(), -type) %>%
    tidyr::spread(variable, value)

  ## Can we convert to numeric?
  #w$wind_spd[c(54, 89, 92)] <- c(">3", ">5", ">10")

  num <- apply(w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE)))], 2, FUN = function(x) tryCatch(as.numeric(x), warning = function(w) w))

  if(any(sapply(num, FUN = function(x) methods::is(x, "warning")))) {
    message("Some variables have non-numeric values (", paste0(names(num)[sapply(num, FUN = function(x) methods::is(x, "warning"))], collapse = ", "), ")")
    for(i in names(num)[sapply(num, FUN = function(x) methods::is(x, "warning"))]) {
      problems <- w[grep("<|>|\\)|\\(", w[,i]), names(w) %in% c("date", "year", "month", "day", "hour", "time", i)]
      if(nrow(problems) > 20) rows <- 20 else rows <- nrow(problems)
      message(paste0(utils::capture.output(problems[1:rows,]), collapse = "\n"), if (rows < nrow(problems)) "\n...")
    }
    if(!is.null(string_as)) {
      message("Replacing with ", string_as, ". Use 'string_as = NULL' to keep as characters (see ?weather).")
      suppressWarnings(w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE)))] <- apply(w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE)))], 2, as.numeric))
    } else {
      message("Leaving as characters (", paste0(names(num)[sapply(num, FUN = function(x) methods::is(x, "warning"))], collapse = ", "), "). Cannot summarize these values.")
      w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE), names(num)[sapply(num, FUN = function(x) methods::is(x, "warning"))]))] <- num[!sapply(num, FUN = function(x) methods::is(x, "warning"))]
    }
  } else {
    w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE)))] <- num
  }

  if(length(preamble) > 0){
    w <- cbind(preamble[, c("prov", "station_name", "station_id", "lat", "lon")], w, preamble[, c("elev", "climat_id", "WMO_id", "TC_id")])
  }

  return(w)
}

weather_avg <- function(w, interval = "hour", avg = "none") {
  ## Average if requested
  if(avg != "none") {

    ## Check for flags and warn
    flags <- w[, names(w)[grep("flag", names(w))]] %>%
      tidyr::gather(type, flag) %>%
      dplyr::mutate(flag = replace(flag, flag == "M" | flag == "L", "")) %>%
      dplyr::filter(flag != "")

    if(nrow(flags) > 0) {
      if(nrow(flags) > 20) rows <- 20 else rows <- nrow(flags)
      message("To summarize, ignoring ", nrow(flags), " flags:")
      message(paste0(utils::capture.output(flags[1:rows,]), collapse = "\n"))
    }

    ## Check for character vectors
    keep <- c("day", "month", "year", names(which(sapply(w, "class") == "numeric")))
    w <- w[, keep]
    if(avg %in% c("day", "month", "year")){
      #w <-

      temp <- w %>%
        dplyr::group_by(year, month, day) %>%
        dplyr::summarize(max_temp = max(temp, na.rm = TRUE),
                         min_temp = min(temp, na.rm = TRUE),
                         mean_temp = mean(temp, na.rm = TRUE),
                         mean_hmdx = mean(hmdx, na.rm = TRUE),
                         mean_pressure = mean(pressure, na.rm = TRUE),
                         mean_rel_hum = mean(rel_hum, na.rm = TRUE),
                         mean_temp_dew = mean(temp_dew, na.rm = TRUE),
                         mean_visib = mean(visib, na.rm = TRUE),
                         mean_wind_chill = mean(wind_chill, na.rm = TRUE)) %>%
        dplyr::left_join(w %>%
                           dplyr::group_by(year, month, day) %>%
                           dplyr::summarize_each(dplyr::funs(n = length(.[!is.na(.)])), dplyr::everything()),
                         interval = c("year", "month", "day"))

      # Add degree days
    }
    if(avg %in% c("month", "year")){
      temp <- temp %>%
        dplyr::select(-day) %>%
        dplyr::group_by_(.dots = c("year", "month")) %>%
        dplyr::summarize_each(funs = dplyr::funs(mean(., na.rm = TRUE)))

    }
    if(avg %in% c("year")){
      temp <- temp %>%
        dplyr::select(-month) %>%
        dplyr::group_by_(.dots = c("year")) %>%
        dplyr::summarize_each(funs = dplyr::funs(mean(., na.rm = TRUE)))
    }

  }
}



