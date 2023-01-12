
# weather by hour ---------------------------------------------------------
context("weather by hour")

setup({options("weathercan.time.message" = TRUE)})

test_that("weather_dl hour alerts to change in time handling", {
  skip_on_cran()
  options("weathercan.time.message" = FALSE)

  vcr::use_cassette("weather_hour_51423_2014-01", {
    expect_message({weather_dl(station_ids = 51423, start = "2014-01-01",
                               end = "2014-01-31")},
                   "As of weathercan v0.3.0 time display is")
  })
})

test_that("weather (hour) returns a data frame", {
  skip_on_cran()
  # Cached
  expect_silent(weather_dl(station_ids = 51423, start = "2014-01-01",
                           end = "2014-01-31"))
  expect_message(w <- weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-31", verbose = TRUE))

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, length(kamloops))
  expect_equal(nrow(w), 744)
  expect_is(w$station_name, "character")
  expect_is(w$prov, "character")
  expect_is(w$temp, "numeric")
  expect_is(w$temp_flag, "character")
  expect_is(w$date, "Date")
  expect_is(w$time, "POSIXct")
  expect_lt(length(data.frame(w)[is.na(data.frame(w))]),
            length(data.frame(w)[!is.na(data.frame(w))]))

  ## Data
  expect_equal(w$station_id[1], 51423)
  expect_equal(w$station_name[1], "KAMLOOPS A")
  expect_equal(w$prov[1], "BC")
  expect_equal(w$time[1], as.POSIXct("2014-01-01 00:00:00", tz = "UTC"))
  #expect_equal(w$qual[1], paste0("Partner data that is not subject to review ",
  #                               "by the National Climate Archives"))
})


test_that("weather (hour) formats timezone display", {
  skip_on_cran()
  # Cached
  expect_silent({w <- weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-31",
                                 time_disp = "UTC")})
  expect_equal(w$time[1],
               as.POSIXct("2014-01-01 08:00:00", tz = "UTC"))
})

test_that("weather (hour) formats NL timezone", {
  skip_on_cran()
  vcr::use_cassette("weather_hour_6556_1965", {
    expect_silent({w <- weather_dl(station_ids = 6556,
                                   start = "1965-01-01",
                                   end = "1965-01-15")}) %>%
      expect_is("data.frame")
  })

  expect_equal(w$time[1],
               as.POSIXct("1965-01-01 00:30:00", tz = "UTC"))
})

test_that("weather (hour) multiple stations", {
  skip_on_cran()
  vcr::use_cassette("weather_hour_42203_49909_2017-09", {
    expect_silent({w <- weather_dl(station_ids = c(42203, 49909),
                                   start = "2017-09-01", end = "2017-09-15")})
  })

  expect_equal(unique(w$station_name), c("KAMLOOPS AUT", "BRANDON RCS"))
  expect_equal(nrow(w[w$station_id == 42203,]), nrow(w[w$station_id == 49909,]))

  # Time format (cached)
  expect_silent({w <- weather_dl(station_ids = c(42203, 49909),
                                 start = "2017-09-01", end = "2017-09-15",
                                 time_disp = "UTC")})

  expect_equal(lubridate::tz(w$time[1]), "UTC")
  expect_equal(w$time[1], as.POSIXct("2017-09-01 08:00:00", tz = "UTC"))
  expect_equal(w$time[w$station_id == 49909][1],
               as.POSIXct("2017-09-01 06:00:00", tz = "UTC"))

  # Cached
  expect_silent({w <- weather_dl(c(42203, 49909),
                                 start = "2017-09-01",
                                 end = "2017-09-30")})

  expect_equal(dplyr::filter(w, station_id == 42203)$time[1],
               as.POSIXct("2017-09-01 00:00:00", tz = "UTC"))
  expect_equal(dplyr::filter(w, station_id == 49909)$time[1],
               as.POSIXct("2017-09-01 00:00:00", tz = "UTC"))

})

test_that("weather (hour) gets all", {
  skip_on_cran()
  vcr::use_cassette("weather_hour_50821_2018", {
    expect_silent(w <- weather_dl(station_ids = 50821,
                                  start = "2018-01-01",
                                  end = "2018-01-02",
                                  interval = "hour", trim = FALSE))
  })
  expect_is(w, "data.frame")
  expect_length(w, length(kamloops))
  expect_equal(nrow(w), 48)
  expect_equal(w$date[1], as.Date("2018-01-01"))
  expect_equal(w$date[nrow(w)], as.Date("2018-01-02"))
})

