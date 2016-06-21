library(envirocan)
context("Weather data")



test_that("weather_dl downloads a data frame", {
  expect_silent(wd <- weather_dl(station_ID = 51423, date = as.Date("2014-01-01"), skip = 15, timeframe = "hour"))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 25)
  expect_equal(nrow(wd), 744)
  expect_is(wd$Date.Time, "character")
  expect_lt(length(wd[is.na(wd)]), length(wd[!is.na(wd)]))
})



test_that("weather returns a data frame", {
  expect_silent({weather(station_IDs = 51423, start = "2014-01-01", end = "2014-01-31")})
  expect_message({w <- weather(station_IDs = 51423, start = "2014-01-01", end = "2014-01-31", verbose = TRUE)})

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 35)
  expect_equal(nrow(w), 744)
  expect_is(w$station_name, "character")
  expect_is(w$prov, "factor")
  expect_lt(length(w[is.na(w)]), length(w[!is.na(w)]))
  expect_is(w$temp, "numeric")
})
