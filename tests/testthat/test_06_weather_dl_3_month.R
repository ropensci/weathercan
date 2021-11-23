
# weather by month --------------------------------------------------------
context("weather by month")

test_that("weather (month) returns a data frame", {
  skip_on_cran()
  vcr::use_cassette("weather_month_5401", {
    expect_silent(w <- weather_dl(station_ids = 5401, start = "2014-01-01",
                                  end = "2014-05-01", interval = "month"))
  })

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
  expect_true(is.na(w$WMO_id[1]))
  expect_true(is.na(w$TC_id[1]))
  expect_equal(w$prov[1], "QC")

})

test_that("weather (month) no data fails nicely", {
  skip_on_cran()
  vcr::use_cassette("weather_month_1275_51423", {
    expect_silent(
      expect_message(w1 <- weather_dl(station_ids = c(1275, 51423),
                                      interval = "month",
                                      start = "2012-01-01",
                                      end = "2012-02-01"),
                     paste0("There are no data for some stations \\(51423\\), ",
                            "in this time range \\(2012-01-01 to 2012-02-01\\), ",
                            "for this interval \\(month\\)")))
  })
  # Cached
  expect_silent(
    expect_message(w0 <- weather_dl(station_ids = 51423,
                                    interval = "month",
                                    start = "2012-01-01",
                                    end = "2012-02-01"),
                   paste0("There are no data for station 51423 for this ",
                          "interval \\(month\\)")))

  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_is(w1, "data.frame")
  expect_length(w1, 35)
  expect_equal(nrow(w1), 2)

  vcr::use_cassette("weather_month_1274", {
    expect_silent(
      expect_message(w0 <- weather_dl(1274, interval = "month",
                                      start = "2017-01-01",
                                      end = "2017-02-01"),
                     paste0("There are no data for station 1274, in ",
                            "this time range \\(2017-01-01 to 2017-02-01\\).")))
  })
  #Cached
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
  skip_on_cran()
  vcr::use_cassette("weather_month_5401_5940", {
    expect_silent(w <- weather_dl(station_ids = c(5401, 5940),
                                  start = "2014-01-01",
                                  end = "2014-05-01",
                                  interval = "month"))
  })

  expect_equal(unique(w$station_name), c("MAGOG", "ST PRIME"))
  expect_equal(nrow(w[w$station_id == 5401,]), nrow(w[w$station_id == 5940,]))
})

test_that("weather (month) multiple stations (one NA)", {
  skip_on_cran()
  # Cached
  expect_message(expect_error(w <- weather_dl(station_ids = c(5401, 51423),
                                              start = "2014-01-01",
                                              end = "2014-05-01",
                                              interval = "month"), NA))
  expect_equal(unique(w$station_name), c("MAGOG"))
})

test_that("weather (month) verbose and quiet", {
  skip_on_cran()
  # Cached
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
  vcr::use_cassette("weather_month_5217", {
    expect_silent(d <- weather_dl(station_ids = 5217,
                                  start = "2016-01-01",
                                  end = "2018-12-01",
                                  interval = "month"))
  })
  expect_gt(nrow(d), 0)
  expect_length(d, 35)

  vcr::use_cassette("weather_month_4291_27534", {
    expect_silent(d <- weather_dl(c(4291, 27534),
                                  start = "1997-01-01",
                                  end = "2018-12-01",
                                  interval = 'month'))
  })
  expect_gt(nrow(d), 0)
  expect_length(d, 35)
  expect_gt(nrow(d[d$station_id == 4291,]), 0)
  expect_gt(nrow(d[d$station_id == 27534,]), 0)
})

test_that("weather (month) skips with message if end date < start date", {
  skip_on_cran()
  # Cached
  expect_message({weather_dl(station_ids = 27534, start = "2005-01-31",
                             end = "2005-01-01", interval = "month")},
                 "The end date ")
  expect_message({weather_dl(station_ids = 27534, end = "1995-01-01",
                             interval = "month")},
                 "The end date ")
  expect_message({w <- weather_dl(c(27534, 4291), end = "1928-11-10",
                                  interval = "month")},
                 "End date earlier")
  expect_true(nrow(w) > 0)
})

test_that("weather (month) crosses the year line", {
  skip_on_cran()
  # Cached
  expect_silent(w <- weather_dl(station_id = 5401, interval = "month",
                                start = "1999-11-01", end = "2000-03-05"))

  expect_equal(min(w$date), as.Date("1999-11-01"))
  expect_equal(max(w$date), as.Date("2000-03-01"))
})


# list_cols ---------------------------------------------------------------

context("Generating list_col")

test_that("list_col=TRUE and interval=hour groups on the right level", {
  skip_on_cran()
  # Cached
  if(packageVersion("tidyr") > "0.8.99") {
    expect_equal(ncol(weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-15", interval = "hour") %>%
                        tidyr::nest(key = -tidyr::one_of(names(m_names), "date"))),
                 ncol(weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-15", interval = "hour",
                                 list_col = TRUE)))
  } else {
    expect_equal(ncol(weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-15", interval = "hour") %>%
                        tidyr::nest(-dplyr::one_of(names(m_names), "date"))),
                 ncol(weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-15", interval = "hour",
                                 list_col = TRUE)))
  }

})

test_that("list_col=TRUE and interval=day groups on the right level", {
  skip_on_cran()
  if(packageVersion("tidyr") > "0.8.99") {
    expect_equal(ncol(weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-15", interval = "day") %>%
                        tidyr::nest(key = -dplyr::one_of(names(m_names), "month"))),
                 ncol(weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-15",
                                 interval = "day",
                                 list_col = TRUE)))
  } else {
    expect_equal(ncol(weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-15", interval = "day") %>%
                        tidyr::nest(-dplyr::one_of(names(m_names)), -month)),
                 ncol(weather_dl(station_ids = 51423, start = "2014-01-01",
                                 end = "2014-01-15",
                                 interval = "day",
                                 list_col = TRUE)))
  }

})

test_that("list_col=TRUE and interval=month groups on the right level", {
  skip_on_cran()
  if(packageVersion("tidyr") > "0.8.99") {
    expect_equal(ncol(weather_dl(station_ids = 5401, start = "2017-01-01",
                                 end = "2017-01-15", interval = "month") %>%
                        tidyr::nest(key = -dplyr::one_of(names(m_names), "year"))),
                 ncol(weather_dl(station_ids = 5401, start = "2017-01-01",
                                 end = "2017-01-15", interval = "month",
                                 list_col = TRUE)))
  } else {
    expect_equal(ncol(weather_dl(station_ids = 5401, start = "2017-01-01",
                                 end = "2017-01-15", interval = "month") %>%
                        tidyr::nest(-dplyr::one_of(names(m_names)), -year)),
                 ncol(weather_dl(station_ids = 5401, start = "2017-01-01",
                                 end = "2017-01-15", interval = "month",
                                 list_col = TRUE)))
  }
})


