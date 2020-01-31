
# weather by hour ---------------------------------------------------------
context("weather by hour")

setup({options("weathercan.time.message" = TRUE)})

test_that("weather_dl hour alerts to change in time handling", {
  options("weathercan.time.message" = FALSE)

  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_01)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_01)
  }
  expect_message({weather_dl(station_ids = 51423, start = "2014-01-01",
                             end = "2014-01-31")},
                 "As of weathercan v0.3.0 time display is")
})

test_that("weather (hour) returns a data frame", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_01)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_01)
  }

  expect_silent(weather_dl(station_ids = 51423, start = "2014-01-01",
                           end = "2014-01-31"))

  expect_message(w <- weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-31", verbose = TRUE))

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 35)
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
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_01)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_01)
  }
  expect_silent({w <- weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-31",
                                 time_disp = "UTC")})
  expect_equal(w$time[1],
               as.POSIXct("2014-01-01 08:00:00", tz = "UTC"))
})

test_that("weather (hour) formats NL timezone", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_04)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_04)
  }
  expect_silent({w <- weather_dl(station_ids = 6556,
                                 start = "1965-01-01",
                                 end = "1965-01-15")}) %>%
    expect_is("data.frame")
  expect_equal(w$time[1],
               as.POSIXct("1965-01-01 00:30:00", tz = "UTC"))
})

test_that("weather (hour) multiple stations", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html",
                  mockery::mock(tests$weather_html_05a, tests$weather_html_05b, cycle = TRUE))
    mockery::stub(weather_dl, "meta_html",
                  mockery::mock(tests$meta_html_05a, tests$meta_html_05b, cycle = TRUE))
  }

  expect_silent({w <- weather_dl(station_ids = c(42203, 49909),
                                 start = "2017-09-01", end = "2017-09-15")})

  expect_equal(unique(w$station_name), c("KAMLOOPS AUT", "BRANDON RCS"))
  expect_equal(nrow(w[w$station_id == 42203,]), nrow(w[w$station_id == 49909,]))
})

test_that("weather (hour) formats time_disp with multiple stations", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html",
                  mockery::mock(tests$weather_html_05a, tests$weather_html_05b, cycle = TRUE))
    mockery::stub(weather_dl, "meta_html",
                  mockery::mock(tests$meta_html_05a, tests$meta_html_05b, cycle = TRUE))
  }

  expect_silent({w <- weather_dl(c(42203, 49909), start = "2017-09-01",
                                 end = "2017-09-30", time_disp = "UTC")})
  expect_equal(lubridate::tz(w$time[1]), "UTC")
  expect_equal(w$time[1], as.POSIXct("2017-09-01 08:00:00", tz = "UTC"))
  expect_equal(w$time[w$station_id == 49909][1],
               as.POSIXct("2017-09-01 06:00:00", tz = "UTC"))

  expect_silent({w <- weather_dl(c(42203, 49909),
                                 start = "2017-09-01",
                                 end = "2017-09-30")})
  expect_equal(dplyr::filter(w, station_id == 42203)$time[1],
               as.POSIXct("2017-09-01 00:00:00", tz = "UTC"))
  expect_equal(dplyr::filter(w, station_id == 49909)$time[1],
               as.POSIXct("2017-09-01 00:00:00", tz = "UTC"))
})

test_that("weather (hour) gets all", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_06)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_06)
  }
  expect_silent(w <- weather_dl(station_ids = 50821,
                                start = "2018-01-01",
                                end = "2018-01-02",
                                interval = "hour", trim = FALSE))
  expect_is(w, "data.frame")
  expect_length(w, 35)
  expect_equal(nrow(w), 48)
  expect_equal(w$date[1], as.Date("2018-01-01"))
  expect_equal(w$date[nrow(w)], as.Date("2018-01-02"))
})

test_that("weather (hour) trims NAs", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html",
                  mockery::mock(tests$weather_html_07a, tests$weather_html_07b, cycle = TRUE))
    mockery::stub(weather_dl, "meta_html", tests$meta_html_07)
  }
  expect_equal(nrow(weather_dl(6819, start = "2017-08-20", end = "2017-09-01",
                               interval = "hour", trim = TRUE)), 96)
  expect_equal(nrow(weather_dl(6819, start = "2017-08-20", end = "2017-09-01",
                               interval = "hour", trim = FALSE)), 312)
})

