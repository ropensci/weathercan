#' Access Station data downloaded from Environment and Climate Change Canada
#'
#' This function access the built-in stations data frame. You can update this
#' data frame with `stations_dl()` which will update the locally stored data.
#'
#' You can check when this was last updated with `stations_meta()`.
#'
#' @details
#'
#' A dataset containing station information downloaded from Environment and
#' Climate Change Canada. Note that a station may have several station IDs,
#' depending on how the data collection has changed over the years. Station
#' information can be updated by running `stations_dl()`.
#'
#' @format A data frame:
#' \describe{
#'   \item{prov}{Province}
#'   \item{station_name}{Station name}
#'   \item{station_id}{Environment Canada's station ID number. Required for
#'   downloading station data.}
#'   \item{climate_id}{Climate ID number}
#'   \item{WMO_id}{Climate ID number}
#'   \item{TC_id}{Climate ID number}
#'   \item{lat}{Latitude of station location in degree decimal format}
#'   \item{lon}{Longitude of station location in degree decimal format}
#'   \item{elev}{Elevation of station location in metres}
#'   \item{tz}{Local timezone excluding any Daylight Savings}
#'   \item{interval}{Interval of the data measurements ('hour', 'day', 'month')}
#'   \item{start}{Starting year of data record}
#'   \item{end}{Ending year of data record}
#'   \item{normals}{Whether *any* climate normals are available for that station (new behaivour)}
#'   \item{normals_1991_2020}{Whether 1991-2020 climate normals are available for that station. **Note** that even if available, these are not yet downloadable via weathercan.}
#'   \item{normals_1981_2010}{Whether 1981-2010 climate normals are available for that station}
#'   \item{normals_1971_2000}{Whether 1971-2000 climate normals are available for that station}
#' }
#' @source \url{https://climate.weather.gc.ca/index_e.html}
#'
#' @export
#'
#' @examplesIf check_eccc()
#' stations()
#' stations_meta()
#'
#' # Which Manitoba stations have *any* climate normals?
#' # Note `normals` is TRUE or FALSE, so we can included it as is for normals == TRUE
#'
#' library(dplyr)
#' filter(stations(), interval == "hour", normals, prov == "MB")

stations <- function() {
  if (!getOption("weathercan.normals.message")) {
    wc_inform(
      "As of v0.7.2, the `normals` column in `stations()` reflects whether or not ",
      "there\nare *any* normals available (not just the most recent)."
    )
    options("weathercan.normals.message" = TRUE)
  }

  stations_read()
}

#' Show stations list meta data
#'
#' Date of ECCC update and date downloaded via weathercan.
#'
#' @export
#'
#' @examplesIf check_eccc()
#' stations_meta()
stations_meta <- function() {
  wc_read(stations_meta_file())
}

stations_read <- function() {
  cache_stations_check()
  wc_read(stations_file()) |>
    dplyr::mutate(
      interval = factor(.data$interval, levels = c("hour", "day", "month"))
    ) |>
    dplyr::arrange(.data$prov, .data$station_id, .data$interval)
}

stations_file <- function() {
  file.path(cache_dir(), "stations.csv")
}

stations_meta_file <- function() {
  file.path(cache_dir(), "stations_meta.csv")
}

#' Get available stations
#'
#' This function can be used to download a Station Inventory CSV file from
#' Environment and Climate Change Canada. This is only necessary if the station
#' you're interested was only recently added. The 'stations' data set included
#' in this package contains station data downloaded when the package was last
#' compiled. This function may take a few minutes to run.
#'
#' @details
#'
#' The stations list is downloaded from the url stored in the option
#' `weathercan.urls.stations`. To change this location use
#' `options(weathercan.urls.stations = "your_new_url")`.
#'
#' The list of which stations have climate normals is downloaded from the url
#' stored in the option `weathercan.urls.stations.normals`. To change this
#' location use `options(weathercan.urls.normals = "your_new_url")`.
#'
#' Currently there are two sets of climate normals available: 1981-2010 and
#' 1971-2000. Whether a station has climate normals for a given year range is
#' specified in `normals_1981_2010` and `normals_1971_2000`, respectively.
#'
#' The column `normals` represents the most current year range of climate
#' normals (i.e. currently 1981-2010)
#'
#' @details @inheritSection weather_dl Verbosity
#'
#' @param skip Numeric. Number of lines to skip at the beginning of the csv. If
#'   NULL, automatically derived.
#'
#' @examplesIf check_eccc()
#'
#' # Update stations data frame
#' stations_dl()
#'
#' # Updated stations data frame is now automatically used
#' stations_search("Winnipeg")
#'
#' @export

