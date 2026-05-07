#' Display weather data availability messages
#'
#' Checks which stations are missing from the requested interval or date
#' range and displays messages about data availability. Checks if stations found
#' for a given interval, then if weather data downloaded for a given time range.
#'
#' @param station_ids Character/Numeric vector. Station IDs requested
#' @param stn Data frame. Stations data that was found
#' @param w Data frame. Weather data that was retrieved
#' @param interval Character. "hour", "day", or "month"
#' @param start Date. Start date of requested range
#' @param end Date. End date of requested range
#'
#' @returns Nothing, called for side effects (displays messages)
#'
#' @noRd

weather_msgs <- function(station_ids, stn, w, interval, start, end) {
  end <- end %||% "today"

  if (nrow(stn)) {
    stn_no_int <- setdiff(station_ids, unique(stn$station_id))
  } else {
    stn_no_int <- station_ids
  }
  if (nrow(w)) {
    stn_no_time <- setdiff(station_ids, c(unique(w$station_id), stn_no_int))
  } else {
    stn_no_time <- setdiff(station_ids, stn_no_int)
  }

  stn_prob <- c(stn_no_int, stn_no_time)
  if (length(stn_prob) > 0) {
    which <- if (all(station_ids %in% stn_prob)) "all" else "some"

    msg <- c(
      "*" = "{paste0(stn_no_int, collapse = ', ')} (none for interval {interval})",
      "*" = "{paste0(stn_no_time, collapse = ', ')} (none for date range {start} to {end})"
    )
    msg <- msg[as.logical(c(length(stn_no_int), length(stn_no_time)))]

    wc_msg_df(
      title = "Data unavailable for {which} stations",
      message = msg,
      df_title = "Available Station Data:",
      df = dplyr::filter(
        stations_read(),
        .data$station_id %in% .env$stn_prob,
        !is.na(.data$start)
      ) |>
        dplyr::select(
          "station_id",
          "station_name",
          "interval",
          "start",
          "end"
        ) |>
        data.frame()
    )
  }
}

#' Display weather formatting messages
#'
#' Displays messages about non-numeric values encountered during data formatting,
#' showing which columns and stations were affected.
#'
#' @param msg_fmt Data frame. Formatting message details
#'
#' @returns Nothing, called for side effects (displays messages)
#'
#' @noRd

weather_fmt_msgs <- function(msg_fmt) {
  if (nrow(msg_fmt) > 0) {
    cols <- paste0(unique(msg_fmt$col), collapse = ", ")

    if (all(is.na(msg_fmt$replace) | msg_fmt$replace != "no_replace")) {
      m <- c(
        "*" = "Replaced all non-numeric entries with {msg_fmt$replace[1]}.",
        "i" = "Use 'string_as = NULL' to keep as characters (see {.help [{.fun weather_dl}](weather_dl)})."
      )
    } else {
      m <- "Left all non-numeric entries as characters."
    }

    if (wc_noise(check = "noisy")) {
      cli::cli_h3("Formatting messages")

      cli::cli_alert_warning(
        paste0(
          "Some variables have non-numeric values ({cols}) for stations: ",
          paste0(unique(msg_fmt$station_id), collapse = ", "),
          collapse = ""
        )
      )
      cli::cli_bullets(m)

      show <- msg_fmt |>
        dplyr::select("station_id", "problems") |>
        tidyr::unnest("problems")

      wc_msg_df(df_title = "Examples:", df = show, when = "verbose")
    }
  }
}