test_that("weather (hour) no data fails nicely", {
  skip_on_cran()
  expect_message(w0 <- weather_dl(1274, interval = "hour",
                                  start = "2012-11-01",
                                  end = "2012-12-01"),
                 paste0("There are no data for station 1274 for this ",
                        "interval \\(hour\\)"))
  expect_message(w1 <- weather_dl(c(1274, 1275),
                                  interval = "hour",
                                  start = "2012-11-01",
                                  end = "2012-12-01"),
                 paste0("There are no data for some stations \\(1274\\)"))

  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_is(w1, "data.frame")
  expect_length(w1, 35)
  expect_equal(nrow(w1), 744)

  expect_message(
    w0 <- weather_dl(1275, interval = "hour",
                     start = "2017-01-01", end = "2017-02-01"),
    paste0("There are no data for station 1275, ",
           "in this time range \\(2017-01-01 to 2017-02-01\\), ",
           "for this interval \\(hour\\)"))

  expect_message(
    w1 <- weather_dl(c(1275, 1001), interval = "hour",
                     start = "2017-01-01", end = "2017-02-01"),
    paste0("There are no data for all stations \\(1275, 1001\\), ",
           "in this time range \\(2017-01-01 to 2017-02-01\\), ",
           "for this interval \\(hour\\)"))

  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_is(w1, "data.frame")
  expect_length(w1, 0)
  expect_equal(nrow(w1), 0)
})

test_that("weather (hour) verbose and quiet", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html",
                  mockery::mock(tests$weather_html_08a, tests$weather_html_08b, cycle = TRUE))
    mockery::stub(weather_dl, "meta_html",
                  mockery::mock(tests$meta_html_08a, tests$meta_html_08b, cycle = TRUE))
  }

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
  expect_silent(d <- weather_dl(station_ids = 51423,
                                start = "2018-03-20", end = "2018-04-10"))
  expect_gt(nrow(d), 0)

  expect_silent(d <- weather_dl(c(6819, 51423),
                                start = "2017-08-01",
                                end = "2018-05-01", interval = "hour"))
  expect_gt(nrow(d), 0)
})

test_that("weather (hour) skips with message if end date < start date", {

  expect_message({weather_dl(station_ids = 51423, start = "2014-01-31",
                            end = "2014-01-01")}, "The end date ")

  expect_message({weather_dl(station_ids = 51423, end = "2012-01-01")},
                 "The end date ")

  skip_on_cran()
  expect_message({w <- weather_dl(c(42203, 49909), end = "2006-04-20")},
                 "End date earlier")
  expect_true(nrow(w) > 0)
})

test_that("weather (hour) crosses the year line", {
  skip_on_cran()
  expect_silent(w <- weather_dl(station_id = 27534, interval = "hour",
                                start = "2001-12-01", end = "2002-01-05"))
  expect_equal(min(w$date), as.Date("2001-12-01"))
  expect_equal(max(w$date), as.Date("2002-01-05"))
})

# weather by day ----------------------------------------------------------
context("weather by day")

test_that("weather (day) returns a data frame", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_09)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_09)
  }
  expect_message({weather_dl(station_ids = 51423,
                             start = "2016-01-01",
                             end = "2014-04-01",
                             interval = "day")})
  expect_message({w <- weather_dl(station_ids = 51423,
                                  start = "2014-01-01",
                                  end = "2014-04-01",
                                  interval = "day",
                                  verbose = TRUE)})

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 37)

  i <- lubridate::int_length(lubridate::interval(min(w$date),
                                                 max(w$date)))/60/60/24 + 1
  expect_equal(nrow(w), i)

  expect_is(w$station_name, "character")
  expect_is(w$prov, "character")
  expect_is(w$mean_temp, "numeric")
  expect_is(w$mean_temp_flag, "character")
  expect_is(w$date, "Date")
  expect_lt(length(data.frame(w)[is.na(data.frame(w))]),
            length(data.frame(w)[!is.na(data.frame(w))]))

  ## Data
  expect_equal(w$station_id[1], 51423)
  expect_equal(w$station_name[1], "KAMLOOPS A")
  expect_equal(w$prov[1], "BC")
})