stations_dl <- function(skip = NULL) {
  stations_dl_internal(
    skip = skip
  )
}

stations_dl_internal <- function(
  skip = NULL
) {
  cache_check()
  rlang::check_installed(c("lutz", "sf"), "to add timezones to stations ata.")

  # Get normals data
  normals <- stations_normals()

  wc_progress("Trying to access stations data frame")

  resp <- get_check(
    url = getOption("weathercan.urls.stations"),
    task = "access stations list"
  )

  headings <- readr::read_lines(
    I(httr2::resp_body_string(resp, encoding = "Latin1")),
    n_max = 5,
    progress = FALSE
  )
  if (!any(stringr::str_detect(headings, "Climate ID"))) {
    wc_stop(
      "Could not read stations list ({getOption('weathercan.urls.stations')})"
    )
  }

  if (is.null(skip)) {
    skip <- find_line(
      headings,
      cols = c(
        "Name",
        "Province",
        "Climate ID",
        "Station ID",
        "WMO ID",
        "TC ID"
      )
    ) -
      1
  }

  wc_inform(
    "According to Environment Canada, ",
    stringr::str_subset(headings, "Modified Date") |>
      stringr::str_remove_all("[^\001-\177]")
  )

  eccc_meta <- stringr::str_subset(headings, "Modified Date") |>
    stringr::str_remove(stringr::regex(
      "Modified Date:",
      ignore_case = TRUE
    )) |>
    lubridate::ymd_hms(truncated = 3)

  disclaimer <- paste0(
    grep("Disclaimer", headings, value = TRUE),
    collapse = "\n"
  )
  if (nchar(disclaimer) > 0) {
    wc_inform("Environment Canada Disclaimers:\n", disclaimer)
  }

  wc_progress("Downloading stations data frame")

  raw <- httr2::resp_body_string(resp, encoding = "Latin1")

  s <- readr::read_delim(
    I(raw),
    skip = skip,
    col_types = readr::cols(),
    progress = FALSE
  )
  s <- dplyr::select(
    s,
    "prov" = "Province",
    "station_name" = "Name",
    "station_id" = "Station ID",
    "climate_id" = "Climate ID",
    "hour_start" = dplyr::matches("HLY First"),
    "hour_end" = dplyr::matches("HLY Last"),
    "day_start" = dplyr::matches("DLY First"),
    "day_end" = dplyr::matches("DLY Last"),
    "month_start" = dplyr::matches("MLY First"),
    "month_end" = dplyr::matches("MLY Last"),
    "WMO_id" = "WMO ID",
    "TC_id" = "TC ID",
    #lat = Latitude,
    #lon = Longitude,
    "lat" = dplyr::matches("Latitude \\(Decimal"),
    "lon" = dplyr::matches("Longitude \\(Decimal"),
    "elev" = dplyr::starts_with("Elevation")
  )

  # Transform lat/lon to decimal degrees
  # s <- s |>
  #   dplyr::mutate(lat = sprintf("%.f", lat),
  #                 lon = sprintf("%.f", lon)) |>
  #   tidyr::separate(lat, into = c("lat_d", "lat_m", "lat_s", "lat_sd"),
  #                   sep = c(-7L, -5L, -3L), remove = FALSE, convert = TRUE) |>
  #   dplyr::mutate(lat = lat_d + lat_m/60 + (lat_s + lat_sd/1000)/3600) |>
  #   tidyr::separate(lon, into = c("lon_d", "lon_m", "lon_s", "lon_sd"),
  #                   sep = c(-7L, -5L, -3L), remove = FALSE, convert = TRUE) |>
  #   dplyr::mutate(lon = lon_d - lon_m/60 - (lon_s + lon_sd/1000)/3600) |>
  #   dplyr::select(-dplyr::matches("(lat|lon)_(d|m|s|sd)$"))

  # Calculate Timezones
  station_tz <- dplyr::select(s, "prov", "station_id", "lat", "lon") |>
    dplyr::distinct() |>
    dplyr::mutate(
      tz = lutz::tz_lookup_coords(.data$lat, .data$lon, method = "accurate"),
      tz = purrr::map_chr(.data$tz, tz_diff),
      tz = dplyr::if_else(
        is.na(.data$lat) | is.na(.data$lon),
        NA_character_,
        .data$tz
      )
    )

  s <- s |>
    dplyr::left_join(station_tz, by = c("station_id", "prov", "lat", "lon")) |>
    tidyr::pivot_longer(
      cols = dplyr::matches("(start)|(end)"),
      names_to = c("interval", "type"),
      names_sep = "_",
      values_to = "date"
    ) |>
    dplyr::mutate(
      type = factor(.data$type, levels = c("start", "end")),
      station_name = as.character(.data$station_name),
      lat = replace(.data$lat, .data$lat == 0, NA),
      lon = replace(.data$lon, .data$lon == 0, NA),
      date = replace(.data$date, date == "", NA),
      TC_id = replace(.data$TC_id, .data$TC_id == "", NA),

      # Catch old provincial references
      prov = replace(
        .data$prov,
        .data$prov == "NEWFOUNDLAND",
        "NEWFOUNDLAND AND LABRADOR"
      ),
      prov = replace(.data$prov, .data$prov == "YUKON TERRITORY", "YUKON"),
      prov = factor(
        .data$prov,
        levels = names(.env$province),
        labels = .env$province
      ),
      prov = as.character(.data$prov)
    ) |>
    tidyr::pivot_wider(names_from = "type", values_from = "date") |>
    dplyr::arrange(.data$prov, .data$station_id, .data$interval) |>
    dplyr::as_tibble()

  s <- s |>
    dplyr::left_join(normals, by = c("station_name", "climate_id")) |>
    dplyr::mutate(
      dplyr::across(dplyr::contains("normals"), \(x) {
        tidyr::replace_na(x, FALSE)
      }),
      normals = purrr::pmap_lgl(
        dplyr::pick(dplyr::starts_with("normals_")),
        any
      )
    ) |>
    dplyr::relocate(dplyr::contains("normals_"), .after = dplyr::last_col())

  meta <- data.frame(
    ECCC_modified = eccc_meta,
    weathercan_modified = Sys.Date()
  )

  wc_progress("Saving stations data to ", stations_file())
  wc_progress("Saving stations metadata to ", stations_meta_file())

  readr::write_csv(x = s, file = stations_file())
  readr::write_csv(x = meta, file = stations_meta_file())

  wc_inform(
    "Stations data saved...\n",
    "Use `stations()` to access most recent version and ",
    "`stations_meta()` to see when this was last updated"
  )
}

