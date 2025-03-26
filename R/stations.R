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
#'
#' library(dplyr)
#' filter(stations(), interval == "hour", normals == TRUE, prov == "MB")

stations <- function() {

  if(abs(difftime(stations_meta()$weathercan_modified,
                  Sys.Date(), units = "days")) > 28) {
    if(!identical(Sys.getenv("TESTTHAT"), "true")) {
      message("The stations data frame hasn't been updated in over 4 weeks. ",
              "Consider running `stations_dl()` to check for updates and make ",
              "sure you have the most recent stations list available")
    }
  }

  stations_read()$stn
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
  stations_read()$meta
}

stations_read <- function() {
  pkg_file <- system.file("extdata", "stations.rds", package = "weathercan") %>%
    readr::read_rds()

  if (file.exists(stations_file())) {
    local_file <- stations_file() %>%
      readr::read_rds()
    # If pkg version is newer than local, use pkg else use local
    if(pkg_file$meta$weathercan_modified > local_file$meta$weathercan_modified) {
      r <- pkg_file
    } else {
      r <- local_file
    }
  } else r <- pkg_file
  r
}

stations_file <- function() {
  file.path(rappdirs::user_data_dir("weathercan"), "stations.rds")
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
#' @param skip Numeric. Number of lines to skip at the beginning of the csv. If
#'   NULL, automatically derived.
#' @param verbose Logical. Include progress messages
#' @param quiet Logical. Suppress all messages (including messages regarding
#'   missing data, etc.)
#'
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

stations_dl <- function(skip = NULL, verbose = FALSE, quiet = FALSE) {
  stations_dl_internal(skip = skip, verbose = verbose, quiet = quiet,
                       internal = FALSE)
}

stations_dl_internal <- function(skip = NULL, verbose = FALSE, quiet = FALSE,
                                 internal = TRUE) {


  if(getRversion() <= "3.3.3") {
    message("Need R version 3.3.4 or greater to update the stations data")
    return()
  }

  # If called internally use inst
  if(internal) {
    d <- system.file("extdata", package = "weathercan")
    f <- file.path(d, "stations.rds")
  } else {
    d <- dirname(stations_file())
    f <- stations_file()
  }

  # Ask for permission to save data
  if(!internal) {
    if((!dir.exists(d) || !file.exists(f)) && interactive()) {
      cont <- utils::askYesNo(
        paste0("weathercan would like to store the updated stations ",
               "data to: \n", f, "\nIs that okay?"))
    } else cont <- TRUE

    if(!cont) {
      message("Not updating stations data")
      return(invisible())
    }

    if(!dir.exists(d)) dir.create(d, recursive = TRUE)
  }

  if(!requireNamespace("lutz", quietly = TRUE) |
     !requireNamespace("sf", quietly = TRUE)) {
    stop("Package 'lutz' and its dependency, 'sf', are required to get ",
         "timezones for the updated stations dataframe. ",
         "Use the code \"install.packages(c('lutz', 'sf'))\" to install.",
         call. = FALSE)
  }

  # Get normals data
  normals <- stations_normals()

  if(verbose) message("Trying to access stations data frame")

  resp <- get_check(getOption("weathercan.urls.stations"),
                    task = "access stations list")

  headings <- readr::read_lines(httr::content(resp, as = "text",
                                              encoding = "Latin1"),
                                n_max = 5, progress = FALSE)
  if(!any(stringr::str_detect(headings, "Climate ID"))){
    stop("Could not read stations list (",
         getOption("weathercan.urls.stations"), ")", call. = FALSE)
  }

  if(is.null(skip)) {
    skip <- find_line(headings, cols = c("Name", "Province", "Climate ID",
                                         "Station ID", "WMO ID", "TC ID")) - 1
  }

  if(!quiet) message("According to Environment Canada, ",
                     stringr::str_subset(headings, "Modified Date") %>%
                       stringr::str_remove_all("[^\001-\177]"))

  eccc_meta <- stringr::str_subset(headings, "Modified Date") %>%
    stringr::str_remove(stringr::regex("Modified Date:", ignore_case = TRUE)) %>%
    lubridate::ymd_hms(truncated = 3)

  if(!quiet) {
    disclaimer <- paste0(grep("Disclaimer", headings, value = TRUE),
                         collapse = "\n")
    if(nchar(disclaimer) > 0) message("Environment Canada Disclaimers:\n",
                                      disclaimer)
  }

  if(verbose) message("Downloading stations data frame")

  raw <- httr::content(resp, as = "text", encoding = "Latin1")

  s <- readr::read_delim(raw, skip = skip, col_types = readr::cols(),
                         progress = FALSE)
  s <- dplyr::select(s,
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
  # s <- s %>%
  #   dplyr::mutate(lat = sprintf("%.f", lat),
  #                 lon = sprintf("%.f", lon)) %>%
  #   tidyr::separate(lat, into = c("lat_d", "lat_m", "lat_s", "lat_sd"),
  #                   sep = c(-7L, -5L, -3L), remove = FALSE, convert = TRUE) %>%
  #   dplyr::mutate(lat = lat_d + lat_m/60 + (lat_s + lat_sd/1000)/3600) %>%
  #   tidyr::separate(lon, into = c("lon_d", "lon_m", "lon_s", "lon_sd"),
  #                   sep = c(-7L, -5L, -3L), remove = FALSE, convert = TRUE) %>%
  #   dplyr::mutate(lon = lon_d - lon_m/60 - (lon_s + lon_sd/1000)/3600) %>%
  #   dplyr::select(-dplyr::matches("(lat|lon)_(d|m|s|sd)$"))



  # Calculate Timezones
  station_tz <- dplyr::select(s, "prov", "station_id", "lat", "lon") %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      tz = lutz::tz_lookup_coords(.data$lat, .data$lon, method = "accurate"),
      tz = purrr::map_chr(.data$tz, ~tz_diff(.x)),
      tz = dplyr::if_else(is.na(.data$lat) | is.na(.data$lon), NA_character_, .data$tz))

  s <- s %>%
    dplyr::left_join(station_tz, by = c("station_id", "prov", "lat", "lon")) %>%
    tidyr::gather(key = "interval", value = "date", dplyr::matches("(start)|(end)")) %>%
    tidyr::separate("interval", c("interval", "type"), sep = "_") %>%
    dplyr::mutate(type = factor(.data$type, levels = c("start", "end")),
                  station_name = as.character(.data$station_name),
                  lat = replace(.data$lat, .data$lat == 0, NA),
                  lon = replace(.data$lon, .data$lon == 0, NA),
                  date = replace(.data$date, date == "", NA),
                  TC_id = replace(.data$TC_id, .data$TC_id == "", NA),
                  prov = factor(.data$prov, levels = c("ALBERTA",
                                                       "BRITISH COLUMBIA",
                                                       "MANITOBA",
                                                       "NEW BRUNSWICK",
                                                       "NEWFOUNDLAND",
                                                       "NORTHWEST TERRITORIES",
                                                       "NOVA SCOTIA",
                                                       "NUNAVUT",
                                                       "ONTARIO",
                                                       "PRINCE EDWARD ISLAND",
                                                       "QUEBEC",
                                                       "SASKATCHEWAN",
                                                       "YUKON TERRITORY"),
                                labels = c("AB", "BC", "MB", "NB", "NL", "NT",
                                           "NS", "NU", "ON", "PE", "QC", "SK",
                                           "YT")),
                  prov = as.character(.data$prov)) %>%
    tidyr::spread("type", "date") %>%
    dplyr::arrange(.data$prov, .data$station_id, .data$interval) %>%
    dplyr::as_tibble()

  s <- s %>%
    dplyr::left_join(normals, by = c("station_name", "climate_id")) %>%
    dplyr::mutate(dplyr::across(dplyr::contains("normals"),
                                ~tidyr::replace_na(., FALSE)),
                  normals = purrr::pmap_lgl(dplyr::pick(dplyr::starts_with("normals_")),
                                           any)) %>%
    dplyr::relocate(dplyr::contains("normals_"), .after = dplyr::last_col())


  stn <- list(stn = s,
              meta = list(ECCC_modified = eccc_meta,
                          weathercan_modified = Sys.Date()))

  if(verbose) message("Saving stations data to ", f)
  readr::write_rds(x = stn, file = f, compress = "gz")

  if(!quiet) message("Stations data saved...\n",
                     "Use `stations()` to access most recent version and ",
                     "`stations_meta()` to see when this was last updated")

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
#' @param verbose Logical. Include progress messages
#' @param quiet Logical. Suppress all messages (including messages regarding
#'   missing data, etc.)
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

stations_search <- function(name = NULL,
                            coords = NULL,
                            dist = 10,
                            interval = c("hour", "day", "month"),
                            normals_years = NULL,
                            normals_only = NULL,
                            stn = NULL,
                            starts_latest = NULL,
                            ends_earliest = NULL,
                            verbose = FALSE,
                            quiet = FALSE) {

  if(!is.null(normals_only)) {
    warning("`normals_only` is deprecated, switching to ",
            "`normals_years = 'current'`", .call = FALSE)
    normals_years <- "current"
  }

  if(!is.null(normals_years) &&
     !normals_years %in% c("current", "1991-2020", "1981-2010", "1971-2000")) {
    stop("`normals_years` must either be `NULL` (don't filter by normals),",
         "'current', '1991-2020', '1981-2010' or '1971-2000'", call. = FALSE)
  }

  if(length(interval) > 1 || !(interval %in% c('hour', 'day', 'month'))) {
    stop("'interval' must be either 'hour', 'day', OR 'month'", call. = FALSE)
  }

  if(all(is.null(name), is.null(coords)) |
     all(!is.null(name), !is.null(coords))) {
    stop("Need a search name OR search coordinate")
  }

  if(!is.null(stn)){
    stop("`stn` is defunct, to use an updated stations data frame ",
         "use `stations_dl()` to update the internal data, and ",
         "`stations_meta()` to check when it was last updated", call. = FALSE)
  }
  stn <- stations()

  if(!is.null(coords)) {
    suppressWarnings({
      coords <- try(as.numeric(as.character(coords)), silent = TRUE)
      })
    if(length(coords) != 2 | all(is.na(coords)) |
       inherits(coords, "try-error")) {
      stop("'coord' takes one pair of lat and lon in a numeric vector")
    }

    if(!requireNamespace("sf", quietly = TRUE)) {
     stop("Package 'sf' required to search for stations using coordinates. ",
          "Use the code \"install.packages('sf')\" to install.", call. = FALSE)
    }

  }

  check_int(interval)

  stn <- dplyr::filter(stations(),
                       .data$interval %in% !! interval, !is.na(.data$start))

  if(!is.null(normals_years)) {

    if(normals_years == "1991-2020") {
      message(
        "You can find out which stations have normals for 1991-2020, ",
        "but be aware that they are not yet available for download via weathercan")
    }

    if(normals_years == "current") {
      yr <- "normals_1981_2010"  # Currently set Normals
    } else {
      yr <- paste0("normals_", stringr::str_replace(normals_years, "-", "_"))
    }
    stn <- dplyr::filter(stn, .data[[yr]])
  } else {

    if (!is.null(starts_latest)){
      suppressWarnings({
        starts_latest <- try(as.numeric(as.character(starts_latest)),
                             silent = TRUE)
      })
      if (is.na(starts_latest) | inherits(starts_latest, "try-error")){
        stop("'starts_latest' needs to be coercible into numeric")
      }
      stn <- dplyr::filter(stn, .data$start <= starts_latest)
    }

    if (!is.null(ends_earliest)){
      suppressWarnings({
        ends_earliest <- try(as.numeric(as.character(ends_earliest)),
                             silent = TRUE)
      })
      if (is.na(ends_earliest) | inherits(ends_earliest, "try-error")){
        stop("'ends_earliest' needs to be coercible into numeric")
      }
      stn <- dplyr::filter(stn, .data$end >= ends_earliest)
    }
  }

  if(!is.null(name)) {

    if(!quiet) if(length(name) == 2 & is.numeric(name)) {
      message("The `name` argument looks like a pair of coordinates. ",
              "Did you mean `coords = c(", name[1], ", ", name[2], ")`?")
    }

    if(verbose) message("Searching by name")
    if(inherits(try(as.character(name), silent = TRUE), "try-error")) {
      stop("'name' needs to be coercible into a character")
    }

    name <- gsub("([A-Z]*)", "\\L\\1", name, perl = TRUE)
    temp <- gsub("([A-Z]*)", "\\L\\1", stn$station_name, perl=TRUE)

    i <- list()
    for(a in name) i[[length(i)+1]] <- grep(a, temp)
    i <- Reduce(intersect, i)
  }

  if(!is.null(coords)){
    if(verbose) message("Calculating station distances")

    coords <- sf::st_point(coords[c(2,1)]) %>%
      sf::st_sfc(crs = 4326)

    locs <- dplyr::select(stn, "station_id", "lon", "lat") %>%
      tidyr::drop_na() %>%
      dplyr::distinct() %>%
      sf::st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
      dplyr::mutate(distance = as.vector(sf::st_distance(coords, .data$geometry))/1000) %>%
      sf::st_drop_geometry()

    stn <- dplyr::left_join(stn, locs, by = "station_id") %>%
      dplyr::arrange(.data$distance)

    i <- which(stn$distance <= dist)
    if(length(i) == 0) {
     i <- 1:10
     if(!quiet) message("No stations within ", dist,
                        "km. Returning closest 10 records")
    }
  }

  stn <- stn[i, ]

  if(!is.null(name)) stn <- dplyr::arrange(stn, .data$station_name,
                                           .data$station_id,
                                           .data$interval)
  if(!is.null(coords)) stn <- dplyr::arrange(stn, .data$distance,
                                             .data$station_name,
                                             .data$station_id,
                                             .data$interval)
  if(!is.null(normals_years)) {
    stn <- dplyr::select(stn, -"interval", -"start", -"end") %>%
      dplyr::distinct()
  }
  stn
}


normals_stn_list <- function(yr) {
  get_check(getOption("weathercan.urls.stations.normals"),
            query = list(yr = yr)) %>%
    httr::content(type = "text/csv", col_types = readr::cols(),
                  encoding = "Latin1", progress = FALSE) %>%
    dplyr::rename_with(tolower) %>%
    dplyr::select(dplyr::any_of(c("station_name", "climate_id")))
}

stations_normals <- function() {
  dplyr::tibble(years = c("1991-2020", "1981-2010", "1971-2000")) %>%
    dplyr::mutate(yr = stringr::str_extract(.data$years, "^[0-9]{4}"),
                  stns = purrr::map(.data$yr, normals_stn_list)) %>%
    tidyr::unnest("stns") %>%
    dplyr::select(-"yr") %>%
    dplyr::mutate(normals = TRUE,
                  years = stringr::str_replace(.data$years, "-", "_"),
                  years = paste0("normals_", .data$years)) %>%
    tidyr::pivot_wider(names_from = "years", values_from = "normals")
}