test_that("weather (day) gets all, one year", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_10a)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_10)
  }

  expect_silent(weather_dl(station_ids = 54398, interval = "day",
                           start = "2016-01-01", end = "2016-12-31",
                           trim = FALSE))
  expect_message(w <- weather_dl(station_ids = 54398, interval = "day",
                                 start = "2016-01-01", end = "2016-12-31",
                                 trim = FALSE, verbose = TRUE))

  expect_is(w, "data.frame")
  expect_length(w, 37)
  expect_equal(nrow(w), 366)
  expect_equal(min(w$date), as.Date("2016-01-01"))
  expect_equal(max(w$date), as.Date("2016-12-31"))

  expect_silent(w <- weather_dl(station_ids = 54398,
                                end = "2016-04-01",
                                interval = "day", trim = FALSE))
  expect_equal(min(w$date), as.Date("2016-01-01"))
  expect_equal(max(w$date), as.Date("2016-04-01"))

  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html",
                  mockery::mock(tests$weather_html_10a, tests$weather_html_10b))
    mockery::stub(weather_dl, "meta_html", tests$meta_html_10)
  }

  expect_silent(w <- weather_dl(station_ids = 54398,
                                start = "2016-01-01", end = "2017-12-31",
                                interval = "day", trim = FALSE))
  expect_equal(min(w$date), as.Date("2016-01-01"))
  expect_equal(max(w$date), as.Date("2017-12-31"))

})


test_that("weather (day) crosses the year line", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_10a)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_10)
  }
  expect_silent(w <- weather_dl(station_id = 54398, interval = "day",
                                start = "2016-11-18", end = "2017-04-05"))
  expect_equal(min(w$date), as.Date("2016-11-18"))
  expect_equal(max(w$date), as.Date("2017-04-05"))
})

test_that("weather (day) trims NAs", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_10a)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_10)
  }

  expect_silent(w1 <- weather_dl(station_ids = 54398, interval = "day",
                                 start = "2016-01-01", end = "2016-12-31",
                                 trim = FALSE))
  expect_silent(w2 <- weather_dl(station_ids = 54398, interval = "day",
                                 start = "2016-01-01", end = "2016-12-31",
                                 trim = TRUE))

  expect_gte(nrow(w1), nrow(w2))
  expect_gte(length(data.frame(w1)[is.na(data.frame(w1))]),
             length(data.frame(w2)[is.na(data.frame(w2))]))
})

test_that("weather (day) mutliple stations", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html",
                  mockery::mock(tests$weather_html_09, tests$weather_html_10a))
    mockery::stub(weather_dl, "meta_html",
                  mockery::mock(tests$meta_html_09, tests$meta_html_10))
  }
  expect_message(w <- weather_dl(station_ids = c(51423, 54398),
                                 start = "2016-03-01", end = "2016-04-01",
                                 interval = "day"))

  expect_equal(unique(w$station_name), c("KAMLOOPS A", "MUSKOKA SNOW"))
  expect_equal(nrow(w[w$station_id == 54398,]),
               nrow(w[w$station_id == 51423,]))
})

test_that("weather (day) no data fails nicely", {
  skip_on_cran()

  expect_silent(
    expect_message(w0 <- weather_dl(station_ids = 42013,
                                    interval = "day",
                                    start = "2017-01-01",
                                    end = "2017-02-01"),
                   paste0("There are no data for station 42013, ",
                          "in this time range")))
  expect_silent(
    expect_message(w1 <- weather_dl(station_ids = c(42013, 51423),
                                    interval = "day",
                                    start = "2017-01-01",
                                    end = "2017-02-01"),
                   paste0("There are no data for some stations \\(42013\\), ",
                          "in this time range \\(")))

  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_is(w1, "data.frame")
  expect_length(w1, 37)
  expect_equal(nrow(w1), 32)

  expect_silent(
    expect_message(w0 <- weather_dl(1274, interval = "day",
                                    start = "2017-01-01",
                                    end = "2017-03-01"),
                   paste0("There are no data for station 1274, in ",
                          "this time range \\(2017-01-01 to 2017-03-01\\).")))
  expect_silent(
    expect_message(w1 <- weather_dl(c(1274, 1275), interval = "day",
                                    start = "2017-01-01",
                                    end = "2017-03-01"),
                   paste0("There are no data for all stations ",
                          "\\(1274, 1275\\), in this time range ",
                          "\\(2017-01-01 to 2017-03-01\\)")))

  ## Basics
  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_is(w1, "data.frame")
  expect_length(w1, 0)
  expect_equal(nrow(w1), 0)
})