test_that("weather (hour) trims NAs", {
  skip_on_cran()
  vcr::use_cassette("weather_hour_6819_2017", {
    expect_equal(nrow(weather_dl(6819, start = "2017-08-20", end = "2017-09-01",
                                 interval = "hour", trim = TRUE)), 96)
  })
  # Cached
  expect_equal(nrow(weather_dl(6819, start = "2017-08-20", end = "2017-09-01",
                               interval = "hour", trim = FALSE)), 312)
})

test_that("weather (hour) no data fails nicely", {
  skip_on_cran()
  vcr::use_cassette("weather_hour_1274_1275_2012-11", {
    expect_message(w1 <- weather_dl(c(1274, 1275),
                                    interval = "hour",
                                    start = "2012-11-01",
                                    end = "2012-11-30"),
                   paste0("There are no data for some stations \\(1274\\)"))
  })
  # Cached
  expect_message(w0 <- weather_dl(1274, interval = "hour",
                                  start = "2012-11-01",
                                  end = "2012-11-30"),
                 paste0("There are no data for station 1274 for this ",
                        "interval \\(hour\\)"))

  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_is(w1, "data.frame")
  expect_length(w1, length(kamloops))
  expect_equal(nrow(w1), 720)

  vcr::use_cassette("weather_hour_1275_1001_2017-01", {
    expect_message(
      w1 <- weather_dl(c(1275, 1001), interval = "hour",
                       start = "2017-01-01", end = "2017-01-30"),
      paste0("There are no data for all stations \\(1275, 1001\\), ",
             "in this time range \\(2017-01-01 to 2017-01-30\\), ",
             "for this interval \\(hour\\)"))
  })

  # Cache
  expect_message(
    w0 <- weather_dl(1275, interval = "hour",
                     start = "2017-01-01", end = "2017-01-30"),
    paste0("There are no data for station 1275, ",
           "in this time range \\(2017-01-01 to 2017-01-30\\), ",
           "for this interval \\(hour\\)"))

  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_is(w1, "data.frame")
  expect_length(w1, 0)
  expect_equal(nrow(w1), 0)
})

test_that("weather (hour) verbose and quiet", {
  skip_on_cran()
  # Cached
  expect_message(weather_dl(c(1275, 1001), interval = "hour",
                            start = "2017-01-01", end = "2017-01-31"))

  expect_silent(weather_dl(c(1275, 1001), interval = "hour",
                           start = "2017-01-01", end = "2017-01-31",
                           quiet = TRUE))

  expect_message(weather_dl(c(1275, 1001), interval = "hour",
                            start = "2017-01-01", end = "2017-01-31",
                            verbose = TRUE),
                 "(Getting station: 1275\\n)")
})

test_that("weather (hour) handles data with different numbers of columns", {
  skip_on_cran()
  vcr::use_cassette("weather_hour_6819_51423_2017-08_2018-05", {
    expect_silent(d <- weather_dl(c(6819, 51423),
                                  start = "2017-08-01",
                                  end = "2018-05-01", interval = "hour"))
    expect_gt(nrow(d), 0)
  })
})

test_that("weather (hour) skips with message if end date < start date", {
  skip_on_cran()
  # Cached
  expect_message({weather_dl(station_ids = 51423, start = "2014-01-31",
                             end = "2014-01-01")}, "The end date ")
  expect_message({weather_dl(station_ids = 51423, end = "2012-01-01")},
                 "The end date ")

  vcr::use_cassette("weather_hour_42203_49909_2006-04", {
    expect_message({w <- weather_dl(c(42203, 49909), end = "2007-04-20")},
                   "End date earlier")
  })
  expect_true(nrow(w) > 0)
})

test_that("weather (hour) crosses the year line", {
  skip_on_cran()
  vcr::use_cassette("weather_hour_27534_2001-12_2002-01", {
    expect_silent(w <- weather_dl(station_id = 27534, interval = "hour",
                                  start = "2001-12-01", end = "2002-01-05"))
  })
  expect_equal(min(w$date), as.Date("2001-12-01"))
  expect_equal(max(w$date), as.Date("2002-01-05"))
})
