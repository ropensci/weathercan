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
#' @param stn DEFUNCT. Now use `stations_dl()` to update internal data and
#'   `stations_meta()` to check the date it was last updated.
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
    prep_paging()

  weather <- purrr::pmap(stn, \(...) {
    weather_combine(
      ...,
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

  # START HERE CHECK WHEN ONESTATION HAS DATA BUT NOT OTHER

  # - List missing stations
  # - format messages

  # for (s in station_ids) {
  #   ## Check if station missing that interval
  #   if (nrow(stn1) == 0) {
  #     missing <- c(missing, s)
  #     wc_progress("No data for station {s}")
  #     next
  #   }
  # }

  ## Format data if requested
  #     # Catch messages
  # if (nrow(w$msg) > 0) {
  #   msg_fmt <- dplyr::bind_rows(
  #     dplyr::bind_cols(station_id = s, w$msg),
  #     msg_fmt
  #   )
  # }

  # format stuff -----------------------------
  ## Check if all missing, remove and message
  # n <- c("time", "date", "year", "month", "day", "hour")
  # temp <- dplyr::select(w, -dplyr::any_of(n))

  # if (nrow(temp) == 0 || all(is.na(temp) | temp == "")) {
  #   if (length(station_ids) > 1) {
  #     wc_progress("No data for station {s}")
  #     missing <- c(missing, s)
  #     next
  #   } else {
  #     wc_msg_df(
  #       "There are no data for station {s} in this time range ",
  #       "({msg_start} to {msg_end}), for this interval ({interval})",
  #       df_title = "Available Station Data:",
  #       df = dplyr::filter(
  #         stn,
  #         .data$station_id %in% .env$s,
  #         !is.na(.data$start)
  #       )
  #     )
  #     return(dplyr::tibble())
  #   }
  # }
  #------------------------

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

weather_single <- function(station_id, date_range, interval, encoding) {
  w <- dplyr::tibble(date_range = date_range)
  w <- dplyr::mutate(
    w,
    html = purrr::map(
      .data$date_range,
      \(d) weather_html(station_id = station_id, date = d, interval = interval),
      .progress = wc_noise("noisy")
    ),
    data = purrr::map(
      .data$html,
      \(w) weather_raw(w, encoding = encoding, header = TRUE),
      .progress = wc_noise("noisy")
    ),
    n = purrr::map_int(.data$data, ncol)
  )

  w <- dplyr::filter(w, .data$n > 1) # Drop requests with no data
  w <- dplyr::select(w, "data")

  if (utils::packageVersion("tidyr") > "0.8.99") {
    w <- tidyr::unnest(w, "data")
  } else {
    w <- tidyr::unnest(w)
  }
  w
}


get_html <- function(
  station_id,
  date = NULL,
  interval = "hour",
  format = "csv"
) {
  q <- list(
    format = format,
    stationID = station_id,
    timeframe = ifelse(interval == "hour", 1, ifelse(interval == "day", 2, 3)),
    Year = format(date, "%Y"),
    Month = format(date, "%m"),
    Day = "01",
    submit = 'Download+Data'
  )

  get_check(
    url = getOption("weathercan.urls.weather"),
    query = q,
    task = "access historical weather data"
  )
}

weather_html <- function(station_id, date, interval = "hour") {
  get_html(station_id, date, interval, format = "csv")
}

meta_html <- function(station_id, date, interval = "hour") {
  get_html(station_id, date, interval, format = "txt")
}

remove_sym <- function(df) {
  dplyr::rename_with(df, \(x) {
    stringr::str_remove_all(x, "\\u00BB|\\u00BF|\\u00EF|\\u00C2|\\u00B0")
  })
}


weather_raw <- function(
  html,
  skip = 0,
  nrows = Inf,
  header = TRUE,
  encoding = "UTF-8"
) {
  raw <- httr2::resp_body_raw(html)

  # Look for and remove BOM
  if (
    raw[1] == as.raw(0xef) &&
      raw[2] == as.raw(0xbb) &&
      raw[3] == as.raw(0xbf)
  ) {
    raw <- raw[4:length(raw)]
  }

  # Get number of columns
  ncols <- readr::read_csv(
    I(raw),
    n_max = 1,
    col_names = FALSE,
    col_types = readr::cols(),
    progress = FALSE
  ) |>
    ncol()
  readr::local_edition(1)
  suppressWarnings({
    # when some data are missing, final columns not present
    w <- readr::read_csv(
      I(raw),
      n_max = nrows,
      skip = skip,
      col_types = paste(rep("c", ncols), collapse = ""),
      progress = FALSE
    )
  })
  # Get rid of special symbols right away
  w <- remove_sym(w)

  # For some reason the flags "^" are replaced with "I",
  # change back to match flags on ECCC website
  w <- dplyr::mutate(
    w,
    dplyr::across(dplyr::ends_with("Flag"), \(x) gsub("^I$", "^", x))
  )
  w
}


weather_trim <- function(w, format, trim, trim_by_stn) {
  if (!trim || !format || nrow(w) == 0) {
    return(w)
  }

  wc_progress("Trimming missing values before and after")

  if (trim_by_stn) {
    temp <- dplyr::group_split(w, .data$station_id)
  } else {
    temp <- list(w)
  }

  w <- purrr::map(temp, \(x) {
    trimable <- dplyr::select(
      x,
      -dplyr::any_of(c(
        names(m_names),
        "date",
        "time",
        "year",
        "month",
        "day",
        "hour",
        "qual"
      ))
    )

    keep <- x$date[which(
      rowSums(is.na(trimable) | trimable == "") != ncol(trimable)
    )]

    if (!length(keep)) {
      return(dplyr::tibble())
    }

    x <- x[x$date >= min(keep) & x$date <= max(keep), ]
  }) |>
    purrr::list_rbind()

  w
}

weather_format <- function(
  w,
  station_id,
  tz,
  interval = "hour",
  start,
  end,
  string_as = "NA",
  time_disp = NULL
) {
  w <- dplyr::select(
    w,
    -dplyr::any_of(c("Station Name", "Climate ID")),
    -dplyr::contains("Latitude"),
    -dplyr::contains("Longitude")
  )

  ## Get names from stored name list
  n <- w_names[[interval]]

  ## Trim to match names in data
  n <- n[n %in% names(w)]

  w <- dplyr::rename(w, !!n)

  if (interval == "day") {
    w <- dplyr::mutate(w, date = as.Date(.data$date))
  }
  if (interval == "month") {
    w <- dplyr::mutate(w, date = as.Date(paste0(.data$date, "-01")))
  }

  ## Get correct timezone
  if (interval == "hour") {
    w <- dplyr::mutate(w, time = as.POSIXct(.data$time, tz = "UTC"))
    if (time_disp == "UTC") {
      w <- dplyr::mutate(w, time = .data$time + lubridate::hours(tz_hours(tz)))
    }
    w <- dplyr::mutate(w, date = lubridate::as_date(.data$time))
  }

  ## Replace some flagged values with NA
  w <- w |>
    tidyr::gather(
      key = "variable",
      value = "value",
      names(w)[
        !(names(w) %in%
          c("date", "year", "month", "day", "hour", "time", "qual", "weather"))
      ]
    ) |>
    tidyr::separate(
      "variable",
      into = c("variable", "type"),
      sep = "_flag",
      fill = "right"
    ) |>
    dplyr::mutate(
      type = replace(.data$type, .data$type == "", "flag"),
      type = replace(.data$type, is.na(.data$type), "value")
    ) |>
    tidyr::spread("type", "value") |>
    dplyr::mutate(
      value = replace(.data$value, .data$value == "", NA), ## No data
      value = replace(.data$value, .data$flag == "M", NA)
    ) ## Missing

  if ("qual" %in% names(w)) {
    w <- dplyr::mutate(
      w,
      # Convert to ascii
      qual = stringi::stri_escape_unicode(.data$qual),
      qual = replace(
        .data$qual,
        .data$qual == "\\u2020",
        "Only preliminary quality checking"
      ),
      qual = replace(
        .data$qual,
        .data$qual == "\\u2021",
        paste0(
          "Partner data that is not subject",
          " to review by the National ",
          "Climate Archives"
        )
      )
    )
  }

  w <- w |>
    tidyr::gather(key = "type", value = "value", "flag", "value") |>
    dplyr::mutate(
      variable = replace(
        .data$variable,
        .data$type == "flag",
        paste0(.data$variable[.data$type == "flag"], "_flag")
      )
    ) |>
    dplyr::select("date", dplyr::everything(), -"type") |>
    tidyr::spread("variable", "value")

  ## Can we convert to numeric?
  #w$wind_spd[c(54, 89, 92)] <- c(">3", ">5", ">10")

  num <- apply(
    dplyr::select(
      w,
      -dplyr::any_of(c(
        "date",
        "year",
        "month",
        "day",
        "hour",
        "time",
        "qual",
        "weather",
        grep("flag", names(w), value = TRUE)
      ))
    ),
    MARGIN = 2,
    FUN = function(x) tryCatch(as.numeric(x), warning = function(w) w)
  )

  warn <- vapply(
    num,
    FUN = function(x) methods::is(x, "warning"),
    FUN.VALUE = TRUE
  )

  if (any(warn)) {
    m <- paste0(names(num)[warn], collapse = ", ")
    non_num <- dplyr::tibble(
      station_id = .env$station_id,
      col = names(num)[warn]
    )
    for (i in names(num)[warn]) {
      problems <- w[
        grep("<|>|\\)|\\(", w[[i]]),
        names(w) %in% c("date", "year", "month", "day", "hour", "time", i)
      ]
      if (nrow(problems) > 20) {
        rows <- 20
      } else {
        rows <- nrow(problems)
      }
      non_num$problems <- list(problems[1:rows, ])
    }
    if (!is.null(string_as)) {
      non_num$replace <- string_as
      suppressWarnings({
        valid_cols <- c(
          "date",
          "year",
          "month",
          "day",
          "hour",
          "time",
          "qual",
          "weather",
          grep("flag", names(w), value = TRUE)
        )

        replacement <- apply(
          dplyr::select(w, -dplyr::any_of(valid_cols)),
          MARGIN = 2,
          FUN = as.numeric
        )

        w[!(names(w) %in% valid_cols)] <- as.data.frame(replacement)
      })
    } else {
      m <- paste0(names(num)[warn], collapse = ", ")

      non_num <- dplyr::mutate(non_num, replace = "no_replace")

      replace <- c(
        "date",
        "year",
        "month",
        "day",
        "hour",
        "time",
        "qual",
        "weather",
        grep("flag", names(w), value = TRUE),
        names(num)[warn]
      )

      w[!(names(w) %in% replace)] <- as.data.frame(num[!warn])
    }
  } else {
    non_num <- data.frame()
    w[
      !(names(w) %in%
        c(
          "date",
          "year",
          "month",
          "day",
          "hour",
          "time",
          "qual",
          "weather",
          grep("flag", names(w), value = TRUE)
        ))
    ] <- as.data.frame(num)
  }

  ## Trim to match date range
  w <- dplyr::filter(w, .data$date >= start & .data$date <= end)

  list(data = w, msg = non_num)
}

weather_list_cols <- function(w, interval, list_col, format) {
  if (!list_col || !format) {
    return(w)
  }

  int_col <- dplyr::case_when(
    interval == "hour" ~ "date",
    interval == "day" ~ "month",
    interval == "month" ~ "year"
  )

  tidyr::nest(w, data = -dplyr::any_of(c(names(m_names), int_col)))
}

meta_raw <- function(html, encoding = "UTF-8", interval, return = "meta") {
  split <- httr2::resp_body_string(html, encoding = encoding) |>
    stringr::str_split("\n", simplify = TRUE) |>
    stringr::str_subset("^\r$", negate = TRUE)

  if (return == "meta") {
    i <- stringr::str_which(split, "If Local Standard Time|Legend")[1] - 1

    r <- httr2::resp_body_string(
      html,
      encoding = encoding
    ) |>
      stringr::str_replace_all("(\\t)+", "\\\t") |>
      I() |>
      readr::read_tsv(
        n_max = i,
        col_names = FALSE,
        col_types = readr::cols(),
        progress = FALSE
      )

    if (ncol(r) > 2) {
      wc_stop(
        "Problems parsing metadata. Submit an issue at ",
        "https://github.com/ropensci/weathercan/issues"
      )
    }
  } else if (return == "legend") {
    r <- httr2::resp_body_string(html, encoding = encoding) |>
      stringr::str_replace_all("(\\t)+", "\\\t") |>
      stringr::str_remove(
        "\\*https\\:\\/\\/climate.weather.gc.ca\\/FAQ_e.html#Q5"
      ) |>
      I() |>
      readr::read_tsv(
        skip = stringr::str_which(split, "Legend") + 1,
        col_names = FALSE,
        col_types = readr::cols(),
        progress = FALSE
      )
  }
  # Get rid of any special symbols
  remove_sym(r)
}

meta_format <- function(meta, station_id) {
  m <- paste0("(", paste0(m_names, collapse = ")|("), ")")

  meta <- meta |>
    dplyr::mutate(X1 = stringr::str_extract(.data$X1, pattern = m)) |>
    dplyr::filter(!is.na(.data$X1)) |>
    tidyr::spread("X1", "X2")

  m <- m_names[m_names %in% names(meta)]

  meta |>
    dplyr::select(dplyr::all_of(m)) |>
    dplyr::mutate(
      station_id = station_id,
      prov = province[[.data$prov]],
      lat = as.numeric(as.character(.data$lat)),
      lon = as.numeric(as.character(.data$lon)),
      elev = as.numeric(as.character(.data$elev))
    )
}

meta_single <- function(station_id, end, interval, encoding) {
  meta_html(station_id = station_id, date = end, interval = interval) |>
    meta_raw(encoding = encoding, interval = interval) |>
    meta_format(station_id = station_id)
}
