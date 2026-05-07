# weather by month --------------------------------------------------------

test_that("weather_dl month", {
  skip_on_cran()
  skip_if_offline()
  withr::local_options("weathercan.verbosity" = "quiet")

  expect_silent(
    w <- weather_dl(
      station_ids = 5401,
      start = "2014-01-01",
      end = "2014-05-01",
      interval = "month"
    )
  )

  expect_snapshot_value(w, style = "json2", tolerance = 0.001)
})

test_that("weather (month) returns a data frame", {
  skip_on_cran()
  expect_silent(
    w <- weather_dl(
      station_ids = 5401,
      start = "2014-01-01",
      end = "2014-05-01",
      interval = "month"
    )
  )

  ## Basics
  expect_s3_class(w, "data.frame")
  expect_length(w, 35)
  expect_equal(nrow(w), 5)
  expect_type(w$station_name, "character")
  expect_type(w$prov, "character")
  expect_type(w$mean_temp, "double")
  expect_type(w$mean_temp_flag, "character")
  expect_s3_class(w$date, "Date")
  expect_lt(
    length(data.frame(w)[is.na(data.frame(w))]),
    length(data.frame(w)[!is.na(data.frame(w))])
  )

  ## Data
  expect_equal(w$station_id[1], 5401)
  expect_equal(w$station_name[1], "MAGOG")
  expect_equal(w$climate_id[1], "7024440")
  expect_true(is.na(w$WMO_id[1]))
  expect_true(is.na(w$TC_id[1]))
  expect_equal(w$prov[1], "QC")
})

test_that("weather_dl month filters by month", {
  skip_on_cran()

  w <- weather_dl(
    station_ids = 5401,
    start = "2014-01-01",
    end = "2015-04-01",
    interval = "month",
    months = c(1, 10)
  )
  expect_equal(unique(w$month), c(1, 10))
})

test_that("weather (month) no data fails nicely", {
  skip_on_cran()

  # Cached
  expect_message(
    w0 <- weather_dl(
      station_ids = 51423,
      interval = "month",
      start = "2012-01-01",
      end = "2012-02-01"
    ),
    "Data unavailable for all stations"
  ) |>
    expect_message("51423") |>
    expect_message("Available Station Data") |>
    expect_message("station_id")

  expect_s3_class(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)

  expect_message(
    w1 <- weather_dl(
      station_ids = c(1275, 51423),
      interval = "month",
      start = "2012-01-01",
      end = "2012-02-01"
    ),
    "Data unavailable for some stations"
  ) |>
    expect_message("51423") |>
    expect_message("Available Station Data") |>
    expect_message("station_id") |>
    expect_message("Formatting messages") |>
    expect_message("Some variables") |>
    expect_message("Replaced") |>
    expect_message("Use 'string_as = NULL'")

  expect_s3_class(w1, "data.frame")
  expect_length(w1, 35)
  expect_equal(nrow(w1), 2)

  expect_message(
    w0 <- weather_dl(
      1274,
      interval = "month",
      start = "2017-01-01",
      end = "2017-02-01"
    ),
    "Data unavailable for all stations"
  ) |>
    expect_message("1274") |>
    expect_message("Available Station Data") |>
    expect_message("station_id")

  expect_s3_class(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)

  expect_message(
    w1 <- weather_dl(
      c(1274, 1275),
      interval = "month",
      start = "2017-01-01",
      end = "2017-02-01"
    ),
    "Data unavailable for all stations"
  ) |>
    expect_message("1274, 1275 \\(none for date range") |>
    expect_message("Available Station Data") |>
    expect_message("station_id")

  expect_s3_class(w1, "data.frame")
  expect_length(w1, 0)
  expect_equal(nrow(w1), 0)
})

test_that("weather (month) multiple stations", {
  skip_on_cran()
  expect_silent(
    w <- weather_dl(
      station_ids = c(5401, 5940),
      start = "2014-01-01",
      end = "2014-05-01",
      interval = "month"
    )
  )

  expect_equal(unique(w$station_name), c("MAGOG", "ST PRIME"))
  expect_equal(nrow(w[w$station_id == 5401, ]), nrow(w[w$station_id == 5940, ]))
})

