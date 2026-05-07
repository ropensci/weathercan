#' Interpolate and add weather data to a dataframe
#'
#' When data and the weather measurements do not perfectly line up, perform a
#' linear interpolation between two weather measurements and merge the results
#' into the provided dataset. Only applies to numerical weather columns (see
#' \code{weather} for more details).
#'
#' \strong{Dealing with NA values} If there are NAs in the weather data,
#' \code{na_gap} can be used to specify a tolerance. For example, a tolerance of
#' 2 with an interval of "hour", means that a two hour gap in data can be
#' interpolated over (i.e. if you have data for 9AM and 11AM, but not 10AM, the
#' data between 9AM and 11AM will be interpolated. If, however, you have 9AM and
#' 12PM, but not 10AM or 11AM, no interpolation will happen and data between 9AM
#' and 12PM will be returned as NA.)
#'
#' @details @inheritSection weather_dl Verbosity
#'
#' @param data Dataframe. Data with dates or times to which weather data should
#'   be added.
#' @param weather Dataframe. Weather data downloaded with \code{\link{weather}}
#'   which should be interpolated and added to \code{data}.
#' @param cols Character. Vector containing the weather columns to add or 'all'
#'   for all relevant columns. Note that some measure are omitted because they
#'   cannot be linearly interpolated (e.g., wind direction).
#' @param interval What interval is the weather data recorded at? "hour" or
#'   "day".
#' @param na_gap How many hours or days (depending on the interval) is it
#'   acceptable to skip over when interpolating over NAs (see details).
#'
#' @examplesIf check_eccc()
#'
#' # Weather data only
#' kamloops
#'
#' # Data about finch observations at RFID feeders in Kamloops, BC
#' finches
#'
#' # Match weather to finches
#'
#' # First line up the timezones
#' # - Finches are in Pacific Time (inc. Daylight savings),
#' #   Kamloops is in Pacific Time *without* daylight savings, but is marked as UTC for
#' #   simplicity (see ?weather_dl for details)
#' # - First we convert finches to remove daylight savings, then we mark as UTC
#' finches <- dplyr::mutate(finches, time = lubridate::with_tz(time, "Etc/GMT+8"))
#' finches <- dplyr::mutate(finches, time = lubridate::force_tz(time, "UTC"))
#'
#' # Then interpolate over the first 30 observations
#' finch_weather <- weather_interp(data = finches[1:30,], weather = kamloops)
#'
#' @aliases add_weather
#'
#' @export

weather_interp <- function(
  data,
  weather,
  cols = "all",
  interval = "hour",
  na_gap = 2
) {
  ## Check for multiple stations
  if ("station_id" %in% names(weather)) {
    if (length(unique(weather$station_id)) > 1) {
      wc_stop("Can only interpolate weather from one station at a time")
    }
  }

  if (length(interval) > 1 || !(interval %in% c('hour', 'day'))) {
    wc_stop("'interval' must be either 'hour' OR 'day'")
  }

  ## Make sure data and weather properly matched
  msg <- c(
    "'data' and 'weather' must be data frames with columns 'time'",
    " in POSIXct format or 'date' in Date format."
  )
  if (!is.data.frame(data) || !is.data.frame(weather)) {
    wc_stop(msg)
  }
  if (
    (interval == "hour" &&
      !("time" %in% names(data) && "time" %in% names(weather))) ||
      (interval == "day" &
        !("date" %in% names(data) && "date" %in% names(weather)))
  ) {
    wc_stop(
      "'interval' must be either 'hour' or 'day' and must correspond to a ",
      "column 'time' or 'date' in both the 'data' and 'weather' dataframes."
    )
  }

  ## Convert to tibbles for consistency
  data <- dplyr::as_tibble(data)
  weather <- dplyr::as_tibble(weather)

  if (interval == "hour") {
    if (
      !lubridate::is.POSIXct(data[['time']]) ||
        !lubridate::is.POSIXct(weather[['time']])
    ) {
      wc_stop(msg)
    }
  }
  if (interval == "day") {
    if (
      !lubridate::is.Date(data[['date']]) ||
        !lubridate::is.Date(weather[['date']])
    ) {
      wc_stop(msg)
    }
  }

  ## Make sure 'cols' is do-able
  if (!any((cols %in% c("all", names(weather))))) {
    wc_stop(
      "'cols' should either be 'all', or should ",
      "match specific columns in 'weather'"
    )
  }

  ## If 'time', convert to same timezone
  if (interval == "hour") {
    if (lubridate::tz(data$time) != lubridate::tz(weather$time)) {
      wc_stop("`data` and `weather` timezones must match")
    }
  }

  ## Get proper units for 'na_gap'
  if (!is.numeric(na_gap)) {
    wc_stop("'na_gap' should be numeric.")
  }
  if (interval == "hour") {
    na_gap <- lubridate::hours(na_gap)
  }
  if (interval == "day") {
    na_gap <- lubridate::days(na_gap)
  }

  ## Get columns in 'cols'
  if (any(cols == "all")) {
    cols <- names(w_names[[interval]])
    cols <- cols[
      -grep(
        paste0(
          "(flag)|(qual)|(weather)|(time)|(date)|(hour)|",
          "(^day$)|(month)|(year)|(^wind_dir$)|",
          "(^dir_max_gust$)"
        ),
        cols
      )
    ]
  }

  ## Check that weather vars are numeric
  ## (is linear interpolation relevant for each?)
  omit <- cols[!(vapply(weather[, cols], is.numeric, FUN.VALUE = TRUE))]
  cols <- cols[!(cols %in% omit)]
  if (length(omit) > 0) {
    wc_inform(
      "Some columns ({paste0(omit, collapse = ', ')}) ",
      "are not numeric and will thus be omitted from the interpolation."
    )
  }

  ## Make sure there are still columns to work with
  if (length(cols) < 1) {
    wc_stop("No columns over which to interpolate.")
  }

  ## For each obs, get interpolated weather...
  for (col in cols) {
    if (interval == "hour") {
      t <- "time"
    } else if (interval == "day") {
      t <- "date"
    }
    w <- weather[!is.na(weather[[col]]), ]
    if (nrow(w) < 2) {
      wc_inform(
        "{col} does not have at least 2 points of non-missing data, ",
        "skipping..."
      )
    } else {
      if (nrow(w) < nrow(weather)) {
        wc_inform(
          "{col} is missing {nrow(weather) - nrow(w)} out of {nrow(weather)} ",
          "data, interpolation may be less accurate as a result."
        )
      }

      new <- approx_na_rm(
        x = weather[[t]],
        y = weather[[col]],
        xout = data[[t]],
        na_gap = na_gap
      ) |>
        dplyr::rename(!!!stats::setNames(c('x', 'y'), c(t, col)))

      data <- dplyr::left_join(data, unique(new), by = t)
    }
  }

  data
}

