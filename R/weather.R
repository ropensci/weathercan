weather_dl <- function(station_ID, date,
                            by = "hour",
                            url = "http://climate.weather.gc.ca/climate_data/bulk_data_e.html") {

  if(by == "hour") skip <- 16
  if(by == "day") skip <- 25
  if(by == "month") skip <- 19

  html <- httr::GET(url, query = list(format = 'csv',
                                      stationID = station_ID,
                                      timeframe = ifelse(by == "hour", 1, ifelse(by == "day", 2, 3)),
                                      Year = format(date, "%Y"),
                                      Month = format(date, "%m"),
                                      submit='Download+Data'))

  w <- read.csv(text = httr::content(html, as = "text", type = "text/csv", encoding = "ISO-8859-1"),
           strip.white = TRUE,
           colClasses = "character",
           skip = skip)
  return(w)
}

#' @import magrittr
weather_format <- function(w, by = "hour", string_as = "NA") {

  if(by == "hour") skip <- 17
  if(by == "day") skip <- 26
  if(by == "month") skip <- 19

  if(by == "hour") n <- c("time", "year", "month", "day", "hour", "qual", "temp", "temp_flag", "temp_dew", "temp_dew_flag", "rel_hum", "rel_hum_flag", "wind_dir", "wind_dir_flag", "wind_spd", "wind_spd_flag", "visib", "visib_flag", "pressure", "pressure_flag", "hmdx", "hmdx_flag", "wind_chill", "wind_chill_flag", "weather")
  if(by == "day") n <- c("date", "year", "month", "day", "qual", "max_temp", "max_temp_flag", "min_temp", "min_temp_flag", "mean_temp", "mean_temp_flag", "heat_deg_days", "heat_deg_days_flag", "cool_deg_days", "cool_deg_days_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd_last_day", "snow_grnd_last_day_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag")
  if(by == "month") n <- c("date", "year", "month", "mean_max_temp", "mean_max_temp_flag", "mean_min_temp", "mean_min_temp_flag", "mean_temp", "mean_temp_flag", "extr_max_temp", "extr_max_temp_flag", "extr_min_temp", "extr_min_temp_flag", "total_rain", "total_rain_flag", "total_snow", "total_snow_flag", "total_precip", "total_precip_flag", "snow_grnd_last_day", "snow_grnd_last_day_flag", "dir_max_gust", "dir_max_gust_flag","spd_max_gust", "spd_max_gust_flag")

  names(w) <- n

  if(by == "hour") w <- dplyr::mutate(w, time = as.POSIXct(time), date = as.Date(time))
  if(by != "hour") w <- dplyr::mutate(w, date = as.Date(date))

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
    dplyr::select(-type) %>%
    tidyr::spread(variable, value)

  ## Can we convert to numeric?
  #w$wind_spd[c(54, 89, 92)] <- c(">3", ">5", ">10")

  num <- apply(w[, !(names(w) %in% c("date", "year", "month", "day", "hour", "time", "qual", "weather", grep("flag", names(w), value = TRUE)))], 2, FUN = function(x) tryCatch(as.numeric(x), warning = function(w) w))

  if(any(sapply(num, FUN = function(x) is(x, "warning")))) {
    message("Some variables have non-numeric values (", paste0(names(num)[sapply(num, FUN = function(x) is(x, "warning"))], collapse = ", "), ")")
    for(i in names(num)[sapply(num, FUN = function(x) is(x, "warning"))]) {
      problems <- w[grep("<|>|\\)|\\(", w[,i]), names(w) %in% c("date", "year", "month", "day", "hour", "time", i)]
      if(nrow(problems) > 20) rows <- 20 else rows <- nrow(problems)
      message(paste0(capture.output(problems[1:rows,]), collapse = "\n"))
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

  ## Daylight savings

  return(w)
}

weather_avg <- function(w, by = "hour", avg = "none") {
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
                         by = c("year", "month", "day"))

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



#' Download Environment Canada Weather data
#'
#'
#' First check for interval and timeframe specified. Then if that doesn't match,
#' prioritorize according to the following: - Maximize the amount of time
#' covered by the interval: Download by smaller time frames to allow averaging
#' (override with '\code{best = FALSE}') - Move the start/end dates to the
#' min/max ranges available
#'
#' @param station_ID
#' @param start
#' @param end
#' @param by
#' @param avg
#' @param url
#'
#' @return
#' @export
#' @import lubridate
#' @import magrittr
#'
#' @examples
weather <- function(station_ID, start = NULL, end = NULL,
                    by = "hour",
                    avg = "none",
                    best = TRUE,
                    format = TRUE,
                    string_as = NA,
                    url = "http://climate.weather.gc.ca/climate_data/bulk_data_e.html") {

  ## AVERAGE CAN ONLY BE day, month, year
  ## AVERAGE Has to be larger timeframe than by

  if((!is.null(start) & class(try(as.Date(start), silent = TRUE)) == "try-error") |
     (!is.null(end) & class(try(as.Date(end), silent = TRUE)) == "try-error")) {
   stop("'start' and 'end' must be either a standard date format (YYYY-MM-DD) or NULL")
  }

  if(!is.null(start)) start <- as.Date(start)
  if(!is.null(end)) end <- as.Date(end)

  if(length(by) > 1) stop("'by' must be either 'hour', 'day', OR 'month'")
  if(!(by %in% c("hour", "day", "month"))) stop("'by' must be either 'hour', 'day', OR 'month'")

  stn <- stations %>%
    dplyr::filter_(lazyeval::interp("station_ID == x", x = station_ID)) %>%
    dplyr::arrange(timeframe) %>%
    tidyr::spread(type, date) %>%
    dplyr::mutate(int = interval(start, end),
                  timeframe = factor(timeframe, levels = c("hour", "day", "month"), ordered = TRUE))

  dates <- interval(start, end)

  ## If the selected time frame is not complely available change the parameters and warn
  if(!(dates %within% stn$int[stn$timeframe == by]) & best) {

    ## Compare number of days in each interval, pick the most days if smaller time frame
    stn$n_days <- int_length(intersect(dates, stn$int)) / 60 / 60 /24

    if(nrow(stn[stn$timeframe <= by & !is.na(stn$n_days),]) == 0) stop("Station doesn't have enough data to retrieve or calculate data at this interval")

    max_stn <- stn[stn$timeframe <= by & !is.na(stn$n_days) & stn$n_days == max(stn$n_days, na.rm = TRUE), ]

    if(nrow(max_stn) == 0 | any(max_stn$timeframe == by)) {
      # If there's nothing smaller or better
      by <- by
    } else {
      ## Get by a smaller time frame and average
      message("Station doesn't have enough data by the ", by, " for that interval. Downloading by ", max(max_stn$timeframe))
      #, ", averaging by ", by, ".")
      #avg <- by
      by <- max(max_stn$timeframe)
    }

    ## If dates overlap, but not nested, date range not available, change dates to match
    if(!(dates %within% stn$int[stn$timeframe == by])) {
      message("Station doesn't have data for the whole interval (", stn$n_days[stn$timeframe == by], "/", round(int_length(dates) / 60 / 60 /24, 2), " days).")

      if(start < stn$start[stn$timeframe == by]) {
        message("Moving start date to: ", stn$start[stn$timeframe == by])
        start <- as.Date(stn$start[stn$timeframe == by])
      }
      if(end > stn$end[stn$timeframe == by]) {
        message("Moving end date to: ", stn$end[stn$timeframe == by])
        end <- as.Date(stn$end[stn$timeframe == by])
      }
    }
  }


  date_range <- seq(floor_date(start, unit = "month"),
                    floor_date(end, unit = "month"),
                    by = ifelse(by == "hour", "month", "year"))

  html <- httr::GET(url, query = list(format = 'csv',
                                      stationID = station_ID,
                                      timeframe = ifelse(by == "hour", 1, ifelse(by == "day", 2, 3)),
                                      submit='Download+Data'))

  if(by == "hour") skip <- 9
  if(by == "day") skip <- 26
  if(by == "month") skip <- 19

  preamble <- read.csv(text = httr::content(html, as = "text", type = "text/csv", encoding = "ISO-8859-1"),
                       strip.white = TRUE,
                       colClasses = "character",
                       nrows = skip, header = FALSE)

  w <- data.frame()
  for(i in 1:length(date_range)){
    w <- rbind(w, weather_dl(station_ID = station_ID,
                                  date = date_range[i],
                                  by = by, url = url))
  }

  ## Format data if requested
  if(format) w <- weather_format(w = w, by = by, string_as = string_as)

  ## Add header info
  w <- w %>%
    dplyr::mutate(station_name = preamble$V2[preamble$V1 == "Station Name"],
                  station_ID = station_ID,
                  lat = as.numeric(preamble$V2[preamble$V1 == "Latitude"]),
                  lon = as.numeric(preamble$V2[preamble$V1 == "Longitude"]),
                  elevation = as.numeric(preamble$V2[preamble$V1 == "Elevation"]),
                  climat_ID = preamble$V2[preamble$V1 == "Climate Identifier"],
                  WMO_ID = preamble$V2[preamble$V1 == "WMO Identifier"],
                  TC_ID = preamble$V2[preamble$V1 == "TC Identifier"]
                  )
  ## Average if requested

  ## Trim to match date range
  w <- w[w$date >= start & w$date <= end, ]

  ## Arrange
  w <- dplyr::select(w, station_name, station_ID, everything())

  return(w)
}
