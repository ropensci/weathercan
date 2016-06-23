#' Download Environment Canada Weather data
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
#' @param timeframe Character. Timeframe of the data, one of "hour", "day",
#'  "month".
#' @param trim Logical. Trim missing values from the start and end of the weather
#'  dataframe.
#' @param avg Character. (NOT USEABLE) Whether and how to average the data
#' @param best Logical. (NOT USEABLE) If TRUE, returns data at the best frame to
#'  maximize data according to the date range (this could result in less data
#'  from other weather measurements, see Details). If FALSE, returns data from
#'  exact timeframe specified.
#' @param format Logical. If TRUE, formats data for immediate use. If FALSE,
#'  returns data exactly as downloaded from Environment Canda. Useful for
#'  dealing with changes by Environment Canada to the format of data downloads.
#' @param string_as Character. What value to replace character strings in a
#'  numeric measurement with. See Details.
#' @param tz_disp Character. What timezone to display times in (must be one of
#'  \code{OlsonNames()}).
#' @param stn Data frame. The \code{stations} data frame to use. Will use the one
#'  included in the package unless otherwise specified.
#' @param url Character. Url from which to grab the weather data
#' @param verbose Logical. Include messages
#'
#' @return Data frame with station ID, name and weather data.
#'
#' @export
#' @import lubridate
#' @import magrittr
#'
#' @examples
#'
#' \dontrun{
#' kam <- weather(station_ids = 51423,
#'                start = "2016-01-01", end = "2016-02-15")
#' }
#'
#' stations_search("Kamloops A$", timeframe = "hour")
#' stations_search("Prince George Airport", timeframe = "hour")
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
weather <- function(station_ids,
                    start = NULL, end = NULL,
                    timeframe = "hour",
                    avg = "none",
                    best = FALSE,
                    format = TRUE,
                    string_as = NA,
                    tz_disp = NULL,
                    stn = NULL,
                    url = "http://climate.weather.gc.ca/climate_data/bulk_data_e.html",
                    verbose = FALSE) {

  # station_id = 51423; start = "2016-01-01"; end = "2016-02-15"; format = FALSE; timeframe = "hour"; avg = "none"; string_as = NA; stn = NULL; url = "http://climate.weather.gc.ca/climate_data/bulk_data_e.html"
  #'
  ## AVERAGE CAN ONLY BE day, month, year
  ## AVERAGE Has to be larger timeframe than timeframe

  ## Address as.POSIXct...
  if((!is.null(start) & class(try(as.Date(start), silent = TRUE)) == "try-error") |
     (!is.null(end) & class(try(as.Date(end), silent = TRUE)) == "try-error")) {
    stop("'start' and 'end' must be either a standard date format (YYYY-MM-DD) or NULL")
  }

  if(!is.null(start)) start <- as.Date(as.character(start))
  if(!is.null(end)) end <- as.Date(as.character(end))

  if(length(timeframe) > 1) stop("'timeframe' must be either 'hour', 'day', OR 'month'")
  if(!(timeframe %in% c("hour", "day", "month"))) stop("'timeframe' must be either 'hour', 'day', OR 'month'")

  w_all <- data.frame()
  for(s in station_ids) {
    if(verbose) message("Getting station: ", s)

    stn <- envirocan::stations %>%
      dplyr::filter_(lazyeval::interp("station_id %in% x & !is.na(start)", x = s)) %>%
      dplyr::arrange(timeframe)

    if(class(try(as.Date(stn$start), silent = TRUE)) == "try-error") {
      stn <- dplyr::mutate(stn,
                           start = floor_date(as_date(as.character(start), "%Y"), "year"),
                           end = ceiling_date(as_date(as.character(end), "%Y"), "year"))
    }
    stn <- stn %>%
      dplyr::mutate(end = replace(end, end > Sys.Date(), Sys.Date()),
                    int = interval(start, end),
                    timeframe = factor(timeframe, levels = c("hour", "day", "month"), ordered = TRUE))

    dates <- interval(start, end)

    ## If the selected time frame is not complely available change the parameters and warn

    if(best == TRUE){
      message("The 'best' option is currently unavailable")
      best <- FALSE
    }
    if(!(dates %within% stn$int[stn$timeframe == timeframe]) & best) {

      ## Compare number of days in each interval, pick the most days if smaller time frame
      stn$n_days <- int_length(intersect(dates, stn$int)) / 60 / 60 /24

      if(nrow(stn[stn$timeframe <= timeframe & !is.na(stn$n_days),]) == 0) stop("Station doesn't have enough data to retrieve or calculate data at this interval")

      max_stn <- stn[stn$timeframe <= timeframe & !is.na(stn$n_days) & stn$n_days == max(stn$n_days, na.rm = TRUE), ]

      if(nrow(max_stn) == 0 | any(max_stn$timeframe == timeframe)) {
        # If there's nothing smaller or better
        timeframe <- timeframe
      } else {
        ## Get by a smaller time frame and average
        message("Station doesn't have enough data by the ", timeframe, " for that interval. Downloading by ", max(max_stn$timeframe))
        #, ", averaging by ", timeframe, ".")
        #avg <- timeframe
        timeframe <- max(max_stn$timeframe)
      }

      ## If dates overlap, but not nested, date range not available, change dates to match
      if(!(dates %within% stn$int[stn$timeframe == timeframe])) {
        message("Station doesn't have data for the whole interval (", stn$n_days[stn$timeframe == timeframe], "/", round(int_length(dates) / 60 / 60 /24, 2), " days).")

        if(start < stn$start[stn$timeframe == timeframe]) {
          message("Moving start date to: ", stn$start[stn$timeframe == timeframe])
          start <- as.Date(stn$start[stn$timeframe == timeframe])
        }
        if(end > stn$end[stn$timeframe == timeframe]) {
          message("Moving end date to: ", stn$end[stn$timeframe == timeframe])
          end <- as.Date(stn$end[stn$timeframe == timeframe])
        }
      }
    }

    date_range <- seq(floor_date(start, unit = "month"),
                      floor_date(end, unit = "month"),
                      by = ifelse(timeframe == "hour", "month", "year"))

    preamble <- weather_dl(station_id = s, date = date_range[1], timeframe = timeframe, nrows = 25, header = FALSE)
    skip <- grep("Date/Time", preamble[, 1])

    #test <- read.csv(text = httr::content(html, as = "text", type = "text/csv", encoding = "ISO-8859-1"), skip = skip)

    if(verbose) message("Downloading station data")
    w <- data.frame()
    for(i in 1:length(date_range)){
      w <- rbind(w, weather_dl(station_id = s,
                               date = date_range[i],
                               timeframe = timeframe,
                               skip = skip,
                               url = url))
    }

    ## Add header info
    w <- w %>%
      dplyr::mutate(prov = unique(stn$prov),
                    station_name = preamble$V2[preamble$V1 %in% "Station Name"],
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
                          timeframe = timeframe,
                          tz_disp = tz_disp,
                          string_as = string_as)
    }
    w_all <- rbind(w_all, w)
  }

  ## Trim to match date range
  w_all <- w_all[w_all$date >= start & w_all$date <= end, ]


    ## Average if requested
  if(avg != "none"){
   if(verbose) message("Averaging station data")
    message("Averaging is currently unavailable")
  }

  ## Arrange
  w_all <- dplyr::select(w_all, station_name, station_id, everything())

  return(w_all)
}