test_that("weather (month) multiple stations (one NA)", {
  skip_on_cran()
  withr::local_options("weathercan.verbosity" = "quiet")

  # Cached
  expect_silent(
    w <- weather_dl(
      station_ids = c(5401, 51423),
      start = "2014-01-01",
      end = "2014-05-01",
      interval = "month"
    )
  )
  expect_equal(unique(w$station_name), c("MAGOG"))
})

test_that("weather (month) verbose and quiet", {
  skip_on_cran()

  # Cached
  expect_message(
    weather_dl(
      c(5401, 51423),
      interval = "month",
      start = "2017-01-01",
      end = "2017-02-01"
    ),
    "Data unavailable for some stations"
  ) |>
    expect_message("51423 \\(none for interval month") |>
    expect_message("Available Station Data:") |>
    expect_message("station_id")

  withr::local_options("weathercan.verbosity" = "quiet")
  expect_silent(weather_dl(
    c(5401, 51423),
    interval = "month",
    start = "2017-01-01",
    end = "2017-02-01"
  ))

  withr::local_options("weathercan.verbosity" = "verbose")
  weather_dl(
    c(5401, 51423),
    interval = "month",
    start = "2017-01-01",
    end = "2017-02-01"
  ) |>
    expect_message("Getting station: 5401") |>
    expect_message("Metadata") |>
    expect_message("Weather data") |>
    expect_message("Formatting") |>
    expect_message("Trimming missing values") |>
    expect_message("Data unavailable for some stations") |>
    expect_message("51423 \\(none for interval month") |>
    expect_message("Available Station Data:") |>
    expect_message("station_id")
})

test_that("weather (month) handles data with different numbers of columns", {
  skip_on_cran()
  expect_silent(
    d <- weather_dl(
      station_ids = 5217,
      start = "2016-01-01",
      end = "2018-12-01",
      interval = "month"
    )
  )

  expect_gt(nrow(d), 0)
  expect_length(d, 35)

  expect_silent(
    d <- weather_dl(
      c(4291, 27534),
      start = "1997-01-01",
      end = "2018-12-01",
      interval = 'month'
    )
  )

  expect_gt(nrow(d), 0)
  expect_length(d, 35)
  expect_gt(nrow(d[d$station_id == 4291, ]), 0)
  expect_gt(nrow(d[d$station_id == 27534, ]), 0)
})

test_that("weather (month) skips with message if end date < start date", {
  skip_on_cran()

  weather_dl(
    station_ids = 27534,
    start = "2005-01-31",
    end = "2005-01-01",
    interval = "month"
  ) |>
    expect_error("'end' date is earlier than the 'start' date")

  weather_dl(station_ids = 27534, end = "1995-01-01", interval = "month") |>
    expect_message("Data unavailable for all stations") |>
    expect_message("27534 \\(none for date range") |>
    suppressMessages()

  expect_message(
    w <- weather_dl(c(27534, 4291), end = "1928-11-10", interval = "month"),
    "Data unavailable for some stations"
  ) |>
    expect_message("27534 \\(none for date range") |>
    suppressMessages()

  expect_true(nrow(w) > 0)
})

test_that("weather (month) message if no time range and no end", {
  skip_on_cran()

  expect_message(
    weather_dl(station_ids = 5203, interval = "month", start = "2020-01-01"),
    "Data unavailable for all stations"
  ) |>
    expect_message("none for date range 2020-01-01 to today") |>
    expect_message("Available Station Data") |>
    expect_message("station_id")
})

test_that("weather (month) crosses the year line", {
  skip_on_cran()
  # Cached
  expect_silent(
    w <- weather_dl(
      station_id = 5401,
      interval = "month",
      start = "1999-11-01",
      end = "2000-03-05"
    )
  )

  expect_equal(min(w$date), as.Date("1999-11-01"))
  expect_equal(max(w$date), as.Date("2000-03-01"))
})


# list_cols ---------------------------------------------------------------

test_that("list_col=TRUE", {
  skip_on_cran()
  withr::local_options(list("weathercan.verbosity" = "quiet"))

  expect_equal(
    ncol(
      weather_dl(
        station_ids = 5401,
        start = "2017-01-01",
        end = "2017-01-15",
        interval = "month"
      ) |>
        tidyr::nest(data = -dplyr::any_of(c(names(m_names), "year")))
    ),
    ncol(weather_dl(
      station_ids = 5401,
      start = "2017-01-01",
      end = "2017-01-15",
      interval = "month",
      list_col = TRUE
    ))
  )
})