#' Linear interpolation with NA gap handling
#'
#' Performs linear interpolation while respecting gaps in the data. If NA values
#' are present in y and na_gap is specified, interpolation will not occur across
#' gaps larger than the specified tolerance.
#'
#' @param x Numeric, Date, or POSIXct. X values for interpolation
#' @param y Numeric. Y values to interpolate
#' @param xout Numeric, Date, or POSIXct. Points at which to interpolate (must
#'   match class of x)
#' @param na_gap Numeric or lubridate period. Maximum gap size to interpolate
#'   over when y has NA values
#'
#' @returns Data frame with columns x and y containing interpolated values
#'
#' @noRd
#' @examples
#' approx_na_rm(x = 1:10, y = 1:10, xout = c(0.5, 4.5))
#' # approx_na_rm(x = 1:10, y = c(1:5, NA, NA, NA, 9, 10), xout = c(0.5, 6.5))
#' approx_na_rm(x = 1:10, y = c(1:5, NA, NA, NA, 9, 10), xout = c(0.5, 6.5), na_gap = 2)
#' approx_na_rm(x = 1:10, y = c(1:5, NA, NA, NA, 9, 10), xout = c(0.5, 6.5), na_gap = 4)

approx_na_rm <- function(x, y, xout, na_gap = NULL) {
  if (!all(class(x) == class(xout)) && !(is.numeric(xout) && is.numeric(x))) {
    wc_stop("'xout' must be the same class as 'x'")
  }

  if (
    lubridate::is.POSIXct(x) &&
      lubridate::is.POSIXct(xout) &&
      lubridate::tz(x) != lubridate::tz(xout)
  ) {
    wc_stop("Timezone of `x` doesn't match `xout`")
  }

  new <- as.data.frame(
    stats::approx(x = x, y = y, xout = xout, yleft = NA, yright = NA)
  )

  if (anyNA(y) && !is.null(na_gap)) {
    if (lubridate::is.Date(x) || lubridate::is.POSIXct(x)) {
      if (!lubridate::is.period(na_gap)) {
        wc_stop(
          "With date/time data in x, `na_gap` must be a lubridate ",
          "period object"
        )
      }

      x <- x[!is.na(y)]

      diff_x <- difftime(dplyr::lead(x), x, units = "hours")
      diff_x <- lubridate::hours(diff_x)
      diff_x <- diff_x[!is.na(diff_x)]

      which_x <- x[c(diff_x > na_gap, FALSE)]
      missing <- lubridate::interval(
        which_x + 1,
        which_x + diff_x[diff_x > na_gap] - 1
      )

      ## Remove missing values from interpolated ones
      missing <- vapply(
        new$x,
        FUN.VALUE = TRUE,
        FUN = function(x, missing) {
          any(lubridate::`%within%`(x, missing))
        },
        missing = missing
      )
      new$y[missing] <- NA
    } else if (is.numeric(x)) {
      if (lubridate::is.period(na_gap) || !is.numeric(na_gap)) {
        wc_stop("With numeric x, `na_gap` must also be numeric")
      }

      x <- x[!is.na(y)]

      diff_x <- diff(x)
      which_x <- x[c(diff_x > na_gap, FALSE)]
      missing <- data.frame(
        from = which_x,
        to = which_x + diff_x[diff_x > na_gap]
      )

      ## Remove missing values from interpolated ones
      missing <- vapply(
        new$x,
        FUN.VALUE = TRUE,
        FUN = function(x, missing) {
          any(x > missing$from & x < missing$to)
        },
        missing = missing
      )
      new$y[missing] <- NA
    }
  } else if (anyNA(y) && is.null(na_gap)) {
    wc_stop("Missing values in y but no `na_gap` set")
  }

  new
}