test_that("weather (day) verbose and quiet", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html",
                  mockery::mock(tests$weather_html_09, tests$weather_html_10a,
                                cycle = TRUE))
    mockery::stub(weather_dl, "meta_html",
                  mockery::mock(tests$meta_html_09, tests$meta_html_10,
                                cycle = TRUE))
  }

  expect_message(weather_dl(c(51423, 54398), interval = "day",
                            start = "2017-01-01", end = "2017-02-01"))

  expect_silent(weather_dl(c(51423, 54398), interval = "day",
                           start = "2017-01-01", end = "2017-02-01",
                           quiet = TRUE))

  # Warning about number to character
  expect_message(weather_dl(c(51423, 54398), interval = "day",
                            start = "2017-01-01", end = "2017-02-01",
                            verbose = TRUE),
                 "<31")
})

test_that("weather (day) handles data with different numbers of columns", {
  skip_on_cran()
  expect_error(expect_message(d <- weather_dl(station_ids = 51423,
                                              start = "2018-03-20",
                                              end = "2018-04-10",
                                              interval = "day")), NA)
  expect_gt(nrow(d), 0)
  expect_length(d, 37)

  expect_error(expect_message(d <- weather_dl(c(6819, 51423),
                                              start = "2017-08-01",
                                              end = "2018-05-01",
                                              interval = "day")), NA)
  expect_gt(nrow(d), 0)
  expect_length(d, 37)


  skip_on_cran()
  expect_error(expect_message(d <- weather_dl(c(4291, 27534),
                                              start = "1997-01-01",
                                              interval = 'day')), NA)
  expect_gt(nrow(d), 0)
  expect_length(d, 37)
  expect_gt(nrow(d[d$station_id == 4291,]), 0)
  expect_gt(nrow(d[d$station_id == 27534,]), 0)
})

test_that("weather (day) skips with message if end date < start date", {

  expect_message({weather_dl(station_ids = 51423, start = "2014-01-31",
                             end = "2014-01-01", interval = "day")},
                 "The end date ")

  expect_message({weather_dl(station_ids = 51423, end = "2012-01-01",
                             interval = "day")},
                 "The end date ")

  skip_on_cran()
  expect_message({w <- weather_dl(c(51423, 4291), end = "1928-11-10",
                                  interval = "day")},
                 "End date earlier")
  expect_true(nrow(w) > 0)
})

# weather by month --------------------------------------------------------
context("weather by month")

test_that("weather (month) returns a data frame", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_11)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_11)
  }

  expect_silent(w <- weather_dl(station_ids = 5401, start = "2014-01-01",
                                end = "2014-05-01", interval = "month"))

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 35)
  expect_equal(nrow(w), 5)
  expect_is(w$station_name, "character")
  expect_is(w$prov, "character")
  expect_is(w$mean_temp, "numeric")
  expect_is(w$mean_temp_flag, "character")
  expect_is(w$date, "Date")
  expect_lt(length(data.frame(w)[is.na(data.frame(w))]),
            length(data.frame(w)[!is.na(data.frame(w))]))

  ## Data
  expect_equal(w$station_id[1], 5401)
  expect_equal(w$station_name[1], "MAGOG")
  expect_equal(w$climate_id[1], "7024440")
  expect_equal(w$WMO_id[1], "")
  expect_equal(w$TC_id[1], "")
  expect_equal(w$prov[1], "QC")

})

