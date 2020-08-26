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
#' stored in the option `weathercan.urls.normals`. To change this location use
#' `options(weathercan.urls.normals = "your_new_url")`.
#'
#' @param url DEPRECATED. To set a different url use `options()` (see details).
#' @param skip Numeric. Number of lines to skip at the beginning of the csv. If
#'   NULL, automatically derived.
#' @param verbose Logical. Include progress messages
#' @param quiet Logical. Suppress all messages (including messages regarding
#'   missing data, etc.)
#'
#' @inheritParams normals_dl
#'
#' @return A tibble containing station names, station ID codes, dates of
#'   operation, as well as whether or not there are data on climate normals.
#'
#' @examples
#'
#' \donttest{
#'   # Update stations data frame
#'   if(requireNamespace("lutz") && requireNamespace("sf")) {
#'     s <- stations_dl()
#'
#'     # Use new data frame to search for stations
#'     stations_search("Winnipeg", stn = s)
#'    }
#' }
#'
#' @aliases stations_all
#'
#' @export

stations_dl <- function(url = NULL, normals_years = "1981-2010",
                        skip = NULL, verbose = FALSE, quiet = FALSE) {

  if(getRversion() <= "3.3.3") {
    message("Need R version 3.3.4 or greater to update the stations data")
    return()
  }

  if(!is.null(url)) {
    warning("'url' is deprecated, use ",
            "`options(weathercan.urls.stations = \"your_new_url\")` instead",
            .call = FALSE)
  }

  if(!requireNamespace("lutz", quietly = TRUE) |
     !requireNamespace("sf", quietly = TRUE)) {
    stop("Package 'lutz' and its dependency, 'sf', are required to get ",
         "timezones for the updated stations dataframe. ",
         "Use the code \"install.packages(c('lutz', 'sf'))\" to install.",
         call. = FALSE)
  }

  # Get normals data
  normals <- stations_normals(years = normals_years)

  if(verbose) message("Trying to access stations data frame")

  u <- httr::parse_url(getOption("weathercan.urls.stations"))
  u$path <- NULL
  if(httr::http_error(httr::build_url(u))) {
    stop("Cannot reach ECCC ftp site, please try again later", call. = FALSE)
  }

  headings <- try(readr::read_lines(getOption("weathercan.urls.stations"), n_max = 5),
                  silent = TRUE)
  if("try-error" %in% class(headings)) {
    message("Can't access ", getOption("weathercan.urls.stations"), " right now.")
    return()
  }

  if(is.null(skip)) {
    skip <- find_line(headings, cols = c("Name", "Province", "Climate ID",
                                         "Station ID", "WMO ID", "TC ID")) - 1
  }

  if(!quiet) message("According to Environment Canada, ",
                     grep("Modified Date", headings, value = TRUE))
  if(!quiet) message("Environment Canada Disclaimers:\n",
                     paste0(grep("Disclaimer", headings, value = TRUE),
                            collapse = "\n"))

  if(verbose) message("Downloading stations data frame")

  s <- readr::read_csv(file = getOption("weathercan.urls.stations"),
                       skip = skip, col_types = readr::cols()) %>%
    dplyr::select(prov = "Province",
                  station_name = "Name",
                  station_id = "Station ID",
                  climate_id = "Climate ID",
                  hour_start = dplyr::matches("HLY First"),
                  hour_end = dplyr::matches("HLY Last"),
                  day_start = dplyr::matches("DLY First"),
                  day_end = dplyr::matches("DLY Last"),
                  month_start = dplyr::matches("MLY First"),
                  month_end = dplyr::matches("MLY Last"),
                  WMO_id = "WMO ID",
                  TC_id = "TC ID",
                  lat = dplyr::matches("Latitude \\(Decimal"),
                  lon = dplyr::matches("Longitude \\(Decimal"),
                  elev = dplyr::starts_with("Elevation"))

  # Calculate Timezones
  station_tz <- dplyr::select(s, "prov", "station_id", "lat", "lon") %>%
    dplyr::distinct() %>%
    dplyr::mutate(tz = lutz::tz_lookup_coords(.data$lat, .data$lon,
                                              method = "accurate"),
                  tz = purrr::map_chr(.data$tz, ~tz_offset(.x)))

  s <- s %>%
    dplyr::left_join(station_tz, by = c("station_id", "prov", "lat", "lon")) %>%
    tidyr::gather(key = "interval", value = "date", dplyr::matches("(start)|(end)")) %>%
    tidyr::separate(.data$interval, c("interval", "type"), sep = "_") %>%
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
    tidyr::spread(.data$type, .data$date) %>%
    dplyr::arrange(.data$prov, .data$station_id, .data$interval) %>%
    dplyr::mutate(normals = FALSE) %>%
    dplyr::as_tibble()

  s$normals[s$climate_id %in% normals] <- TRUE

  s
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
#' @param normals_only Logical. Return only stations with climate normals?
#' @param stn Data frame. The \code{stations} data frame to use. Will use the
#'   one included in the package unless otherwise specified.
#' @param starts_latest Numeric. Restrict results to stations with data collection
#' beginning in or before the specified year.
#' @param ends_earliest Numeric. Restrict results to stations with data collection
#' ending in or after the specified year.
#' @param verbose Logical. Include progress messages
#' @param quiet Logical. Suppress all messages (including messages regarding
#'   missing data, etc.)
#'
#' @details To search by coordinates, users must make sure they have the
#'  [sp](https://cran.r-project.org/package=sp) package installed.
#'
#' @return Returns a subset of the stations data frame which match the search
#'   parameters. If the search was by location, an extra column 'distance' shows
#'   the distance in kilometres from the location to the station. If no stations
#'   are found withing `dist`, the closest 10 stations are returned.
#'
#' @examples
#'
#' stations_search(name = "Kamloops")
#' stations_search(name = "Kamloops", interval = "hour")
#'
#' stations_search(name='Ottawa', starts_latest=1950, ends_earliest=2010)
#'
#' if(requireNamespace("sp")) {
#'   stations_search(coords = c(53.915495, -122.739379))
#' }
#'
#' @export

stations_search <- function(name = NULL,
                            coords = NULL,
                            dist = 10,
                            interval = c("hour", "day", "month"),
                            normals_only = FALSE,
                            stn = weathercan::stations,
                            starts_latest = NULL,
                            ends_earliest = NULL,
                            verbose = FALSE,
                            quiet = FALSE) {
  if(all(is.null(name), is.null(coords)) |
     all(!is.null(name), !is.null(coords))) {
    stop("Need a search name OR search coordinate")
  }

  if(is.null(stn)) {
    stn <- weathercan::stations
    message("No valid stn data frame supplied, using built-in")
  }

  if(!is.null(coords)) {
    suppressWarnings({
      coords <- try(as.numeric(as.character(coords)), silent = TRUE)
      })
    if(length(coords) != 2 | all(is.na(coords)) |
       class(coords) == "try-error") {
      stop("'coord' takes one pair of lat and lon in a numeric vector")
    }

    if(!requireNamespace("sp", quietly = TRUE)) {
     stop("Package 'sp' required to search for stations using coordinates. ",
          "Use the code \"install.packages('sp')\" to install.", call. = FALSE)
    }

  }

  check_int(interval)

  stn <- dplyr::filter(stn, .data$interval %in% !! interval, !is.na(.data$start))

  if(normals_only) {
    stn <- dplyr::filter(stn, .data$normals == TRUE)
  } else {

    if (!is.null(starts_latest)){
      suppressWarnings({
        starts_latest <- try(as.numeric(as.character(starts_latest)),
                             silent = TRUE)
      })
      if (is.na(starts_latest) | class(starts_latest) == "try-error"){
        stop("'starts_latest' needs to be coercible into numeric")
      }
      stn <- dplyr::filter(stn, .data$start <= starts_latest)
    }

    if (!is.null(ends_earliest)){
      suppressWarnings({
        ends_earliest <- try(as.numeric(as.character(ends_earliest)),
                             silent = TRUE)
      })
      if (is.na(ends_earliest) | class(ends_earliest) == "try-error"){
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
    if(class(try(as.character(name), silent = TRUE)) == "try-error") {
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
    coords <- as.numeric(as.character(coords[c(2,1)]))
    locs <- as.matrix(stn[!is.na(stn$lat), c("lon", "lat")])
    stn$distance <- NA
    stn$distance[!is.na(stn$lat)] <- sp::spDistsN1(pts = locs,
                                                   pt = coords, longlat = TRUE)
    stn <- dplyr::arrange(stn, .data$distance)

    i <- which(stn$distance <= dist)
    if(length(i) == 0) {
     i <- 1:10
     if(!quiet) message("No stations within ", dist,
                        "km. Returning closest 10 stations.")
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
  if(normals_only) {
    stn <- dplyr::select(stn, -"interval", -"start", -"end") %>%
      dplyr::distinct()
  }
  stn
}


stations_normals <- function(years = "1981-2010") {

  check_normals(years)

  dplyr::tibble(prov = province,
                loc = file.path(getOption("weathercan.urls.normals"),
                                years, province)) %>%
    dplyr::mutate(climate_id = purrr::map(.data$loc,
                                          ~stations_extract_normals(.))) %>%
    dplyr::pull(.data$climate_id) %>%
    unlist()
}

stations_extract_normals <- function(loc) {
  xml2::read_html(loc) %>%
    rvest::html_nodes("a") %>%
    rvest::html_text() %>%
    stringr::str_subset(".csv") %>%
    stringr::str_extract("[0-9A-Z]{7}")
}
