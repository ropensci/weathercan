# weather by month --------------------------------------------------------

test_that("weather_dl month", {
  skip_on_cran()
  skip_if_offline()

  expect_silent(
    w <- weather_dl(
      station_ids = 5401,
      start = "2014-01-01",
      end = "2014-05-01",
      interval = "month",
      quiet = TRUE
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

test_that("weather (month) no data fails nicely", {
  skip_on_cran()
  expect_message(
    w1 <- weather_dl(
      station_ids = c(1275, 51423),
      interval = "month",
      start = "2012-01-01",
      end = "2012-02-01"
    ),
    paste0(
      "There are no data for some stations \\(51423\\), ",
      "in this time range \\(2012-01-01 to 2012-02-01\\), ",
      "for this interval \\(month\\)"
    )
  ) %>%
    suppressMessages()

  # Cached
  expect_message(
    w0 <- weather_dl(
      station_ids = 51423,
      interval = "month",
      start = "2012-01-01",
      end = "2012-02-01"
    ),
    paste0(
      "There are no data for station 51423 for this ",
      "interval \\(month\\)"
    )
  ) %>%
    suppressMessages()

  expect_s3_class(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
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
    paste0(
      "There are no data for station 1274, in ",
      "this time range \\(2017-01-01 to 2017-02-01\\)."
    )
  ) %>%
    suppressMessages()

  #Cached
  expect_message(
    w1 <- weather_dl(
      c(1274, 1275),
      interval = "month",
      start = "2017-01-01",
      end = "2017-02-01"
    ),
    paste0(
      "There are no data for all stations ",
      "\\(1274, 1275\\), in this time range ",
      "\\(2017-01-01 to 2017-02-01\\)"
    )
  ) %>%
    suppressMessages()

  expect_s3_class(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
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

  # Cached
  expect_silent(
    w <- weather_dl(
      station_ids = c(5401, 51423),
      start = "2014-01-01",
      end = "2014-05-01",
      interval = "month",
      quiet = TRUE
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
    "There are no data"
  )

  expect_silent(weather_dl(
    c(5401, 51423),
    interval = "month",
    start = "2017-01-01",
    end = "2017-02-01",
    quiet = TRUE
  ))

  expect_message(
    weather_dl(
      c(5401, 51423),
      interval = "month",
      start = "2017-01-01",
      end = "2017-02-01",
      verbose = TRUE
    ),
    "Getting station"
  ) %>%
    expect_message("Formatting") %>%
    expect_message("Adding header") %>%
    expect_message("Getting station") %>%
    expect_message("No data") %>%
    expect_message("Trimming") %>%
    expect_message("There are no data")
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
  # Cached
  expect_message(
    weather_dl(
      station_ids = 27534,
      start = "2005-01-31",
      end = "2005-01-01",
      interval = "month"
    ),
    "The end date"
  ) %>%
    suppressMessages()
  expect_message(
    weather_dl(station_ids = 27534, end = "1995-01-01", interval = "month"),
    "The end date"
  ) %>%
    suppressMessages()
  expect_message(
    w <- weather_dl(c(27534, 4291), end = "1928-11-10", interval = "month"),
    "End date earlier"
  ) %>%
    suppressMessages()
  expect_true(nrow(w) > 0)
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

test_that("list_col=TRUE and interval=hour groups on the right level", {
  skip_on_cran()
  withr::local_options(list("weathercan.time.message" = TRUE))

  # Cached
  if (packageVersion("tidyr") > "0.8.99") {
    expect_equal(
      ncol(
        weather_dl(
          station_ids = 51423,
          start = "2014-01-01",
          end = "2014-01-15",
          interval = "hour",
          quiet = TRUE
        ) %>%
          tidyr::nest(key = -tidyr::one_of(names(m_names), "date"))
      ),
      ncol(weather_dl(
        station_ids = 51423,
        start = "2014-01-01",
        end = "2014-01-15",
        interval = "hour",
        list_col = TRUE,
        quiet = TRUE
      ))
    )
  } else {
    expect_equal(
      ncol(
        weather_dl(
          station_ids = 51423,
          start = "2014-01-01",
          end = "2014-01-15",
          interval = "hour",
          quiet = TRUE
        ) %>%
          tidyr::nest(-dplyr::one_of(names(m_names), "date"))
      ),
      ncol(weather_dl(
        station_ids = 51423,
        start = "2014-01-01",
        end = "2014-01-15",
        interval = "hour",
        list_col = TRUE,
        quiet = TRUE
      ))
    )
  }
})

test_that("list_col=TRUE and interval=day groups on the right level", {
  skip_on_cran()

  if (packageVersion("tidyr") > "0.8.99") {
    expect_equal(
      ncol(
        weather_dl(
          station_ids = 51423,
          start = "2014-01-01",
          end = "2014-01-15",
          interval = "day",
          quiet = TRUE
        ) %>%
          tidyr::nest(key = -dplyr::one_of(names(m_names), "month"))
      ),
      ncol(weather_dl(
        station_ids = 51423,
        start = "2014-01-01",
        end = "2014-01-15",
        interval = "day",
        list_col = TRUE,
        quiet = TRUE
      ))
    )
  } else {
    expect_equal(
      ncol(
        weather_dl(
          station_ids = 51423,
          start = "2014-01-01",
          end = "2014-01-15",
          interval = "day",
          quiet = TRUE
        ) %>%
          tidyr::nest(-dplyr::one_of(names(m_names)), -month)
      ),
      ncol(weather_dl(
        station_ids = 51423,
        start = "2014-01-01",
        end = "2014-01-15",
        interval = "day",
        list_col = TRUE,
        quiet = TRUE
      ))
    )
  }
})


test_that("list_col=TRUE and interval=month groups on the right level", {
  skip_on_cran()
  if (packageVersion("tidyr") > "0.8.99") {
    expect_equal(
      ncol(
        weather_dl(
          station_ids = 5401,
          start = "2017-01-01",
          end = "2017-01-15",
          interval = "month",
          quiet = TRUE
        ) %>%
          tidyr::nest(key = -dplyr::one_of(names(m_names), "year"))
      ),
      ncol(weather_dl(
        station_ids = 5401,
        start = "2017-01-01",
        end = "2017-01-15",
        interval = "month",
        list_col = TRUE,
        quiet = TRUE
      ))
    )
  } else {
    expect_equal(
      ncol(
        weather_dl(
          station_ids = 5401,
          start = "2017-01-01",
          end = "2017-01-15",
          interval = "month",
          quiet = TRUE
        ) %>%
          tidyr::nest(-dplyr::one_of(names(m_names)), -year)
      ),
      ncol(weather_dl(
        station_ids = 5401,
        start = "2017-01-01",
        end = "2017-01-15",
        interval = "month",
        list_col = TRUE,
        quiet = TRUE
      ))
    )
  }
})