test_that("weather (month) no data fails nicely", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_12)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_12)
  }

  expect_silent(
    expect_message(w0 <- weather_dl(station_ids = 51423,
                                    interval = "month",
                                    start = "2012-01-01",
                                    end = "2012-02-01"),
                   paste0("There are no data for station 51423 for this ",
                          "interval \\(month\\)")))

  skip_on_cran()

  expect_silent(
    expect_message(w1 <- weather_dl(station_ids = c(51423, 1275),
                                    interval = "month",
                                    start = "2012-01-01",
                                    end = "2012-02-01"),
                   paste0("There are no data for some stations \\(51423\\), ",
                          "in this time range \\(2012-01-01 to 2012-02-01\\), ",
                          "for this interval \\(month\\)")))
  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_is(w1, "data.frame")
  expect_length(w1, 35)
  expect_equal(nrow(w1), 2)

  expect_silent(
    expect_message(w0 <- weather_dl(1274, interval = "month",
                                    start = "2017-01-01",
                                    end = "2017-02-01"),
                   paste0("There are no data for station 1274, in ",
                          "this time range \\(2017-01-01 to 2017-02-01\\).")))
  expect_silent(
    expect_message(w1 <- weather_dl(c(1274, 1275), interval = "month",
                                    start = "2017-01-01",
                                    end = "2017-02-01"),
                   paste0("There are no data for all stations ",
                          "\\(1274, 1275\\), in this time range ",
                          "\\(2017-01-01 to 2017-02-01\\)")))

  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_is(w1, "data.frame")
  expect_length(w1, 0)
  expect_equal(nrow(w1), 0)
})

test_that("weather (month) multiple stations", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html",
                  mockery::mock(tests$weather_html_11, tests$weather_html_13,
                                cycle = TRUE))
    mockery::stub(weather_dl, "meta_html",
                  mockery::mock(tests$meta_html_11, tests$meta_html_13,
                                cycle = TRUE))
  }

  expect_silent(w <- weather_dl(station_ids = c(5401, 5940),
                                start = "2014-01-01",
                                end = "2014-05-01",
                                interval = "month"))

  expect_equal(unique(w$station_name), c("MAGOG", "ST PRIME"))
  expect_equal(nrow(w[w$station_id == 5401,]), nrow(w[w$station_id == 5940,]))
})

test_that("weather (month) multiple stations (one NA)", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html",
                  mockery::mock(tests$weather_html_11, tests$weather_html_12,
                                cycle = TRUE))
    mockery::stub(weather_dl, "meta_html",
                  mockery::mock(tests$meta_html_11, tests$meta_html_12,
                                cycle = TRUE))
  }

  expect_message(expect_error(w <- weather_dl(station_ids = c(5401, 51423),
                                              start = "2014-01-01",
                                              end = "2014-05-01",
                                              interval = "month"), NA))
  expect_equal(unique(w$station_name), c("MAGOG"))
})

test_that("weather (month) verbose and quiet", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html",
                  mockery::mock(tests$weather_html_11, tests$weather_html_12,
                                cycle = TRUE))
    mockery::stub(weather_dl, "meta_html",
                  mockery::mock(tests$meta_html_11, tests$meta_html_12,
                                cycle = TRUE))
  }

  expect_message(weather_dl(c(5401, 51423), interval = "month",
                            start = "2017-01-01", end = "2017-02-01"))

  expect_silent(weather_dl(c(5401, 51423), interval = "month",
                           start = "2017-01-01", end = "2017-02-01",
                           quiet = TRUE))

  expect_message(weather_dl(c(5401, 51423), interval = "month",
                            start = "2017-01-01", end = "2017-02-01",
                            verbose = TRUE),
                 "(Getting station: 51423\\n)")
})

test_that("weather (month) handles data with different numbers of columns", {

  skip_on_cran()
  expect_silent(d <- weather_dl(station_ids = 5217,
                                start = "2016-01-01",
                                end = "2018-12-01",
                                interval = "month"))
  expect_gt(nrow(d), 0)
  expect_length(d, 35)

  expect_silent(d <- weather_dl(c(4291, 27534),
                                start = "1997-01-01",
                                end = "2018-12-01",
                                interval = 'month'))
  expect_gt(nrow(d), 0)
  expect_length(d, 35)
  expect_gt(nrow(d[d$station_id == 4291,]), 0)
  expect_gt(nrow(d[d$station_id == 27534,]), 0)
})

