#' Interpolate and add weather data to a dataframe
#'
#' When data and the weather measurements do not perfectly line up, perform a
#' linear interpolation between two weather measurements and merge the results
#' into the provided dataset. Only applies to numerical weather columns (see
#' \code{weather} for more details).
#'
#' \strong{Dealing with NA values}
#' If there are NAs in the weather data, \code{na_gap} can be used to specify a tolerance. For example, a tolerance of 2 with an interval of "hour", means that a two hour gap in data can be interpolated over (i.e. if you have data for 9AM and 11AM, but not 10AM, the data between 9AM and 11AM will be interpolated. If, however, you have 9AM and 12PM, but not 10AM or 11AM, no interpolation will happen and data between 9AM and 12PM will be returned as NA.)
#'
#' @param data Dataframe. Data with dates or times to which weather data should
#'   be added.
#' @param weather Dataframe. Weather data downloaded with
#'   \code{\link{weather}} which should be interpolated and added to
#'   \code{data}.
#' @param cols Character. Vector containing the weather columns to add or 'all'
#'   for all relevant columns. Note that some measure are omitted because they
#'   cannot be linearly interpolated (e.g., wind direction).
#' @param interval What interval is the weather data recorded at? "hour" or
#'   "day".
#' @param na_gap How many hours or days (depending on the interval) is it
#'   acceptible to skip over when interpolating over NAs (see details).
#'
#' @examples
#'
#' # Weather data only
#' head(kamloops)
#'
#' # Data about finch observations at RFID feeders in Kamloops, BC
#' head(finches)
#'
#' # Match weather to finches
#' finch_weather <- add_weather(data = finches, weather = kamloops)
#'
#'
#' @export
add_weather <- function(data, weather,
                        cols = "all",
                        interval = "hour",
                        na_gap = 2) {

  ## Make sure data and weather properly matched
  msg <- c("'data' and 'weather' must be data frames with columns 'time' in POSIXct format",
           " or 'date' in Date format.")
  if(!is.data.frame(data)) stop(msg)
  if((interval == "hour" & !("time" %in% names(data) & "time" %in% names(weather))) |
     (interval == "day" & !("date" %in% names(data) & "date" %in% names(weather)))) {
    stop("'interval' must be either 'hour' or 'day' and must correspond to a ",
         "column 'time' or 'date' in both the 'data' and 'weather' dataframes.")
  }

  if(interval == "hour") if(!lubridate::is.POSIXct(data$time) | !lubridate::is.POSIXct(weather$time)) stop(msg)
  if(interval == "day") if(!lubridate::is.Date(data$date) | !lubridate::is.Date(weather$date)) stop(msg)

  ## Make sure 'cols' is do-able
  if(!any((cols %in% c("all", names(weather))))) stop("'cols' should either be 'all', or should ",
                                        "match specific columns in 'weather'")

  ## If 'time', convert to same timezone
  if(interval == "hour") {
    if(attr(data$time, "tzone") != attr(weather$time, "tzone")) {
      weather$time <- lubridate::with_tz(weather$time, attr(data$time, "tzone"))
    }
  }

  ## Get proper units for 'na_gap'
  if(!is.numeric(na_gap)) stop("'na_gap' should be numeric.")
  if(interval == "hour") na_gap <- lubridate::hours(na_gap)
  if(interval == "day") na_gap <- lubridate::days(na_gap)

  ## Get columns in 'cols'
  if(any(cols == "all")) {
    cols <- w_names[[interval]]
    cols <- cols[-grep("(flag)|(qual)|(weather)|(time)|(date)|(hour)|(^day$)|(month)|(year)|(^wind_dir$)|(^dir_max_gust$)", cols)]
  }

  ## Check that weather vars are numeric (is linear interpolation relevant for each?)
  if(length(cols) > 1) omit <- cols[!(sapply(weather[, cols], is.numeric))] else omit <- cols[!is.numeric(weather[, cols])]
  cols <- cols[!(cols %in% omit)]
  if(length(omit) > 0) message("Some columns (", paste0(omit, collapse = ", "), ") ",
                               "are not numeric and will thus be omitted from the ",
                               "interpolation.")

  ## Make sure there are still columns to work with
  if(length(cols) < 1) stop("No columns over which to interpolate.")

  ## For each obs, get interpolated weather...
  for(col in cols){
    if(interval == "hour") t <- "time" else if(interval == "day") t <- "date"
    w <- weather[!is.na(weather[, col]), ]
    if(nrow(w) < 2) {
      message(col, " does not have at least 2 points of non-missing data, skipping...")
    } else {
      if(nrow(w) < nrow(weather)) message(col, " is missing ", nrow(weather) - nrow(w), " ",
                                          "out of ", nrow(weather), " data, interpolation ",
                                          "may be less accurate as a result.")
      new <- approx_na_rm(x = weather[, t],
                          y = weather[, col],
                          xout = data[, t],
                          na_gap = na_gap) %>%
        dplyr::rename_(.dots = stats::setNames(c('x', 'y'), c(t, col)))

      data <- dplyr::left_join(data, unique(new), by = t)
    }
  }
  return(data)
}

#' @import lubridate
approx_na_rm <- function(x, y, xout, na_gap = NULL) {
  if(!all(class(x) == class(xout)) & !(is.numeric(xout) & is.numeric(x))) stop("'xout' must be the same class as 'x'")
  new <- as.data.frame(stats::approx(x = x, y = y, xout = xout))

  if(any(is.na(y))) {
    if(is.Date(x) | is.POSIXct(x)) {
      if(!is.period(na_gap)) stop("With date/time data in x, na_gap must be a lubridate period object")
      diff_x <- lubridate::hours(diff(x[!is.na(y)]))
      which_x <- x[!is.na(y)][c(diff_x > na_gap, FALSE)]
      missing <- interval(which_x + 1, which_x + diff_x[diff_x > na_gap] - 1)
      ## Remove missing values from interpolated ones
      new[sapply(new[, 1], FUN = function(x, missing) any(x %within% missing), missing = missing), 2] <- NA
    } else if (is.numeric(x)) {
      if(is.period(na_gap) || !is.numeric(na_gap)) stop("With numeric x, na_gap must also be numeric")
      diff_x <- diff(x[!is.na(y)])
      which_x <- x[!is.na(y)][c(diff_x > na_gap, FALSE)]
      missing <- data.frame(from = which_x, to = which_x + diff_x[diff_x > na_gap])
      new[sapply(new[, 1], FUN = function(x, missing) any(x > missing$from & x < missing$to), missing = missing), 2] <- NA
    }
  }
  return(new)
}
