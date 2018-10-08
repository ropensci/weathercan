#' Get available stations
#'
#' This function can be used to download a Station Inventory CSV file from
#' Environment and Climate Change Canada. This is only necessary if the station
#' you're interested was only recently added. The 'stations' data set included
#' in this package contains station data downloaded when the package was last
#' compiled. This function may take a few minutes to run.
#'
#' @details
#' URL defaults to
#' ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/
#' Station%20Inventory%20EN.csv unless otherwise specified
#'
#' @param url Character. Url from which to grab the station information (see
#'   details)
#' @param skip Numeric. Number of lines to skip at the beginning of the csv. If
#'   NULL, automatically derived.
#' @param verbose Logical. Include progress messages
#' @param quiet Logical. Suppress all messages (including messages regarding
#'   missing data, etc.)
#'
#' @return A tibble containing station names, station ID codes and dates of
#'   operation
#'
#' @examples
#'
#' \donttest{
#'  # Update stations data frame
#'  s <- stations_dl()
#'
#'  # Use new data frame to search for stations
#'  stations_search("Winnipeg", stn = s)
#' }
#'
#' @aliases stations_all
#'
#' @export

stations_dl <- function(url = NULL,
                        skip = NULL, verbose = FALSE, quiet = FALSE) {

  if(getRversion() <= "3.3.3") {
    message("Need R version 3.3.4 or greater to update the stations data")
    return()
  }

  if(!requireNamespace("lutz", quietly = TRUE) |
     !requireNamespace("sf", quietly = TRUE)) {
    stop("Package 'lutz' and its dependency, 'sf', are required to get ",
         "timezones for the updated stations dataframe. ",
         "Use the code \"install.packages(c('lutz', 'sf'))\" to install.",
         call. = FALSE)
  }

  if(verbose) message("Trying to access stations data frame")
  if(is.null(url)) {
    url <- paste0("ftp://client_climate@ftp.tor.ec.gc.ca/",
                  "Pub/Get_More_Data_Plus_de_donnees/",
                  "Station%20Inventory%20EN.csv")
    if(suppressWarnings(
      httr::http_error("ftp://client_climate@ftp.tor.ec.gc.ca"))) {
      stop("Cannot reach ECCC ftp site, please try again later", call. = FALSE)
    }
  }

  headings <- try(readLines(url, n = 5), silent = TRUE)
  if("try-error" %in% class(headings)) {
    stop("'url' must point to a csv file either local or online.")
  }

  if(is.null(skip)) {
    skip <- grep(paste0("(.*?)(Name)(.*?)(Province)(.*?)(Climate ID)(.*?)",
                        "(Station ID)(.*?)(WMO ID)(.*?)(TC ID)(.*?)"),
                 headings) - 1
  }

  if(!quiet) message("According to Environment Canada, ",
                     grep("Modified Date", headings, value = TRUE))
  if(!quiet) message("Environment Canada Disclaimers:\n",
                     paste0(grep("Disclaimer", headings, value = TRUE),
                            collapse = "\n"))

  if(verbose) message("Downloading stations data frame")

  s <- utils::read.csv(file = url,
                         skip = skip,
                         strip.white = TRUE) %>%
    dplyr::select(prov = Province,
                  station_name = Name,
                  station_id = Station.ID,
                  climate_id = Climate.ID,
                  hour_start = dplyr::matches("HLY.First"),
                  hour_end = dplyr::matches("HLY.Last"),
                  day_start = dplyr::matches("DLY.First"),
                  day_end = dplyr::matches("DLY.Last"),
                  month_start = dplyr::matches("MLY.First"),
                  month_end = dplyr::matches("MLY.Last"),
                  WMO_id = WMO.ID,
                  TC_id = TC.ID,
                  lat = dplyr::matches("Latitude..Decimal"),
                  lon = dplyr::matches("Longitude..Decimal"),
                  elev = dplyr::starts_with("Elevation..m."))

  # Calculate Timezones
  station_tz <- dplyr::select(s, station_id, lat, lon) %>%
    dplyr::distinct() %>%
    dplyr::mutate(tz = lutz::tz_lookup_coords(lat, lon, method = "accurate"),
                  tz = purrr::map_chr(tz, ~tz_offset(.x)))

  s %>%
    dplyr::left_join(station_tz, by = c("station_id", "lat", "lon")) %>%
    tidyr::gather(interval, date, dplyr::matches("(start)|(end)")) %>%
    tidyr::separate(interval, c("interval", "type"), sep = "_") %>%
    dplyr::mutate(type = factor(type, levels = c("start", "end")),
                  station_name = as.character(station_name),
                  station_id = factor(station_id),
                  lat = replace(lat, lat == 0, NA),
                  lon = replace(lon, lon == 0, NA),
                  WMO_id = factor(WMO_id),
                  date = replace(date, date == "", NA),
                  TC_id = replace(TC_id, TC_id == "", NA),
                  prov = factor(prov, levels = c("ALBERTA",
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
                                           "YT"))) %>%
    tidyr::spread(type, date) %>%
    dplyr::arrange(prov, station_id, interval) %>%
    dplyr::tbl_df()
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
#' @param stn Data frame. The \code{stations} data frame to use. Will use the
#'   one included in the package unless otherwise specified.
#' @param verbose Logical. Include progress messages
#' @param quiet Logical. Suppress all messages (including messages regarding
#'   missing data, etc.)
#'
#' @details To search by coordinates, users must make sure they have the
#'  \code{\link[sp]{sp}} package installed.
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
#' stations_search(coords = c(53.915495, -122.739379))
#'
#' \donttest{
#' loc <- ggmap::geocode("Prince George, BC")
#' stations_search(coords = loc[c("lat", "lon")])
#' }
#'
#' @export

stations_search <- function(name = NULL,
                            coords = NULL,
                            dist = 10,
                            interval = c("hour", "day", "month"),
                            stn = weathercan::stations,
                            verbose = FALSE,
                            quiet = FALSE) {
  if(all(is.null(name), is.null(coords)) |
     all(!is.null(name), !is.null(coords))) {
    stop("Need a search name OR search coordinate")
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

  stn <- dplyr::filter(stn, interval %in% !! interval, !is.na(start))

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
    stn <- dplyr::arrange(stn, distance)

    i <- which(stn$distance <= dist)
    if(length(i) == 0) {
     i <- 1:10
     if(!quiet) message("No stations within ", dist,
                        "km. Returning closest 10 stations.")
    }
  }

  stn <- stn[i, ]
  if(!is.null(name)) stn <- dplyr::arrange(stn, station_name,
                                           station_id, interval)
  if(!is.null(coords)) stn <- dplyr::arrange(stn, distance, station_name,
                                             station_id, interval)

  stn
}

#' @export
stations_all <- function(url = NULL,
                         skip = NULL, verbose = FALSE, quiet = FALSE) {
  .Deprecated("stations_dl")
}
