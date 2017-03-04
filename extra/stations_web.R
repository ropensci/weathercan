#' @import magrittr
deg_dec <- function(coord){
  data.frame(type = c("lat", "lon"),
             deg = c(coord[grep("N", coord)], coord[grep("W", coord)])) %>%
    dplyr::mutate(dir = gsub("(.*?)(N|W)(.*?)", "\\2", deg),
                  deg = gsub("(\\s)|(\")|N|W", "", deg)) %>%
    tidyr::separate(deg, sep = "°", into = c("v1", "deg")) %>%
    tidyr::separate(deg, sep = "'", into = c("v2", "v3")) %>%
    dplyr::mutate(dec = as.numeric(v1) + as.numeric(v2)/60 + as.numeric(v3)/3600) %>%
    dplyr::mutate(dec = replace(dec, dir == "W", dec[dir=="W"] * -1)) %>%
    dplyr::select(type, dec) %>%
    tidyr::spread(type, dec)
}

#' @import magrittr
stations_locs <- function(station_id,
                          url_loc = "http://climate.weather.gc.ca/climate_data/daily_data_e.html",
                          verbose = FALSE) {

  if(verbose) message("Getting location of ", station_id)
  html <- xml2::read_html(paste0(url_loc, "?StationID=", station_id))
  coord <- deg_dec(c(rvest::html_nodes(html, "div[aria-labelledby=latitude]") %>% rvest::html_text(),
                     rvest::html_nodes(html, "div[aria-labelledby=longitude]") %>% rvest::html_text()))

  return(coord)
}

#' @import magrittr
stations_dl <- function(startRow = 1,
                        province = "all",
                        url = "http://climate.weather.gc.ca/historical_data/search_historic_data_stations_e.html",
                        verbose = FALSE) {

  if(province == "all") province = ""

  if(verbose) message("Getting next 100 starting with ", startRow)

  html <- xml2::read_html(paste0(url, "?searchType=stnProv&timeframe=1&lstProvince=", province, "&optLimit=yearRange&StartYear=1840&EndYear=", format(Sys.Date(),  "%Y"), "&Year=2016&Month=1&Day=1&selRowPerPage=100&txtCentralLatMin=0&txtCentralLatSec=0&txtCentralLongMin=0&txtCentralLongSec=0&startRow=", startRow))
  content <- rvest::html_nodes(html, "form[id$=-sm]")

  s <- data.frame(station_name = rvest::html_nodes(html, "input[name=lstProvince]+div") %>% rvest::html_text(),
                  hlyRange = rvest::html_nodes(content, "input[name=hlyRange]") %>% rvest::html_attr(name = "value"),
                  dlyRange = rvest::html_nodes(content, "input[name=dlyRange]") %>% rvest::html_attr(name = "value"),
                  mlyRange = rvest::html_nodes(content, "input[name=mlyRange]") %>% rvest::html_attr(name = "value"),
                  station_id = rvest::html_nodes(content, "input[name=StationID]") %>% rvest::html_attr(name = "value"),
                  prov = rvest::html_nodes(content, "input[name=Prov]") %>% rvest::html_attr(name = "value"), stringsAsFactors = FALSE) %>%
    tidyr::gather(timeframe, date, -prov, -station_name, -station_id) %>%
    dplyr::mutate(date = replace(date, date == "|", NA)) %>%
    tidyr::separate(date, c("start", "end"), sep = "\\|", remove = TRUE) %>%
    dplyr::mutate(timeframe = replace(timeframe, timeframe == "hlyRange", "hour"),
                  timeframe = replace(timeframe, timeframe == "dlyRange", "day"),
                  timeframe = replace(timeframe, timeframe == "mlyRange", "month"),
                  start = as.Date(start),
                  end = as.Date(end)) %>%
    dplyr::select(prov, station_name, station_id, timeframe, start, end)
  return(s)
}

#' Get available stations
#'
#' This function can be used to download up-to-date station information from
#' Environment Canada. Note that the 'stations' data set included in this
#' package contains station data downloaded when the package was last compiled,
#' so it may not be necessary to call this function (and this may take a few
#' minutes).
#'
#' @param province Character. Single or multiple character vector defining
#'   provinces in two letter codes (\"ON\", \"BC\", etc.) or "all".
#' @param get_locs Logical. Should location data (lat, lon, and elevation) also
#'   be retrieved? (Takes a bit longer)
#' @param url Character. Url from which to grab the station information
#'
#' @return Data frame containing station names, station ID codes and dates of
#'   operation
#'
#' @import magrittr
#' @export
stations_all <- function(province = "all",
                         get_locs = TRUE,
                         url = "http://climate.weather.gc.ca/historical_data/search_historic_data_stations_e.html") {

  if(!all(province %in% c("all", "AB", "BC", "MB", "NB", "NL", "NS", "NT", "NU", "ON", "PE", "QC", "SK", "XX", "YT"))) stop("Unknown province. Must be either \"all\" or provincial two-letter codes: \"AB\", \"BC\", \"MB\", \"NB\", \"NL\", \"NS\", \"NT\", \"NU\", \"ON\", \"PE\", \"QC\", \"SK\", \"XX\", \"YT\"")

  if(length(province) > 1 & any(province == "all")) {
    message("Both \"all\" and provincial codes specified. Ignoring \"all\".")
    province <- province[province != "all"]
  }

  if(any(province == "all")) province <- ""

  data <- data.frame()
  for(p in province){
    if(p == "") p.nice = "All provinces" else p.nice = p
    message(paste0("Currently downloading stations from: ", p.nice, "\n"))
    n.total <- xml2::read_html(paste0(url, "?searchType=stnProv&timeframe=1&lstProvince=", p, "&optLimit=yearRange&StartYear=1840&EndYear=", format(Sys.Date(),  "%Y"), "&Year=2016&Month=1&Day=1&selRowPerPage=100&txtCentralLatMin=0&txtCentralLatSec=0&txtCentralLongMin=0&txtCentralLongSec=0&startRow=1")) %>%
      rvest::html_nodes("p[data-options]") %>%
      rvest::html_text() %>%
      gsub("([0-9]*)(.*?)$", "\\1", .)

    n <- seq(from = 0, to = as.numeric(n.total), by = 101)

    pb <- txtProgressBar(min = 0, max = max(n), style = 3)
    d <- do.call("rbind", lapply(n, FUN = function(x){setTxtProgressBar(pb, x); stations_dl(x, province = p)}))
    close(pb)

    data <- rbind(data, d)
    if(length(unique(d$station_id)) != n.total) message(paste0("Province ", p, ": Didn't get all the stations expected"))
  }
  data <- unique(data)


  if(get_locs) {
    message("Retrieving station locations...")
    data <- dplyr::left_join(data,
                             data %>%
                               dplyr::group_by(station_id) %>%
                               dplyr::do(stations_locs(station_id = unique(.$station_id), verbose = TRUE)), by = "station_id")
  }

  data <- data %>%
    dplyr::mutate(prov = factor(prov),
                  station_name = factor(station_name),
                  station_id = factor(station_id),
                  timeframe = factor(timeframe, levels = c("hour", "day", "month")))

  return(data)
}
