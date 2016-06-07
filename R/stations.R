
#' @import magrittr
stations_dl <- function(startRow = 1,
                        province = "all",
                        url = "http://climate.weather.gc.ca/historical_data/search_historic_data_stations_e.html") {

  if(province == "all") province = ""

  html <- httr::GET(paste0(url, "?searchType=stnProv&timeframe=1&lstProvince=", province, "&optLimit=yearRange&StartYear=1840&EndYear=", format(Sys.Date(),  "%Y"), "&Year=2016&Month=1&Day=1&selRowPerPage=100&txtCentralLatMin=0&txtCentralLatSec=0&txtCentralLongMin=0&txtCentralLongSec=0&startRow=", startRow))

  s <- readLines(textConnection(httr::content(html, "text", encoding = "UTF-8"))) %>%
    .[sapply(grep("stnRequest[0-9]+\">", .), FUN = function(x) seq(from = x, to = x + 16, by = 1))] %>%
    data.frame(code = .) %>%
    dplyr::mutate(n = sort(rep(1:(length(code)/17), 17)),
                  variable = stringr::str_extract(code, "(hlyRange)|(dlyRange)|(mlyRange)|(StationID)|(Prov)|(urlExtension)|(searchType)|(optLimit)|(StartYear)|(EndYear)|(selRowPerPage)|(Line)|(Month)|(Day)"),
                  value = stringr::str_extract(stringr::str_extract(stringr::str_extract(code, "value=\".+\""), "\".+\""), "[^\"]+"),
                  station_name = stringr::str_extract(stringr::str_extract(code, ">(.)+<"), "[^><]+")) %>%
    dplyr::group_by(n) %>%
    dplyr::mutate(station_name = station_name[!is.na(station_name)]) %>%
    dplyr::filter(!is.na(variable), !is.na(value)) %>%
    dplyr::mutate(value = replace(value, value == "|", NA)) %>%
    dplyr::select(-code) %>%
    dplyr::ungroup() %>%
    dplyr::distinct() %>%
    tidyr::spread(variable, value) %>%
    dplyr::rename(station_ID = StationID, prov = Prov) %>%
    tidyr::separate(hlyRange, c("hly_start", "hly_end"), sep = "\\|", remove = TRUE) %>%
    tidyr::separate(dlyRange, c("dly_start", "dly_end"), sep = "\\|", remove = TRUE) %>%
    tidyr::separate(mlyRange, c("mly_start", "mly_end"), sep = "\\|", remove = TRUE) %>%
    tidyr::gather(timeframe, date, -prov, -station_name, -station_ID) %>%
    tidyr::separate(timeframe, c("timeframe", "type"), sep = "_") %>%
    tidyr::spread(type, date) %>%
    dplyr::mutate(timeframe = replace(timeframe, timeframe == "hly", "hour"),
                  timeframe = replace(timeframe, timeframe == "dly", "day"),
                  timeframe = replace(timeframe, timeframe == "mly", "month"),
                  int = lubridate::interval(start, end)) %>%
    dplyr::select(prov, station_name, station_ID, timeframe, start, end, int, -StartYear, -EndYear, -Month, -Day, -optLimit, -searchType, -selRowPerPage, -urlExtension) %>%

    return(s)
}


#' Get available stations
#'
#' This function can be used to download up-to-date station information from
#' Environment Canada. Note that the 'stations' data set contains station data
#' downloaded on June 2nd 2016, so it may not be necessary to call this
#' function.
#'
#' @param province Character. Single or multiple character vector defining
#'   provinces in two letter codes (\"ON\", \"BC\", etc.) or "all".
#' @param url Character. Url from which to grab the station information
#'
#' @return Data frame containing station names, station ID codes and dates of operation
#'
#' @import magrittr
#' @export
#'
#'
#' @examples
#'
#'
stations_all <- function(province = "all",
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
    startRow = 1
    html <- httr::GET(paste0(url, "?searchType=stnProv&timeframe=1&lstProvince=", p, "&optLimit=yearRange&StartYear=1840&EndYear=", format(Sys.Date(),  "%Y"), "&Year=2016&Month=1&Day=1&selRowPerPage=25&txtCentralLatMin=0&txtCentralLatSec=0&txtCentralLongMin=0&txtCentralLongSec=0&startRow=", startRow))

    n.total <- readLines(textConnection(httr::content(html, "text", encoding = "UTF-8"))) %>%
      grep("[0-9]+ locations match", ., value = TRUE) %>%
      stringr::str_extract(., "[0-9]+ locations match") %>%
      stringr::str_extract(., "[0-9]+") %>% as.numeric(.)
    n <- seq(0, n.total, by = 101)

    d <- plyr::ldply(n, stations_dl, province = p, .progress = "text")
    data <- rbind(data, d)

    if(nrow(d)/6 != n.total) message(paste0("Province ", p, ": Didn't get all the stations expected to"))
  }

  data <- data  %>%
    dplyr::mutate(prov = factor(prov),
                  station_name = factor(station_name),
                  station_ID = factor(station_ID),
                  timeframe = factor(timeframe),
                  type = factor(type),
                  date = as.Date(date))

  return(data)
}


#stations_closest
