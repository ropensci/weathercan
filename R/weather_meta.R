#' Fetch and format metadata for a single station
#'
#' Downloads weather metadata for a station, parses it, and formats into a
#' standardized structure.
#'
#' @param station_id Character/Numeric. Station ID to download metadata for
#' @param end Date. Date to use for the metadata request
#' @param interval Character. "hour", "day", or "month"
#' @param encoding Character. Encoding to use when reading data
#'
#' @returns Tibble of formatted station metadata
#'
#' @noRd

meta_single <- function(station_id, end, interval, encoding) {
  meta_html(station_id = station_id, date = end, interval = interval) |>
    meta_raw(encoding = encoding, interval = interval) |>
    meta_format(station_id = station_id)
}

#' Fetch metadata HTML response
#'
#' Makes an API request to download station metadata for a specific date.
#'
#' @param station_id Character/Numeric. Station ID
#' @param date Date. Date to download metadata for
#' @param interval Character. "hour", "day", or "month"
#'
#' @returns httr2 response object
#'
#' @noRd

meta_html <- function(station_id, date, interval = "hour") {
  get_html(station_id, date, interval, format = "txt")
}

#' Parse raw metadata from HTML response
#'
#' Extracts and parses metadata or legend information from a text-formatted
#' HTML response, removing special symbols.
#'
#' @param html httr2 response object. Response from `meta_html()`
#' @param encoding Character. Encoding to use when reading data
#' @param interval Character. "hour", "day", or "month"
#' @param return Character. Either "meta" to return metadata or "legend" to
#'   return legend information
#'
#' @returns Tibble of parsed metadata or legend data
#'
#' @noRd

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

#' Format metadata into standardized structure
#'
#' Converts raw metadata into a standardized format with proper column names
#' and data types.
#'
#' @param meta Data frame. Raw metadata to format
#' @param station_id Character/Numeric. Station ID to include in output
#'
#' @returns Tibble of formatted metadata with station information
#'
#' @noRd

meta_format <- function(meta, station_id) {
  m <- paste0("(", paste0(m_names, collapse = ")|("), ")")

  meta <- meta |>
    dplyr::mutate(X1 = stringr::str_extract(.data$X1, pattern = m)) |>
    dplyr::filter(!is.na(.data$X1)) |>
    tidyr::pivot_wider(names_from = "X1", values_from = "X2")

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
