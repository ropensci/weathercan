
# weather_raw --------------------------------------------------------------
context("weather_raw")

test_that("weather_raw (hour) downloads a data frame", {
  expect_silent(wd <- weather_raw(station_id = 51423,
                                  date = as.Date("2014-01-01"),
                                  skip = 15, interval = "hour"))
  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 24)
  expect_equal(nrow(wd), 744)
  expect_is(wd[, "Date/Time"], "character")
  expect_lt(length(data.frame(wd)[is.na(data.frame(wd))]),
            length(data.frame(wd)[!is.na(data.frame(wd))]))
  #expect_true(stringi::stri_escape_unicode(wd[, "Data Quality"][1]) %in%
  #              c("\\u2021"))
})

test_that("weather_raw (day) downloads a data frame", {
  expect_silent(wd <- weather_raw(station_id = 51423,
                                  date = as.Date("2014-01-01"),
                                  skip = 24, interval = "day"))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 27)
  expect_equal(nrow(wd), 365)
  expect_is(wd[, "Date/Time"], "character")
  expect_lt(length(wd[is.na(wd)]), length(wd[!is.na(wd)]))
  # expect_true(stringi::stri_escape_unicode(wd[, "Data Quality"][1]) %in%
  #              c("\\u2021"))
})

test_that("weather_raw (month) downloads a data frame", {
  expect_silent(wd <- weather_raw(station_id = 43823,
                                  date = as.Date("2005-01-01"),
                                  skip = 17, interval = "month"))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 25)
  expect_equal(nrow(wd), 4)
  expect_is(wd[, "Date/Time"], "character")
  expect_lt(length(data.frame(wd)[is.na(data.frame(wd))]),
            length(data.frame(wd)[!is.na(data.frame(wd))]))
})
