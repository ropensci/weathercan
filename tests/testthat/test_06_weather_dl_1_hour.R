# weather by hour ---------------------------------------------------------
withr::local_options(list("weathercan.time.message" = TRUE))

test_that("weather_dl hour", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options(list("weathercan.verbosity" = "quiet"))
  expect_silent(
    w <- weather_dl(
      station_ids = 51423,
      start = "2014-01-01",
      end = "2014-01-31"
    )
  )

  expect_snapshot_value(w, style = "json2", tolerance = 0.001)
})

test_that("weather_dl hour alerts to change in time handling", {
  skip_on_cran()
  withr::local_options(list("weathercan.time.message" = FALSE))

  expect_message(
    weather_dl(
      station_ids = 51423,
      start = "2014-01-01",
      end = "2014-01-31"
    ),
    "As of weathercan v0.3.0 time display is"
  )
})

test_that("weather (hour) returns a data frame", {
  skip_on_cran()
  withr::local_options(list("weathercan.verbosity" = "quiet"))

  # Cached
  expect_silent(
    w <- weather_dl(
      station_ids = 51423,
      start = "2014-01-01",
      end = "2014-01-31"
    )
  )

  ## Basics
  expect_s3_class(w, "data.frame")
  expect_length(w, length(kamloops))
  expect_equal(nrow(w), 744)
  expect_type(w$station_name, "character")
  expect_type(w$prov, "character")
  expect_type(w$temp, "double")
  expect_type(w$temp_flag, "character")
  expect_s3_class(w$date, "Date")
  expect_s3_class(w$time, "POSIXct")
  expect_lt(
    length(data.frame(w)[is.na(data.frame(w))]),
    length(data.frame(w)[!is.na(data.frame(w))])
  )

  ## Data
  expect_equal(w$station_id[1], 51423)
  expect_equal(w$station_name[1], "KAMLOOPS A")
  expect_equal(w$prov[1], "BC")
  expect_equal(w$time[1], as.POSIXct("2014-01-01 00:00:00", tz = "UTC"))
})

test_that("weather (hour) formats timezone display", {
  skip_on_cran()

  # Cached
  expect_silent({
    w <- weather_dl(
      station_ids = 51423,
      start = "2014-01-01",
      end = "2014-01-31",
      time_disp = "UTC"
    )
  })
  expect_equal(w$time[1], as.POSIXct("2014-01-01 08:00:00", tz = "UTC"))
})

test_that("weather (hour) formats NL timezone", {
  skip_on_cran()

  expect_silent({
    w <- weather_dl(
      station_ids = 6556,
      start = "1965-01-01",
      end = "1965-01-15"
    )
  }) |>
    expect_s3_class("data.frame")
  expect_equal(w$time[1], as.POSIXct("1965-01-01 00:30:00", tz = "UTC"))
})

test_that("weather (hour) multiple stations", {
  skip_on_cran()

  expect_silent(
    w <- weather_dl(
      station_ids = c(42203, 49909),
      start = "2017-09-01",
      end = "2017-09-15"
    )
  )

  expect_equal(unique(w$station_name), c("KAMLOOPS AUT", "BRANDON RCS"))
  expect_equal(
    nrow(w[w$station_id == 42203, ]),
    nrow(w[w$station_id == 49909, ])
  )

  # Time format (cached)
  expect_silent(
    w <- weather_dl(
      station_ids = c(42203, 49909),
      start = "2017-09-01",
      end = "2017-09-15",
      time_disp = "UTC"
    )
  )

  expect_equal(lubridate::tz(w$time[1]), "UTC")
  expect_equal(w$time[1], as.POSIXct("2017-09-01 08:00:00", tz = "UTC"))
  expect_equal(
    w$time[w$station_id == 49909][1],
    as.POSIXct("2017-09-01 06:00:00", tz = "UTC")
  )
})

test_that("weather (hour) gets all", {
  skip_on_cran()
  expect_silent(
    w <- weather_dl(
      station_ids = 50821,
      start = "2018-01-01",
      end = "2018-01-02",
      interval = "hour",
      trim = FALSE
    )
  )
  expect_s3_class(w, "data.frame")
  expect_length(w, length(kamloops))
  expect_equal(nrow(w), 48)
  expect_equal(w$date[1], as.Date("2018-01-01"))
  expect_equal(w$date[nrow(w)], as.Date("2018-01-02"))
})

test_that("weather (hour) trims NAs", {
  skip_on_cran()

  expect_equal(
    nrow(weather_dl(
      6819,
      start = "2017-08-20",
      end = "2017-09-01",
      interval = "hour"
    )),
    96
  )

  # Cached
  expect_equal(
    nrow(weather_dl(
      6819,
      start = "2017-08-20",
      end = "2017-09-01",
      interval = "hour",
      trim = FALSE
    )),
    312
  )
})

test_that("weather_dl hour filters by month", {
  skip_on_cran()

  w <- weather_dl(
    station_ids = 51423,
    start = "2014-01-01",
    end = "2015-10-31",
    months = c(1, 10)
  )
  expect_equal(unique(w$month), c(1, 10))
})

