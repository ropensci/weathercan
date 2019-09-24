#' Station data downloaded from Environment and Climate Change Canada
#'
#' A dataset containing station information downloaded from Environment and
#' Climate Change Canada. Note that a station may have several station IDs,
#' depending on how the data collection has changed over the years. Station
#' information can be updated by running \code{stations_new <-  stations_dl()}
#' and then by specifying stn = stations_new in most functions.
#'
#' @format A data frame with 26211 rows and 12 variables:
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
#'   \item{normals}{Whether climate normals are available for that station}
#' }
#' @source \url{http://climate.weather.gc.ca/index_e.html}
"stations"

#' Hourly weather data for Kamloops
#'
#' Downloaded with \code{\link{weather}()}. Terms are more thoroughly defined
#' here \url{http://climate.weather.gc.ca/glossary_e.html}
#'
#' @format An example dataset of hourly weather data for Kamloops:
#' \describe{
#'   \item{station_name}{Station name}
#'   \item{station_id}{Environment Canada's station ID number. Required for
#'   downloading station data.}
#'   \item{prov}{Province}
#'   \item{lat}{Latitude of station location in degree decimal format}
#'   \item{lon}{Longitude of station location in degree decimal format}
#'   \item{date}{Date}
#'   \item{time}{Time}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{day}{Day}
#'   \item{hour}{Hour}
#'   \item{qual}{Data quality}
#'   \item{weather}{The state of the atmosphere at a specific time.}
#'   \item{hmdx}{Humidex}
#'   \item{hmdx_flag}{Humidex data flag}
#'   \item{pressure}{Pressure (kPa)}
#'   \item{pressure_flag}{Pressure data flag}
#'   \item{rel_hum}{Relative humidity}
#'   \item{rel_hum_flag}{Relative humidity data flag}
#'   \item{temp}{Temperature}
#'   \item{temp_dew}{Dew Point Temperature}
#'   \item{temp_dew_flag}{Dew Point Temperature flag}
#'   \item{visib}{Visibility (km)}
#'   \item{visib_flag}{Visibility data flag}
#'   \item{wind_chill}{Wind Chill}
#'   \item{wind_chill_flag}{Wind Chill flag}
#'   \item{wind_dir}{Wind Direction (10's of degrees)}
#'   \item{wind_dir_flag}{wind Direction Flag}
#'   \item{wind_spd}{Wind speed km/hr}
#'   \item{wind_spd_flag}{Wind speed flag}
#'   \item{elev}{Elevation (m)}
#'   \item{climate_id}{Climate identifier}
#'   \item{WMO_id}{World Meteorological Organization Identifier}
#'   \item{TC_id}{Transport Canada Identifier}
#' }
#' @source \url{http://climate.weather.gc.ca/index_e.html}
"kamloops"

#' Hourly weather data for Prince George
#'
#' Downloaded with \code{\link{weather}()}. Terms are more thoroughly defined
#' here \url{http://climate.weather.gc.ca/glossary_e.html}
#'
#' @format An example dataset of hourly weather data for Prince George:
#' \describe{
#'   \item{station_name}{Station name}
#'   \item{station_id}{Environment Canada's station ID number. Required for
#'   downloading station data.}
#'   \item{prov}{Province}
#'   \item{lat}{Latitude of station location in degree decimal format}
#'   \item{lon}{Longitude of station location in degree decimal format}
#'   \item{date}{Date}
#'   \item{time}{Time}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{day}{Day}
#'   \item{hour}{Hour}
#'   \item{qual}{Data quality}
#'   \item{weather}{The state of the atmosphere at a specific time.}
#'   \item{hmdx}{Humidex}
#'   \item{hmdx_flag}{Humidex data flag}
#'   \item{pressure}{Pressure (kPa)}
#'   \item{pressure_flag}{Pressure data flag}
#'   \item{rel_hum}{Relative humidity}
#'   \item{rel_hum_flag}{Relative humidity data flag}
#'   \item{temp}{Temperature}
#'   \item{temp_dew}{Dew Point Temperature}
#'   \item{temp_dew_flag}{Dew Point Temperatureflag}
#'   \item{visib}{Visibility (km)}
#'   \item{visib_flag}{Visibility data flag}
#'   \item{wind_chill}{Wind Chill}
#'   \item{wind_chill_flag}{Wind Chill flag}
#'   \item{wind_dir}{Wind Direction (10's of degrees)}
#'   \item{wind_dir_flag}{wind Direction Flag}
#'   \item{wind_spd}{Wind speed km/hr}
#'   \item{wind_spd_flag}{Wind speed flag}
#'   \item{elev}{Elevation (m)}
#'   \item{climate_id}{Climate identifier}
#'   \item{WMO_id}{World Meteorological Organization Identifier}
#'   \item{TC_id}{Transport Canada Identifier}
#' }
#' @source \url{http://climate.weather.gc.ca/index_e.html}
"pg"

