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

  get_check(
    url = getOption("weathercan.urls.weather"),
    query = q,
    task = "access historical weather data"
  )
}


get_check <- function(url, query = NULL, task = NULL) {
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
      "the details of your attempted download."
    )
  }
  req
}