test_that("weather (hour) no data fails nicely", {
  skip_on_cran()

  # One stn - no int
  expect_message(
    w0 <- weather_dl(
      1274,
      interval = "hour",
      start = "2012-11-01",
      end = "2012-11-30"
    ),
    "Data unavailable for all stations"
  ) |>
    expect_message("1274 \\(none for interval hour\\)") |>
    expect_message("Available Station Data:") |>
    expect_message("station_id")

  expect_s3_class(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)

  # One stn of multiple - no int
  expect_message(
    w1 <- weather_dl(
      c(1274, 1275),
      interval = "hour",
      start = "2012-11-01",
      end = "2012-11-30"
    ),
    "Data unavailable for some stations"
  ) |>
    expect_message("1274 \\(none for interval hour\\)") |>
    expect_message("Available Station Data:") |>
    expect_message("station_id")

  expect_s3_class(w1, "data.frame")
  expect_length(w1, length(kamloops))
  expect_equal(nrow(w1), 720)

  # One no time
  expect_message(
    w0 <- weather_dl(
      1275,
      interval = "hour",
      start = "2017-01-01",
      end = "2017-01-30"
    ),
    "Data unavailable for all stations"
  ) |>
    expect_message("1275 \\(none for date range") |>
    expect_message("Available Station Data:") |>
    expect_message("station_id")

  expect_s3_class(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)

  # Mult no time
  expect_message(
    w1 <- weather_dl(
      c(1275, 1001),
      interval = "hour",
      start = "2017-01-01",
      end = "2017-01-30"
    ),
    "Data unavailable for all stations"
  ) |>
    expect_message("1275, 1001 \\(none for date range") |>
    expect_message("Available Station Data:") |>
    expect_message("station_id")

  expect_s3_class(w1, "data.frame")
  expect_length(w1, 0)
  expect_equal(nrow(w1), 0)
})

test_that("weather (hour) verbose and quiet", {
  skip_on_cran()

  # Cached
  expect_message(
    weather_dl(
      c(1274, 1275),
      interval = "hour",
      start = "2012-11-01",
      end = "2012-11-30"
    ),
    "Data unavailable for some stations"
  ) |>
    expect_message("1274") |>
    expect_message("Available Station Data:") |>
    expect_message("station_id")

  withr::local_options(list("weathercan.verbosity" = "quiet"))
  expect_silent(weather_dl(
    c(1274, 1274),
    interval = "hour",
    start = "2012-11-01",
    end = "2012-11-30"
  ))

  withr::local_options(list("weathercan.verbosity" = "verbose"))
  expect_message(
    weather_dl(
      c(1274, 1275),
      interval = "hour",
      start = "2012-11-01",
      end = "2012-11-30"
    ),
    "Getting station: 1275"
  ) |>
    expect_message("Metadata") |>
    expect_message("Weather data") |>
    expect_message("Formatting") |>
    expect_message("Trimming missing values before and after") |>
    expect_message("Data unavailable for some stations") |>
    expect_message("1274") |>
    expect_message("Available Station Data:") |>
    expect_message("station_id")
})

test_that("weather (hour) handles data with different numbers of columns", {
  skip_on_cran()
  withr::local_options(list(weathercan.verbosity = "quiet"))
  expect_silent(
    d <- weather_dl(
      c(6819, 51423),
      start = "2017-08-01",
      end = "2018-05-01",
      interval = "hour"
    )
  )
  expect_gt(nrow(d), 0)
})

test_that("weather (hour) message if end date < start date", {
  skip_on_cran()
  # Cached
  expect_error(
    weather_dl(station_ids = 51423, start = "2014-01-31", end = "2014-01-01"),
    "'end' date is earlier than the 'start' date"
  )
  expect_message(
    weather_dl(station_ids = 51423, end = "2012-01-01"),
    "Data unavailable for all stations"
  ) |>
    expect_message("none for date range to 2012-01-01") |>
    expect_message("Available Station Data") |>
    expect_message("station_id")
})

test_that("weather (hour) crosses the year line", {
  skip_on_cran()

  expect_silent(
    w <- weather_dl(
      station_id = 27534,
      interval = "hour",
      start = "2001-12-01",
      end = "2002-01-05"
    )
  )

  expect_equal(min(w$date), as.Date("2001-12-01"))
  expect_equal(max(w$date), as.Date("2002-01-05"))
})

test_that("weather_dl() invalid interval", {
  expect_error(
    weather_dl(
      c(6819, 51423),
      start = "2017-08-01",
      end = "2018-05-01",
      interval = "invalid_interval"
    ),
    "'interval' can only have 1 of 'hour', 'day', or 'month'"
  )

  expect_error(
    weather_dl(
      c(6819, 51423),
      start = "2017-08-01",
      end = "2018-05-01",
      interval = c("hour", "day")
    ),
    "'interval' can only have 1 of 'hour', 'day', or 'month'"
  )
})

test_that("list_col=TRUE", {
  skip_on_cran()
  withr::local_options(list(
    "weathercan.time.message" = TRUE,
    "weathercan.verbosity" = "quiet"
  ))

  # Cached
  expect_equal(
    ncol(
      weather_dl(
        station_ids = 51423,
        start = "2014-01-01",
        end = "2014-01-15",
        interval = "day"
      ) |>
        tidyr::nest(data = c(-dplyr::any_of(c(names(m_names), "date"))))
    ),
    ncol(weather_dl(
      station_ids = 51423,
      start = "2014-01-01",
      end = "2014-01-15",
      interval = "day",
      list_col = TRUE
    ))
  )
})
