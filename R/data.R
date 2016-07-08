#' Station data downloaded from Environment Canada
#'
#' A dataset containing station information downloaded from Environment Canada
#' on June 17th 2016. Note that a station may have several station IDs,
#' depending on how the data collection has changed over the years. Station
#' information can be updated by stations <- running stations_all() and then by
#' specifying stn = stations in most functions.
#'
#' @format A data frame with 26199 rows and 12 variables:
#' \describe{
#'   \item{prov}{Province}
#'   \item{station_name}{Station name}
#'   \item{station_id}{Environment Canada's station ID number. Required for
#'   downloading station data.}
#'   \item{climate_id}{Climate ID number}
#'   \item{WMO_id}{Climate ID number}
#'   \item{TC_id}{Climate ID number}
#'   \item{lat}{Latitude of station location}
#'   \item{lon}{Longitude of station location}
#'   \item{elev}{Elevation of station location}
#'   \item{timeframe}{Timeframe of the data measurements ('hour', 'day', 'month')}
#'   \item{start}{Starting year of station data}
#'   \item{end}{Ending year of station data}
#' }
#' @source \url{http://climate.weather.gc.ca/index_e.html}
"stations"

#' Hourly weather data for Kamloops downloaded with \code{weather()}
#'
#' An example dataset of hourly weather data for Kamloops
"kamloops"

#' Hourly weather data for Prince George downloaded with \code{weather()}
#'
#' An example dataset of hourly weather data for Prince George
"pg"

#' Daily weather data for Kamloops downloaded with \code{weather()}
#'
#' An example dataset of daily weather data for Kamloops
"kamloops_day"