test_that("weather (month) skips with message if end date < start date", {

  expect_message({weather_dl(station_ids = 27534, start = "2005-01-31",
                             end = "2005-01-01", interval = "month")},
                 "The end date ")

  expect_message({weather_dl(station_ids = 27534, end = "1995-01-01",
                             interval = "month")},
                 "The end date ")

  skip_on_cran()
  expect_message({w <- weather_dl(c(27534, 4291), end = "1928-11-10",
                                  interval = "month")},
                 "End date earlier")
  expect_true(nrow(w) > 0)
})


test_that("weather (month) crosses the year line", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_11)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_11)
  }
  expect_silent(w <- weather_dl(station_id = 5401, interval = "month",
                                start = "1999-11-01", end = "2000-03-05"))
  expect_equal(min(w$date), as.Date("1999-11-01"))
  expect_equal(max(w$date), as.Date("2000-03-01"))
})



# list_cols ---------------------------------------------------------------

context("Generating list_col")

test_that("list_col=TRUE and interval=hour groups on the right level", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_01)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_01)
  }
  if(packageVersion("tidyr") > "0.8.99") {
    expect_equal(ncol(weather_dl(station_ids = c(51423), start = "2014-01-01",
                                 end = "2014-04-15", interval = "hour") %>%
                        tidyr::nest(key = -tidyr::one_of(names(m_names), "date"))),
                 ncol(weather_dl(station_ids = c(51423), start = "2014-04-01",
                                 end = "2014-04-15", interval = "hour",
                                 list_col = TRUE)))
  } else {
    expect_equal(ncol(weather_dl(station_ids = c(51423), start = "2014-01-01",
                                 end = "2014-01-15", interval = "hour") %>%
                        tidyr::nest(-dplyr::one_of(names(m_names), "date"))),
                 ncol(weather_dl(station_ids = c(51423), start = "2014-01-01",
                                 end = "2014-01-15", interval = "hour",
                                 list_col = TRUE)))
  }
})

test_that("list_col=TRUE and interval=day groups on the right level", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_02)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_02)
  }
  if(packageVersion("tidyr") > "0.8.99") {
    expect_equal(ncol(weather_dl(station_ids = c(51423), start = "2014-01-01",
                                 end = "2014-01-15", interval = "day") %>%
                        tidyr::nest(key = -dplyr::one_of(names(m_names), "month"))),
                 ncol(weather_dl(station_ids = c(51423), start = "2014-01-01",
                                 end = "2014-01-15",
                                 interval = "day",
                                 list_col = TRUE)))
  } else {
    expect_equal(ncol(weather_dl(station_ids = c(51423), start = "2014-01-01",
                                 end = "2014-01-15", interval = "day") %>%
                        tidyr::nest(-dplyr::one_of(names(m_names)), -month)),
                 ncol(weather_dl(station_ids = c(51423), start = "2014-01-01",
                                 end = "2014-01-15",
                                 interval = "day",
                                 list_col = TRUE)))
  }
})

test_that("list_col=TRUE and interval=month groups on the right level", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_03)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_03)
  }
  if(packageVersion("tidyr") > "0.8.99") {
    expect_equal(ncol(weather_dl(station_ids = c(5401), start = "2017-01-01",
                                 end = "2017-01-15", interval = "month") %>%
                        tidyr::nest(key = -dplyr::one_of(names(m_names), "year"))),
                 ncol(weather_dl(station_ids = c(5401), start = "2017-01-01",
                                 end = "2017-01-15", interval = "month",
                                 list_col = TRUE)))
  } else {
    expect_equal(ncol(weather_dl(station_ids = c(5401), start = "2017-01-01",
                                 end = "2017-01-15", interval = "month") %>%
                        tidyr::nest(-dplyr::one_of(names(m_names)), -year)),
                 ncol(weather_dl(station_ids = c(5401), start = "2017-01-01",
                                 end = "2017-01-15", interval = "month",
                                 list_col = TRUE)))
  }
})


