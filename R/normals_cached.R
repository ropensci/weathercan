#' Access and filter cached normals data
#'
#' For normals which are cached locally filter, format and return.
#'
#' @param climate_ids Character Vector. Climate ids to search for in the
#' metadata.
#' @param normals_years Character. Normals years to return. Currently only
#' "1991-2020" is possible.
#'
#' @returns Data frame of normals for that year range.
#'
#' @noRd
#' @examples
#' normals_cached(climate_ids = "5010480")
#' normals_cached(climate_ids = c("5010480", "5023222"))

normals_cached <- function(climate_ids, normals_years = "1991-2020") {
  normals_cached_check(normals_years)

  locs <- normals_cached_location(climate_ids, normals_years)
  if (!length(locs)) {
    stop(
      "No climate normals for ",
      normals_years,
      " for climate IDs: ",
      paste0(climate_ids, collapse = ", "),
      call. = FALSE
    )
  }
  n <- normals_cached_fmt(locs, normals_years)

  if (nrow(n) == 0) {
    stop(
      "Climate IDs present in station inventory (metadata) but not in data for ",
      normals_years,
      " for climate IDs: ",
      paste0(climate_ids, collapse = ", "),
      call. = FALSE
    )
  }
  n
}

#' Check if normals are cached locally
#'
#' @param normals_years Character. Normals years to check Currently only
#' "1991-2020" is possible.
#'
#' @returns TRUE if exists or downloaded. Errors otherwise
#'
#' @noRd
#' @examples
#' normals_cached_check()

normals_cached_check <- function(normals_years = "1991-2020") {
  if (
    !file.exists(normals_file(normals_years)) ||
      !file.exists(normals_file(normals_years))
  ) {
    if (interactive()) {
      dl <- utils::askYesNo(paste0(
        "Cannot find cached normals for ",
        normals_years,
        "\nDownload?"
      ))
    } else {
      dl <- TRUE
    }

    if (dl) {
      normals_cached_dl(normals_years)
    } else {
      stop(
        "Must download and cache full normals data for this year range",
        call. = FALSE
      )
    }
  }

  TRUE
}

#' Download normals to local cache
#'
#' @param normals_years Character. Normals years to return. Currently only
#' "1991-2020" is possible.
#'
#' @returns nothing
#'
#' @noRd
#' @examplesIf interactive()
#' normals_cached_dl()

normals_cached_dl <- function(normals_years = "1991-2020") {
  cache_check()

  f <- file.path(cache_dir(), "normals_temp.zip")

  wc_inform("Downloading {normals_years} Canadian Climate Normals...")
  httr2::request(getOption(paste0(
    "weathercan.urls.normals_",
    stringr::str_replace(normals_years, "-", "_")
  ))) |>
    httr2::req_progress() |>
    httr2::req_perform(path = f)

  wc_inform("Unzipping...")
  utils::unzip(f, exdir = cache_dir(), overwrite = TRUE, junkpaths = TRUE)

  if (file.exists(normals_file())) {
    wc_inform("Climate normals for {normals_years} successfully downloaded")
  } else {
    wc_inform("Climate normals were *not* succesfully downloaded and unzipped")
  }

  # Cleanup
  unlink(f)
}

#' Get locations for climate ids
#'
#' Return the station composite locations for a given set of climate ids and
#' a given set of normals.
#'
#' @param climate_ids Character vector. Climate ids to find locations for.
#' @param normals_years Character. Normals years to return. Currently only
#' "1991-2020" is possible.
#'
#' @returns Character vector of Composite locations including these climate ids.
#'
#' @noRd
#' @examples
#' normals_cached_location(c("502S001", "5023227", "5023222"))
#' normals_cached_location(c("5010480", "5023222"))

normals_cached_location <- function(climate_ids, normals_years = "1991-2020") {
  locs <- readr::read_csv(
    normals_file(normals_years, "meta"),
    show_col_types = FALSE,
    progress = FALSE
  ) |>
    dplyr::rename_with(tolower) |>
    dplyr::filter(.data$climate_id %in% .env$climate_ids) |>
    dplyr::pull(.data$composite_station_name) |>
    unique()

  wc_inform("Using composite locations: {paste0(locs, collapse = ', ')}")

  locs
}