#' Search for stations by name or location
#'
#' Returns stations that match the name provided OR which are within \code{dist}
#' km of the location provided. This is designed to provide the user with
#' information with which to decide which station to then get weather data from.
#'
#' @param name Character. A vector of length 1 or more with text against which
#'   to match. Will match station names that contain all components of
#'   \code{name}, but they can be in different orders and separated by other
#'   text.
#' @param coords Numeric. A vector of length 2 with latitude and longitude of a
#'   place to match against. Overrides \code{lat} and \code{lon} if also
#'   provided.
#' @param dist Numeric. Match all stations within this many kilometres of the
#'   \code{coords}.
#' @param interval Character. Return only stations with data at these intervals.
#'   Must be any of "hour", "day", "month".
#' @param normals_only DEPRECATED. Logical. Return only stations with climate
#'   normals?
#' @param normals_years Character. One of `NULL` (default), `current`,
#'   `1991-2020`, `1981-2010`, or `1971-2000`. `current` returns only stations
#'   from the most recent *complete* normals year range (i.e. `1981-2010`).
#'   Default `NULL` does not filter by climate normals. Specific year ranges
#'   return stations with normals in that period. See Details for more
#'   specifics.
#' @param starts_latest Numeric. Restrict results to stations with data
#'   collection beginning in or before the specified year.
#' @param ends_earliest Numeric. Restrict results to stations with data
#'   collection ending in or after the specified year.
#' @param stn DEFUNCT. Now use `stations_dl()` to update internal data and
#'   `stations_meta()` to check the date it was last updated.
#'
#' @details To search by coordinates, users must make sure they have the
#'  [sp](https://cran.r-project.org/package=sp) package installed.
#'
#'  The `current`, most recent, climate normals year range is `1981-2010`.
#'
#' @return Returns a subset of the stations data frame which match the search
#'   parameters. If the search was by location, an extra column 'distance' shows
#'   the distance in kilometres from the location to the station. If no stations
#'   are found withing `dist`, the closest 10 stations are returned.
#'
#' @examplesIf check_eccc()
#'
#' stations_search(name = "Kamloops")
#' stations_search(name = "Kamloops", interval = "hour")
#'
#' stations_search(name = "Ottawa", starts_latest = 1950, ends_earliest = 2010)
#'
#' stations_search(name = "Ottawa", normals_years = "current")   # 1981-2010
#' stations_search(name = "Ottawa", normals_years = "1981-2010") # Same as above
#' stations_search(name = "Ottawa", normals_years = "1971-2000") # 1971-2010
#'
#' if(requireNamespace("sf")) {
#'   stations_search(coords = c(53.915495, -122.739379))
#' }
#'
#' @export

