#' Basic API Query function for weather data
#'
#' @param station_id Character/Numeric
#' @param date Date
#' @param interval "hour", "day", "month"
#' @param format Character. "csv" to download weather data, "txt" for metadata.
#'
#' @returns httr2 response object
#'
#' @noRd
#' @examples
#' r <- get_html("5401", date = as.Date("2014-01-01"), interval = "month")
#' r
#' readr::read_csv(file = I(httr2::resp_body_string(r)))

get_html <- function(
  station_id,
  date = NULL,
  interval = "hour",
  format = "csv"
) {
  q <- list(
    format = format,
    stationID = station_id,
    timeframe = ifelse(interval == "hour", 1, ifelse(interval == "day", 2, 3)),
    Year = format(date, "%Y"),
    Month = format(date, "%m"),
    Day = "01",
    submit = 'Download+Data'
  )

  get_check(url = getOption("weathercan.urls.weather"), query = q)
}


#' API access and check for errors
#'
#' @param url Character. API endpoint.
#' @param query List. Query to send.
#'
#' @returns httr2 request object
#'
#' @noRd
#' @examples
#' q <- list(
#'   format = "txt",  # Metadata
#'   stationID = "5401",
#'   timeframe = 1,
#'   Year = "2016",
#'   Month = "01",
#'   Day = "01",
#'   submit = 'Download+Data'
#' )
#'
#' r <- get_check(url = getOption("weathercan.urls.weather"), query = q)
#' r
#' readr::read_lines(file = I(httr2::resp_body_string(r)))

get_check <- function(url, query = NULL) {
  req <- httr2::request(url)
  if (!is.null(query)) {
    req <- httr2::req_url_query(req, !!!query)
  }
  req <- httr2::req_perform(req)

  if (grepl("^https://climate.weather.gc.ca/error", req$url)) {
    wc_stop("Service is currently down!")
  } else if (any(grepl("error was found", httr2::resp_body_string(req)))) {
    wc_stop(
      "API could not fetch data with this query\n",
      "Please, open an issue on https://github.com/ropensci/weathercan/issues and share ",
      "the details of your attempted download: ",
      req$request$url
    )
  }
  req
}
