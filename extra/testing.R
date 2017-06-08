library(dplyr)
library(tidyr)
library(weathercan)


stations[stations$station_ID == 51423,]
w <- weather_dl(51423, date = as.Date("2013-01-01"))

# PG airport
stations[stations$station_ID == 48248,]
w <- weather_dl(48248, date = as.Date("2013-01-01"))

stations[stations$station_ID == 50169,]
w <- weather_dl(50169, date = as.Date("2016-01-01"))

stations[stations$timeframe == "hour" & !is.na(stations$date),][1:10,]
w <- weather_dl(706, date = as.Date("1995-01-01"))

w$Wind.Spd..km.h.[c(54, 89, 92)] <- c(">3", ">5", ">10")

stations[stations$timeframe == "hour" & !is.na(stations$date),][1:10,]
w <- weather_dl(706, date = as.Date("1995-01-01"))

stations[stations$station_ID == 50169,]
w <- weather(706, start = "2012-06-01", end = "2012-08-10")


#for(i in 1:2) print(system.time(html <- RCurl::getURL(paste0(url, "?searchType=stnProv&timeframe=1&lstProvince=", province, "&optLimit=yearRange&StartYear=1840&EndYear=", format(Sys.Date(),  "%Y"), "&Year=2016&Month=1&Day=1&selRowPerPage=100&txtCentralLatMin=0&txtCentralLatSec=0&txtCentralLongMin=0&txtCentralLongSec=0&startRow=", startRow))))

#for(i in 1:2) print(system.time(html <- httr::GET(paste0(url, "?searchType=stnProv&timeframe=1&lstProvince=", province, "&optLimit=yearRange&StartYear=1840&EndYear=", format(Sys.Date(),  "%Y"), "&Year=2016&Month=1&Day=1&selRowPerPage=100&txtCentralLatMin=0&txtCentralLatSec=0&txtCentralLongMin=0&txtCentralLongSec=0&startRow=", startRow))))


#Prince George MASSEY: 50169


s <- RCurl::getURL("http://climate.weather.gc.ca/historical_data/search_historic_data_stations_e.html?searchType=stnProv&timeframe=1&lstProvince=&optLimit=yearRange&StartYear=1840&EndYear=2016&Year=2016&Month=5&Day=31&selRowPerPage=100&txtCentralLatMin=0&txtCentralLatSec=0&txtCentralLongMin=0&txtCentralLongSec=0&startRow=1")



url <- "http://climate.weather.gc.ca/historical_data/search_historic_data_stations_e.html"

searchType <- "stnProx"
timeframe <- "1"
txtRadius <- "25" # 50, 100, 200
optProxType <- "custom"

txtCentralLatDeg <- "53"
txtCentralLatMin <- "55"
txtCentralLatSec <- "01"

txtCentralLongDeg <- "122"
txtCentralLongMin <- "44"
txtCentralLongSec <- "58"

optLimit <- "yearRange"
StartYear <- "2016"
EndYear <- "2016"

g <- RCurl::getURL("http://climate.weather.gc.ca/historical_data/search_historic_data_stations_e.html?")



g <- RCurl::getURL("http://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=1706&timeframe=1&submit=Download+Data")

preamble <- read.csv(text = g, strip.white = TRUE, colClasses = "character", nrows = 14, header = FALSE)
w <- read.csv(text = g, strip.white = TRUE, colClasses = "character", skip = 15, col.names = c("date", "year", "month", "day", "time", "qual", "temp", "temp_flag", "temp_dew", "temp_dew_flag", "rel_hum", "rel_hum_flag", "wind_dir", "wind_dir_flag", "wind_spd", "wind_spd_flag", "visib", "visib_flag", "pressure", "pressure_flag", "hmdx", "hmdx_flag", "wind_chill", "wind_chill_flag", "weather"))


# Stop if url doesn't exist
if(!RCurl::url.exists(url)) stop("The url '", url, "' doesn't exist (or you have no internet connection).")

# Stop if sites not in list
if(!all(sites %in% c("Kamloops", "Costa Rica"))) stop("Sites must be one or more of 'Kamloops' and/or 'Costa Rica'")

sites <- gsub("Kamloops", "qskam", sites)
sites <- gsub("Costa Rica", "qscr", sites)

# Get form options
params <- as.list(rep("1", length(c(feeder_details, bird_details, sites))))
names(params) <- c(feeder_details, bird_details, sites)
params <- append(params,
                 list(feeder_id = "1",
                      bird_id = "1",
                      tz = tz,
                      qstart = t.start,
                      qend = t.end,
                      qstarttz = tz,
                      qendtz = tz))

g <- RCurl::getForm(url, .params = params)



get.data <- function(start = NULL,
                     end = NULL,
                     url = "http://gaia.tru.ca/birdMOVES/rscripts/rawvisits.csv",
                     feeder_details = c("loc"),
                     bird_details = c("species"),
                     tz = "America/Vancouver",
                     sites = "Kamloops") {

  # Stop if timezones different
  if(!(tz %in% c("America/Vancouver", "GMT", "America/Costa Rica"))) stop("Timezone must be one of 'America/Vancouver', 'GMT', 'America/Costa Rica'. (You can change timezones after they've been downloaded.)")

  # Stop if time is not in the correct format

  t.start <- NULL
  t.end <- NULL
  if(!is.null(start)) {
    suppressWarnings(t.start <- lubridate::parse_date_time(start, orders = "ymd hms", truncated = 5))
    if(is.na(t.start)) stop("Your start time is ambiguous. Format should be YYYY-MM-DD (HH:MM:SS is optional)")
    t.start <- format(t.start, "%Y-%m-%d %H:%M:%S")
  }
  if(!is.null(end)) {
    suppressWarnings(t.end <- lubridate::parse_date_time(end, orders = "ymd hms", truncated = 5))
    if(is.na(t.end)) stop("Your end time is ambiguous. Format should be YYYY-MM-DD (HH:MM:SS is optional)")
    t.end <- format(t.end, "%Y-%m-%d %H:%M:%S")
  }

  # Stop if url doesn't exist
  if(!RCurl::url.exists(url)) stop("The url '", url, "' doesn't exist (or you have no internet connection).")

  # Stop if sites not in list
  if(!all(sites %in% c("Kamloops", "Costa Rica"))) stop("Sites must be one or more of 'Kamloops' and/or 'Costa Rica'")

  sites <- gsub("Kamloops", "qskam", sites)
  sites <- gsub("Costa Rica", "qscr", sites)

  # Get form options
  params <- as.list(rep("1", length(c(feeder_details, bird_details, sites))))
  names(params) <- c(feeder_details, bird_details, sites)
  params <- append(params,
                   list(feeder_id = "1",
                        bird_id = "1",
                        tz = tz,
                        qstart = t.start,
                        qend = t.end,
                        qstarttz = tz,
                        qendtz = tz))

  g <- RCurl::getForm(url, .params = params)

  if(nchar(g) < 200) stop("There are no online data matching these parameters. Try different sites or a different date range.")

  r <- load.format(read.csv(text = g, strip.white = TRUE, colClasses = "character"), tz = tz)
  return(r)
}