stations_search <- function(
  name = NULL,
  coords = NULL,
  dist = 10,
  interval = c("hour", "day", "month"),
  normals_years = NULL,
  normals_only = NULL,
  stn = NULL,
  starts_latest = NULL,
  ends_earliest = NULL
) {
  if (!is.null(normals_only)) {
    wc_warn(
      "`normals_only` is deprecated, switching to `normals_years = 'current'`"
    )
    normals_years <- "current"
  }
  if (
    !is.null(normals_years) &&
      !normals_years %in% c("current", "1991-2020", "1981-2010", "1971-2000")
  ) {
    wc_stop(
      "`normals_years` must either be `NULL` (don't filter by normals),",
      "'current', '1991-2020', '1981-2010' or '1971-2000'"
    )
  }

  if (
    all(is.null(name), is.null(coords)) ||
      all(!is.null(name), !is.null(coords))
  ) {
    wc_stop("Need a search name OR search coordinate")
  }

  if (!is.null(stn)) {
    wc_stop(
      "`stn` is defunct, to use an updated stations data frame ",
      "use `stations_dl()` to update the internal data, and ",
      "`stations_meta()` to check when it was last updated"
    )
  }
  stn <- stations()

  if (!is.null(coords)) {
    suppressWarnings({
      coords <- try(as.numeric(as.character(coords)), silent = TRUE)
    })
    if (
      length(coords) != 2 || all(is.na(coords)) || inherits(coords, "try-error")
    ) {
      wc_stop("'coord' takes one pair of lat and lon in a numeric vector")
    }

    if (!requireNamespace("sf", quietly = TRUE)) {
      wc_stop(
        "Package 'sf' required to search for stations using coordinates. ",
        "Use the code \"install.packages('sf')\" to install."
      )
    }
  }

  check_int(interval)
  stn <- dplyr::filter(
    stations(),
    .data$interval %in% !!interval,
    !is.na(.data$start)
  )

  normals_years <- check_normals(normals_years, null_ok = TRUE)
  if (!is.null(normals_years)) {
    yr <- paste0("normals_", stringr::str_replace(normals_years, "-", "_"))
    stn <- dplyr::filter(stn, .data[[yr]])
  }

  if (!is.null(starts_latest)) {
    suppressWarnings({
      starts_latest <- try(
        as.numeric(as.character(starts_latest)),
        silent = TRUE
      )
    })
    if (is.na(starts_latest) || inherits(starts_latest, "try-error")) {
      wc_stop("'starts_latest' needs to be a year (YYYY)")
    }
    stn <- dplyr::filter(stn, .data$start <= starts_latest)
  }

  if (!is.null(ends_earliest)) {
    suppressWarnings({
      ends_earliest <- try(
        as.numeric(as.character(ends_earliest)),
        silent = TRUE
      )
    })
    if (is.na(ends_earliest) || inherits(ends_earliest, "try-error")) {
      wc_stop("'ends_earliest' needs to be a year (YYYY)")
    }
    stn <- dplyr::filter(stn, .data$end >= ends_earliest)
  }

  if (!is.null(name)) {
    if (length(name) == 2 && is.numeric(name)) {
      wc_inform(
        "The `name` argument looks like a pair of coordinates. ",
        "Did you mean `coords = c({name[1]}, {name[2]})`?"
      )
    }

    wc_progress("Searching by name")

    if (inherits(try(as.character(name), silent = TRUE), "try-error")) {
      wc_stop("'name' needs to be coercible into a character")
    }

    name <- gsub("([A-Z]*)", "\\L\\1", name, perl = TRUE)
    temp <- gsub("([A-Z]*)", "\\L\\1", stn$station_name, perl = TRUE)

    i <- list()
    for (a in name) {
      i[[length(i) + 1]] <- grep(a, temp)
    }
    i <- Reduce(intersect, i)
  }

  if (!is.null(coords)) {
    wc_progress("Calculating station distances")

    coords <- sf::st_point(coords[c(2, 1)]) |>
      sf::st_sfc(crs = 4326)

    locs <- dplyr::select(stn, "station_id", "lon", "lat") |>
      tidyr::drop_na() |>
      dplyr::distinct() |>
      sf::st_as_sf(coords = c("lon", "lat"), crs = 4326) |>
      dplyr::mutate(
        distance = as.vector(sf::st_distance(coords, .data$geometry)) / 1000
      ) |>
      sf::st_drop_geometry()

    stn <- dplyr::left_join(stn, locs, by = "station_id") |>
      dplyr::arrange(.data$distance)

    i <- which(stn$distance <= dist)
    if (length(i) == 0) {
      i <- 1:10
      wc_inform("No stations within {dist}km. Returning closest 10 records")
    }
  }

  stn <- stn[i, ]

  if (!is.null(name)) {
    stn <- dplyr::arrange(
      stn,
      .data$station_name,
      .data$station_id,
      .data$interval
    )
  }
  if (!is.null(coords)) {
    stn <- dplyr::arrange(
      stn,
      .data$distance,
      .data$station_name,
      .data$station_id,
      .data$interval
    )
  }

  stn
}


normals_stn_list <- function(yr) {
  get_check(
    url = getOption("weathercan.urls.stations.normals"),
    query = list(yr = yr)
  ) |>
    httr2::resp_body_string() |>
    I() |>
    readr::read_csv(show_col_types = FALSE) |>
    dplyr::rename_with(tolower) |>
    dplyr::select(dplyr::any_of(c("station_name", "climate_id")))
}

stations_normals <- function() {
  dplyr::tibble(years = c("1991-2020", "1981-2010", "1971-2000")) |>
    dplyr::mutate(
      yr = stringr::str_extract(.data$years, "^[0-9]{4}"),
      stns = purrr::map(.data$yr, normals_stn_list)
    ) |>
    tidyr::unnest("stns") |>
    dplyr::select(-"yr") |>
    dplyr::mutate(
      normals = TRUE,
      years = stringr::str_replace(.data$years, "-", "_"),
      years = paste0("normals_", .data$years)
    ) |>
    tidyr::pivot_wider(names_from = "years", values_from = "normals")
}