weather_dl <- function(station_id,
                   date,
                   timeframe = "hour",
                   skip = 0,
                   nrows = -1,
                   header = TRUE,
                   url = "http://climate.weather.gc.ca/climate_data/bulk_data_e.html",
                   encoding = "ISO-8859-1") {

  html <- httr::GET(url, query = list(format = 'csv',
                              stationID = station_id,
                              timeframe = ifelse(timeframe == "hour", 1, ifelse(timeframe == "day", 2, 3)),
                              Year = format(date, "%Y"),
                              Month = format(date, "%m"),
                              submit = 'Download+Data'))

  read.csv(text = httr::content(html, as = "text", type = "text/csv", encoding = encoding),
                       nrows = nrows, strip.white = TRUE, skip = skip, header = header, colClasses = "character")
}




#' @import magrittr

weather_format <- function(w, timeframe = "hour", string_as = "NA", tz_disp = NULL) {

  if(timeframe == "hour") n <- c("time", "year", "month", "day", "hour", "qual", "temp", "temp_flag", "temp_dew", "temp_dew_flag", "rel_hum", "rel_hum_flag", "wind_dir", "wind_dir_flag", "wind_spd", "wind_spd_flag", "visib", "visib_flag", "pressure", "pressure_flag", "hmdx", "hmdx_flag", "wind_chill", "wind_chill_flag", "weather")
  if(timeframe == "day") n <- c("date", "year", "month", "day", "qual", "max_temp", "max_temp_flag", "min_temp", "min_temp_flag", "mean_temp", "mean_temp_flag", "heat_deg_days", "heat_deg_days_flag", "cool_deg_days", "cool_deg_days_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd_last_day", "snow_grnd_last_day_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag")
  if(timeframe == "month") n <- c("date", "year", "month", "mean_max_temp", "mean_max_temp_flag", "mean_min_temp", "mean_min_temp_flag", "mean_temp", "mean_temp_flag", "extr_max_temp", "extr_max_temp_flag", "extr_min_temp", "extr_min_temp_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd_last_day", "snow_grnd_last_day_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag")

  # Omit preamble stuff for now
  preamble <- w[, c("prov", "station_name", "station_id", "lat", "lon", "elev", "climat_id", "WMO_id", "TC_id")]
  w <- w[, !(names(w) %in% names(preamble))]

  names(w) <- n

  if(timeframe == "hour") w <- dplyr::mutate(w, time = as.POSIXct(time), date = as.Date(time))
  if(timeframe != "hour") w <- dplyr::mutate(w, date = as.Date(date))

  ## Get correct timezone
  if("time" %in% names(w)){
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
                  value = replace(value, flag == "M", NA),  ## Missing
                  value = replace(value, flag == "L", NA),   ## Precipitation may or may not have occurred
                  qual = replace(qual, qual == "\u0086", "Only preliminary quality checking")) %>%
    tidyr::gather(type, value, flag, value) %>%
    dplyr::mutate(variable = replace(variable, type == "flag", paste0(variable[type == "flag"], "_flag")))   %>%
    dplyr::select(date, everything(), -type) %>%
    tidyr::spread(variable, value)

  ## Can we convert to numeric?
  #w$wind_spd[c(54, 89, 92)] <- c(">3", ">5", ">10")

  num <- apply(w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE)))], 2, FUN = function(x) tryCatch(as.numeric(x), warning = function(w) w))

  if(any(sapply(num, FUN = function(x) is(x, "warning")))) {
    message("Some variables have non-numeric values (", paste0(names(num)[sapply(num, FUN = function(x) is(x, "warning"))], collapse = ", "), ")")
    for(i in names(num)[sapply(num, FUN = function(x) is(x, "warning"))]) {
      problems <- w[grep("<|>|\\)|\\(", w[,i]), names(w) %in% c("date", "year", "month", "day", "hour", "time", i)]
      if(nrow(problems) > 20) rows <- 20 else rows <- nrow(problems)
      message(paste0(capture.output(problems[1:rows,]), collapse = "\n"), if (rows < nrow(problems)) "\n...")
    }
    if(!is.null(string_as)) {
      message("Replacing with ", string_as, ". Use 'string_as = NULL' to keep as characters (see ?weather).")
      suppressWarnings(w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE)))] <- apply(w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE)))], 2, as.numeric))
    } else {
      message("Leaving as characters (", paste0(names(num)[sapply(num, FUN = function(x) is(x, "warning"))], collapse = ", "), "). Cannot summarize these values.")
      w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE), names(num)[sapply(num, FUN = function(x) is(x, "warning"))]))] <- num[!sapply(num, FUN = function(x) is(x, "warning"))]
    }
  } else {
    w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE)))] <- num
  }

  w <- cbind(preamble[, c("prov", "station_name", "station_id", "lat", "lon")], w, preamble[, c("elev", "climat_id", "WMO_id", "TC_id")])



  return(w)
}

weather_avg <- function(w, timeframe = "hour", avg = "none") {
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
      message(paste0(capture.output(flags[1:rows,]), collapse = "\n"))
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
                           dplyr::summarize_each(dplyr::funs(n = length(.[!is.na(.)])), everything()),
                         timeframe = c("year", "month", "day"))

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



