# weather by hour ---------------------------------------------------------
withr::local_options(list("weathercan.time.message" = TRUE))

test_that("weather_dl hour", {
  skip_on_cran()
  skip_if_offline()

  expect_silent(
    w <- weather_dl(
      station_ids = 51423,
      start = "2014-01-01",
      end = "2014-01-31",
      quiet = TRUE
    )
  )

  expect_snapshot_value(w, style = "json2", tolerance = 0.001)
})

test_that("weather_dl hour alerts to change in time handling", {
  skip_on_cran()
  withr::local_options(list("weathercan.time.message" = FALSE))

  expect_message(
    weather_dl(station_ids = 51423, start = "2014-01-01", end = "2014-01-31"),
    "As of weathercan v0.3.0 time display is"
  )
})

test_that("weather (hour) returns a data frame", {
  skip_on_cran()

  # Cached
  expect_silent(
    w <- weather_dl(
      station_ids = 51423,
      start = "2014-01-01",
      end = "2014-01-31",
      quiet = TRUE
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
  }) %>%
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
      interval = "hour",
      trim = TRUE
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

test_that("weather (hour) no data fails nicely", {
  skip_on_cran()
  expect_message(
    w1 <- weather_dl(
      c(1274, 1275),
      interval = "hour",
      start = "2012-11-01",
      end = "2012-11-30"
    ),
    "There are no data for some stations \\(1274\\)"
  )

  # Cached
  expect_message(
    w0 <- weather_dl(
      1274,
      interval = "hour",
      start = "2012-11-01",
      end = "2012-11-30"
    ),
    paste0(
      "There are no data for station 1274 for this ",
      "interval \\(hour\\)"
    )
  )

  expect_s3_class(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_s3_class(w1, "data.frame")
  expect_length(w1, length(kamloops))
  expect_equal(nrow(w1), 720)

  expect_message(
    w1 <- weather_dl(
      c(1275, 1001),
      interval = "hour",
      start = "2017-01-01",
      end = "2017-01-30"
    ),
    paste0(
      "There are no data for all stations \\(1275, 1001\\), ",
      "in this time range \\(2017-01-01 to 2017-01-30\\), ",
      "for this interval \\(hour\\)"
    )
  )

  # Cache
  expect_message(
    w0 <- weather_dl(
      1275,
      interval = "hour",
      start = "2017-01-01",
      end = "2017-01-30"
    ),
    paste0(
      "There are no data for station 1275, ",
      "in this time range \\(2017-01-01 to 2017-01-30\\), ",
      "for this interval \\(hour\\)"
    )
  )

  expect_s3_class(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
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
    "There are no data"
  )

  expect_silent(weather_dl(
    c(1274, 1274),
    interval = "hour",
    start = "2012-11-01",
    end = "2012-11-30",
    quiet = TRUE
  ))

  expect_message(
    weather_dl(
      c(1274, 1275),
      interval = "hour",
      start = "2012-11-01",
      end = "2012-11-30",
      verbose = TRUE
    ),
    "Getting station"
  ) %>%
    expect_message("No data for station") %>%
    expect_message("Getting station") %>%
    expect_message("Formatting station") %>%
    expect_message("Adding header data") %>%
    expect_message("Trimming missing") %>%
    expect_message("There are no data")
})

test_that("weather (hour) handles data with different numbers of columns", {
  skip_on_cran()
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

test_that("weather (hour) skips with message if end date < start date", {
  skip_on_cran()
  # Cached
  expect_message(
    weather_dl(station_ids = 51423, start = "2014-01-31", end = "2014-01-01"),
    "The end date "
  )
  expect_message(
    weather_dl(station_ids = 51423, end = "2012-01-01"),
    "The end date "
  )

  expect_message(w <- weather_dl(49909, end = "2007-04-20"), "The end date")
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

test_that("weather (invalid_interval) verifies error return when interval is invalid", {
  # The value of interval is invalid
  skip_on_cran()

  expect_error(
    weather_dl(
      c(6819, 51423),
      start = "2017-08-01",
      end = "2018-05-01",
      interval = "invalid_interval"
    ),
    "'interval' must be either 'hour', 'day', OR 'month'"
  )
})

test_that("weather (too_large_interval_length) verifies error return when interval character vector length is greather than 1", {
  # The values of interval are valid, but there are too many
  skip_on_cran()
  expect_error(
    weather_dl(
      c(6819, 51423),
      start = "2017-08-01",
      end = "2018-05-01",
      interval = c("hour", "day")
    ),
    "'interval' must be either 'hour', 'day', OR 'month'"
  )
})
