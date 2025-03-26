
# weather by day ----------------------------------------------------------

test_that("weather_dl day", {
  skip_on_cran()
  skip_if_offline()

  expect_silent(w <- weather_dl(station_ids = 51423,
                                start = "2014-01-01", end = "2014-04-01",
                                interval = "day", quiet = TRUE))

  expect_snapshot_value(w, style = "json2", tolerance = 0.001)
})

test_that("weather (day) returns a data frame", {
  skip_on_cran()
  expect_silent(
    w <- weather_dl(station_ids = 51423,
                    start = "2014-01-01", end = "2014-04-01",
                    interval = "day", quiet = TRUE))

  ## Basics
  expect_s3_class(w, "data.frame")
  expect_length(w, 37)

  i <- lubridate::int_length(lubridate::interval(min(w$date),
                                                 max(w$date)))/60/60/24 + 1
  expect_equal(nrow(w), i)

  expect_type(w$station_name, "character")
  expect_type(w$prov, "character")
  expect_type(w$mean_temp, "double")
  expect_type(w$mean_temp_flag, "character")
  expect_s3_class(w$date, "Date")
  expect_lt(length(data.frame(w)[is.na(data.frame(w))]),
            length(data.frame(w)[!is.na(data.frame(w))]))

  ## Data
  expect_equal(w$station_id[1], 51423)
  expect_equal(w$station_name[1], "KAMLOOPS A")
  expect_equal(w$prov[1], "BC")

})

test_that("weather (day) gets all, one year", {
  skip_on_cran()

  expect_silent(w <- weather_dl(station_ids = 54398,
                                start = "2016-01-01", end = "2016-12-31",
                                interval = "day", trim = FALSE))

  expect_s3_class(w, "data.frame")
  expect_length(w, 37)
  expect_equal(nrow(w), 366)
  expect_equal(min(w$date), as.Date("2016-01-01"))
  expect_equal(max(w$date), as.Date("2016-12-31"))

  # Cached
  expect_silent(w <- weather_dl(station_ids = 54398,
                                end = "2016-04-01",
                                interval = "day", trim = FALSE))
  expect_equal(min(w$date), as.Date("2016-01-01"))
  expect_equal(max(w$date), as.Date("2016-04-01"))

})

test_that("weather (day) crosses the year line", {
  skip_on_cran()

  # Cached
  expect_silent(w <- weather_dl(station_id = 54398, interval = "day",
                                start = "2016-11-18", end = "2017-04-05"))

  expect_equal(min(w$date), as.Date("2016-11-18"))
  expect_equal(max(w$date), as.Date("2017-04-05"))
})

test_that("weather (day) trims NAs", {
  skip_on_cran()
  # Cached
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
  skip_on_cran()
  expect_message(w <- weather_dl(station_ids = c(51423, 54398),
                                 start = "2016-03-01", end = "2016-04-01",
                                 interval = "day"), "Some variables") %>%
    expect_message("Replaced all non-numeric")

  expect_equal(unique(w$station_name), c("KAMLOOPS A", "MUSKOKA SNOW"))
  expect_equal(nrow(w[w$station_id == 54398,]),
               nrow(w[w$station_id == 51423,]))
})

test_that("weather (day) no data fails nicely", {
  skip_on_cran()
  expect_message(w1 <- weather_dl(station_ids = c(42013, 51423),
                                  interval = "day",
                                  start = "2017-01-01",
                                  end = "2017-02-01"),
                 paste0("There are no data for some stations \\(42013\\), ",
                        "in this time range \\(")) %>%
    expect_message("Some variables") %>%
    expect_message("Replaced")

# Cached
  expect_message(w0 <- weather_dl(station_ids = 42013,
                                  interval = "day",
                                  start = "2017-01-01",
                                  end = "2017-02-01"),
                 paste0("There are no data for station 42013, ",
                        "in this time range"))

  expect_s3_class(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_s3_class(w1, "data.frame")
  expect_length(w1, 37)
  expect_equal(nrow(w1), 32)

  expect_message(w1 <- weather_dl(c(1274, 1275), interval = "day",
                                  start = "2017-01-01",
                                  end = "2017-03-01"),
                 paste0("There are no data for all stations ",
                        "\\(1274, 1275\\), in this time range ",
                        "\\(2017-01-01 to 2017-03-01\\)"))

  # Cached
  expect_message(w0 <- weather_dl(1274, interval = "day",
                                  start = "2017-01-01",
                                  end = "2017-03-01"),
                 paste0("There are no data for station 1274, in ",
                        "this time range \\(2017-01-01 to 2017-03-01\\)."))

  ## Basics
  expect_s3_class(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
  expect_s3_class(w1, "data.frame")
  expect_length(w1, 0)
  expect_equal(nrow(w1), 0)
})

test_that("weather (day) verbose and quiet", {
  skip_on_cran()

  # Cached
  expect_message(weather_dl(c(51423, 42013), interval = "day",
                            start = "2017-01-01", end = "2017-02-01"),
                 "Some variables have non-numeric values") %>%
    expect_message("Replaced all non-numeric") %>%
    expect_message("There are no data")

  # Cached
  expect_silent(weather_dl(c(51423, 42013), interval = "day",
                           start = "2017-01-01", end = "2017-02-01",
                           quiet = TRUE))

  # Warning about number to character
  expect_message(weather_dl(c(51423, 42013), interval = "day",
                            start = "2017-01-01", end = "2017-02-01",
                            verbose = TRUE),
                 "Getting station") %>%
    expect_message("Formatting station") %>%
    expect_message("Adding header data") %>%
    expect_message("Getting station") %>%
    expect_message("Formatting station") %>%
    expect_message("No data for station") %>%
    expect_message("Trimming missing values") %>%
    expect_message("There are no data for some stations") %>%
    expect_message("Some variables") %>%
    expect_message("Replaced") %>%
    expect_message("Examples") %>%
    expect_message("A tibble:")
})

test_that("weather (day) handles data with different numbers of columns", {
  skip_on_cran()
  expect_silent(d <- weather_dl(station_ids = 51423,
                                start = "2018-03-20",
                                end = "2018-04-10",
                                interval = "day", quiet = TRUE))

  expect_gt(nrow(d), 0)
  expect_length(d, 37)

  expect_silent(d <- weather_dl(c(6819, 51423),
                                start = "2017-08-01",
                                end = "2018-05-01",
                                interval = "day", quiet = TRUE))

  expect_gt(nrow(d), 0)
  expect_length(d, 37)
})

test_that("weather (day) skips with message if end date < start date", {
  skip_on_cran()
  expect_message(weather_dl(station_ids = 51423, start = "2014-01-31",
                            end = "2014-01-01", interval = "day"),
                 "The end date")

  expect_message(weather_dl(station_ids = 51423, end = "2012-01-01",
                            interval = "day"),
                 "The end date")

  expect_message(w <- weather_dl(c(4291, 51423), end = "1928-11-10",
                                 interval = "day"),
                 "The end date") %>%
    expect_message("End date earlier")
  expect_true(nrow(w) > 0)
})
