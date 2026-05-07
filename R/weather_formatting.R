#' Arrange columns
#'
#' Arrange by metadata (m_names) then by variables (w_names). Use any_of to
#' catch all present, but not to error if missing. Used by [weather_dl()].
#'
#' @param w Weather data frame / tibble
#'
#' @returns Arranged tibble
#'
#' @noRd
weather_arrange <- function(w) {
  vars <- purrr::map(w_names, names) |>
    unlist(use.names = FALSE) |>
    unique()

  dplyr::relocate(w, dplyr::any_of(c(names(m_names), "date", vars)))
}


#' Trims weather data NAs
#'
#' Trims all NA data before and after a data range. If trim_by_stn == FALSE,
#' then trims by the entire data range. If trim_by_stn == TRUE, then trims
#' each stations data range individually.
#'
#' @param w Weather data frame
#' @param format Logical. Whether or not formatting is performed (trim only
#'   applies if formatted)
#' @param trim Logical. Whether or not to perform the trim.
#' @param trim_by_stn Logical. Whether or not to trim by station or by all
#'   combined data.
#'
#' @returns Trimmed data frame or original if format or trim are FALSE
#'
#' @noRd

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

#' Format the weather data
#'
#' Format weather data, fixing column names, dates, times and timezones, quality
#' symbols and column types.
#'
#' @param w Weather data frame
#' @param station_id Station id to format
#' @param tz Timezone of the station
#' @param interval "hour", "day", "month"
#' @param start Requested start date (used for filtering)
#' @param end Requested end date (used for filtering)
#' @param months Numeric months to include (used for filtering)
#' @param string_as Character. If there are character strings in numeric columns
#'   (e.g., `>31` in wind speed), they are replaced with this (defaults to `NA`)
#'   and the user is alerted.
#' @param time_disp Character. Either "none" (default) or "UTC". How the time
#'   should be displayed.
#'
#' @returns Formatted weather data frame.
#'
#' @noRd

weather_format <- function(
  w,
  station_id,
  tz,
  interval = "hour",
  start,
  end,
  months,
  string_as = "NA",
  time_disp = NULL
) {
  w <- dplyr::select(
    w,
    -dplyr::any_of(c("Station Name", "Climate ID")),
    -dplyr::contains("Latitude"),
    -dplyr::contains("Longitude")
  ) |>
    dplyr::rename(dplyr::any_of(w_names[[interval]]))

  # Format dates and times (for 'hour')
  if (interval %in% c("day", "month")) {
    w <- dplyr::mutate(w, date = lubridate::ymd(.data$date, truncated = 2))
  } else if (interval == "hour") {
    ## Get correct timezone
    w <- dplyr::mutate(w, time = as.POSIXct(.data$time, tz = "UTC"))
    if (time_disp == "UTC") {
      w <- dplyr::mutate(w, time = .data$time + lubridate::hours(tz_hours(tz)))
    }
    w <- dplyr::mutate(w, date = lubridate::as_date(.data$time)) |>
      dplyr::relocate("date")
  }

  non_vars <- var_names(names(w), variable = FALSE)
  vars <- var_names(names(w))

  ## Replace values with "M" flags and "" values with NA
  for (v in vars) {
    w[[v]][w[[paste0(v, "_flag")]] == "M"] <- NA_character_ # If flag == "M"
    w[[v]][w[[v]] == ""] <- NA_character_ # If value == ""
  }

  # Replace quality symbols
  if ("qual" %in% names(w)) {
    fix <- c(
      "\\u2020" = "Only preliminary quality checking",
      "\\u2021" = "Partner data that is not subject to review by the National Climate Archives"
    )

    w <- dplyr::mutate(
      w,
      qual = stringi::stri_escape_unicode(.data$qual), # Convert to ascii
      qual = stringr::str_replace_all(.data$qual, fix)
    )
  }

  # Fix/flag numeric conversions
  num <- purrr::imap_lgl(w[vars], \(x, i) {
    tryCatch(is.numeric(as.numeric(x)), warning = function(w) FALSE)
  })
  not_num <- names(num)[!num]
  is_num <- names(num[num])

  # Convert each possible type
  # - Flags are all character
  # - Month, Day are integers, Qual is character
  types <- rlang::set_names(rep("c", length(vars)), paste0(vars, "_flag"))
  types <- readr::cols("month" = "i", "day" = "i", "qual" = "c", !!!types)
  w <- readr::type_convert(w, col_types = types)

  # Capture problems for messages
  non_num_deets <- dplyr::tibble(
    station_id = .env$station_id,
    col = not_num
  ) |>
    dplyr::mutate(
      problems = purrr::map(.data$col, \(v) {
        dplyr::filter(w, stringr::str_detect(.data[[v]], "<|>|\\)|\\(")) |>
          dplyr::select(dplyr::any_of(c("date", "time", v))) |>
          dplyr::slice(1:20)
      })
    )

  # Fix problems?
  if (!is.null(string_as)) {
    # Force numeric - Replace characters like "<1" with NA
    non_num_deets$replace <- string_as

    suppressWarnings(
      w <- dplyr::mutate(w, dplyr::across(dplyr::any_of(vars), as.numeric))
    )
  } else {
    # Do not force
    non_num_deets$replace <- "no_replace"
  }

  ## Trim to match date range and months
  w <- dplyr::filter(w, .data$date >= .env$start & .data$date <= .env$end)
  if (!is.null(months)) {
    w <- dplyr::filter(w, lubridate::month(.data$date) %in% .env$months)
  }

  list(data = w, msg = non_num_deets)
}

#' Convert to list cols
#'
#' @param w Weather data frame
#' @param interval "hour", "day", "month"
#' @param list_col Logical. Whether to make into list cols
#' @param format Logical. Whether formatting was applied (cannot use list_col if
#'   not formatted).
#'
#' @returns Weather data collapsed into list cols.
#'
#' @noRd

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