#' Daily weather data for Kamloops
#'
#' Downloaded with \code{\link{weather}()}. Terms are more thoroughly defined
#' here \url{http://climate.weather.gc.ca/glossary_e.html}
#'
#' @format An example dataset of daily weather data for Kamloops:
#' \describe{
#'   \item{station_name}{Station name}
#'   \item{station_id}{Environment Canada's station ID number. Required for
#'   downloading station data.}
#'   \item{prov}{Province}
#'   \item{lat}{Latitude of station location in degree decimal format}
#'   \item{lon}{Longitude of station location in degree decimal format}
#'   \item{date}{Date}
#'   \item{year}{Year}
#'   \item{month}{Month}
#'   \item{day}{Day}
#'   \item{cool_deg_days}{Cool degree days}
#'   \item{cool_deg_days_flag}{Cool degree days flag}
#'   \item{dir_max_gust}{Direction of max wind gust}
#'   \item{dir_max_gust_flag}{Direction of max wind gust flag}
#'   \item{heat_deg_days}{Heat degree days}
#'   \item{heat_deg_days_flag}{Heat degree days flag}
#'   \item{max_temp}{Maximum temperature}
#'   \item{max_temp_flag}{Maximum temperature flag}
#'   \item{mean_temp}{Mean temperature}
#'   \item{mean_temp_flag}{Mean temperature flag}
#'   \item{min_temp}{Minimum temperature}
#'   \item{min_temp_flag}{Minimum temperature flag}
#'   \item{snow_grnd}{Snow on the ground (cm)}
#'   \item{snow_grnd_flag}{Snow on the ground flag}
#'   \item{spd_max_gust}{Speed of the max gust km/h}
#'   \item{spd_max_gust_flag}{Speed of the max gust flag}
#'   \item{total_precip}{Total precipitation (any form)}
#'   \item{total_precip_flag}{Total precipitation flag}
#'   \item{total_rain}{Total rain (any form)}
#'   \item{total_rain_flag}{Total rain flag}
#'   \item{total_snow}{Total snow (any form)}
#'   \item{total_snow_flag}{Total snow flag}
#'   \item{elev}{Elevation (m)}
#'   \item{climate_id}{Climate identifier}
#'   \item{WMO_id}{World Meteorological Organization Identifier}
#'   \item{TC_id}{Transport Canada Identifier}
#' }
#' @source \url{http://climate.weather.gc.ca/index_e.html}
"kamloops_day"

#' RFID Data on finch visits to feeders
#'
#' @format An example dataset of finch RFID data for interpolation:
#' \describe{
#'   \item{bird_id}{Bird ID number}
#'   \item{time}{Time}
#'   \item{feeder_id}{feeder ID}
#'   \item{species}{Species}
#'   \item{lat}{Latitude of station location in degree decimal format}
#'   \item{lon}{Longitude of station location in degree decimal format}
#' }
"finches"

#' Meaning of coded 'flags'
#'
#' A reference dataset containing 'flags' matched to their meaning. Data
#' downloaded using the \code{weather_dl()} function contains columns indicating
#' 'flags' these codes are presented here for interpretation.
#'
#' @format A data frame with 16 rows and 2 variables:
#' \describe{
#'   \item{code}{Flag code}
#'   \item{meaning}{Explanation of the code}
#' }
"flags"

#' Meaning of climate normal 'codes'
#'
#' A reference dataset containing `codes` matched to their meaning. Data
#' downloaded using the \code{normals_dl()} function contains columns indicating
#' `code`. These are presented here for interpretation.
#'
#' @format A data frame with 4 rows and 2 variables:
#' \describe{
#'   \item{code}{Code}
#'   \item{meaning}{Explanation of the code}
#' }
"codes"

#' Glossary of units and terms
#'
#' A reference dataset matching information on columns in data downloaded using
#' the \code{weather_dl()} function. Indicates the units of the data, and
#' contains a link to the ECCC glossary page explaining the measurement.
#'
#' @format A data frame with 77 rows and 5 variables:
#' \describe{
#'   \item{interval}{Data interval type, 'hour', 'day', or 'month'.}
#'   \item{ECCC_name}{Original column name when downloaded directly from ECCC}
#'   \item{weathercan_name}{R-compatible name given when downloaded with the
#'   \code{weather_dl()} function using the default argument \code{format =
#'   TRUE}.}
#'   \item{units}{Units of the measurement.}
#'   \item{ECCC_ref}{Link to the glossary or reference page on the ECCC
#'   website.}
#' }
"glossary"

#' Glossary of terms for Climate Normals
#'
#' A reference dataset matching information on columns in climate normals data
#' downloaded using the `normals_dl()` function. Indicates the names and
#' descriptions of different data measurements.
#'
#' @format A data frame with 18 rows and 3 variables:
#' \describe{
#'   \item{ECCC_name}{Original measurement type from ECCC}
#'   \item{weathercan_name}{R-compatible name given when downloaded with the
#'   `normals_dl()` function}
#'   \item{description}{Description of the measurement type from ECCC}
#' }
"glossary_normals"


#' List of climate normals measurements for each station
#'
#' A data frame listing the climate normals measurements available for each
#' station.
#'
#' @format A data frame with 113,325 rows and 4 variables:
#' \describe{
#'   \item{prov}{Province}
#'   \item{station_name}{Station Name}
#'   \item{climate_id}{Climate ID}
#'   \item{measurement}{Climate normals measurement available for this station}
#' }
"normals_measurements"