normals_cached_fmt <- function(locs, normals_years = "1991-2020") {
  # Standardize some names to match weathercan general standards
  nms <- m_names |>
    tolower() |>
    stringr::str_replace_all(" ", "_")

  # Get meta data to add in composite stations
  meta <- readr::read_csv(
    normals_file(normals_years, "meta"),
    show_col_types = FALSE,
    progress = FALSE
  ) |>
    dplyr::rename_with(tolower) |>
    dplyr::rename("location_name" = "composite_station_name") |>
    dplyr::filter(.data$location_name %in% .env$locs) |>
    dplyr::rename(dplyr::any_of(c(!!!nms))) |>
    dplyr::mutate(prov = stringr::str_replace_all(.data$prov, .env$province)) |>
    dplyr::summarize(
      composite_stations = paste0(
        paste0(.data$station_name, " (", .data$climate_id, ")"),
        collapse = "; "
      ),
      .by = c("location_name", "prov")
    )

  # Get normals data and prepare for lengthening
  n <- readr::read_csv(
    normals_file(normals_years),
    show_col_types = FALSE,
    progress = FALSE
  ) |>
    dplyr::filter(.data$LOCATION_NAME %in% locs) |>
    tidyr::pivot_longer(
      cols = c(month.abb, "Year", "Code"),
      names_to = "period"
    ) |>
    dplyr::rename_with(tolower) |>
    dplyr::rename(dplyr::any_of(c(!!!nms))) |>
    dplyr::left_join(meta, by = c("location_name", "prov"))

  # Get order of normals elements to use as column order later
  col_order <- dplyr::mutate(
    n,
    normals_element = dplyr::if_else(
      .data$period == "Code",
      paste(.data$normals_element, "Code"),
      .data$normals_element
    )
  ) |>
    dplyr::pull(.data$normals_element) |>
    unique() |>
    pretty_names()

  # Extract Codes to separate columns paired with the element
  codes <- n |>
    dplyr::filter(.data$period == "Code") |>
    dplyr::mutate(normals_element = paste(.data$normals_element, "Code")) |>
    dplyr::select(
      "location_name",
      "period_of_record",
      "normals_element",
      "value"
    ) |>
    tidyr::pivot_wider(names_from = "normals_element")

  # Pivote normals elements wide
  #  - add codes
  #  - update formats
  #  - rearrange to match original element order.
  n1 <- n |>
    dplyr::filter(.data$period != "Code") |>
    tidyr::pivot_wider(names_from = "normals_element") |>
    dplyr::left_join(codes, by = c("location_name", "period_of_record")) |>
    dplyr::rename_with(pretty_names) |>
    readr::type_convert(col_types = readr::cols()) |>
    dplyr::relocate("composite_stations", .after = "prov") |>
    dplyr::relocate(dplyr::all_of(.env$col_order), .after = "period")

  n1
}

#' Location of the cached normals data
#'
#' Returns the *expected* file path of the location of cached normals data. Only the most
#' current normals data are provided as a full data download by ECCC, so only
#' these normals are cached locally. Note that if you haven't downloaded
#' the normals files yet (call `normals_dl(...)`) these files will not exist.
#'
#' @param normals_years Character. Years to load. Currently only `1991-2020` is available.
#' @param type Character. Data type to load, one of "normals", or "meta" (the
#'   composite station inventory).
#'
#' @returns Character file path.
#'
#' @export
#' @examples
#' normals_file()

normals_file <- function(normals_years = "1991-2020", type = "normals") {
  f <- dplyr::case_when(
    normals_years == "1991-2020" && type == "normals" ~
      "1991-2020_Canadian_Climate_Normals_CANADA_Data.csv",
    normals_years == "1991-2020" && type == "meta" ~
      "1991_2020_Canadian_Climate_Normals_CANADA_station_inventory.csv"
  )

  file.path(cache_dir(), f)
}
