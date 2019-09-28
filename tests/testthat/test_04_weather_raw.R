
# weather_raw --------------------------------------------------------------
context("weather_raw")

test_that("weather_html/raw (hour) download a data frame", {
  expect_silent(wd <- weather_html(station_id = 51423,
                                   date = as.Date("2014-01-01"),
                                   interval = "hour"))
  expect_silent(wd <- weather_raw(wd))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 28)
  expect_equal(nrow(wd), 744)
  expect_is(wd[, "Date/Time"], "character")
  expect_lt(length(data.frame(wd)[is.na(data.frame(wd))]),
            length(data.frame(wd)[!is.na(data.frame(wd))]))
  #expect_true(stringi::stri_escape_unicode(wd[, "Data Quality"][1]) %in%
  #              c("\\u2021"))
})

test_that("weather_html/raw (day) download a data frame", {
  expect_silent(wd <- weather_html(station_id = 51423,
                                  date = as.Date("2014-01-01"),
                                  interval = "day"))
  expect_silent(wd <- weather_raw(wd))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 31)
  expect_equal(nrow(wd), 365)
  expect_is(wd[, "Date/Time"], "character")
  expect_lt(length(wd[is.na(wd)]), length(wd[!is.na(wd)]))
  # expect_true(stringi::stri_escape_unicode(wd[, "Data Quality"][1]) %in%
  #              c("\\u2021"))
})


test_that("weather_html/raw (month) download a data frame", {
  expect_silent(wd <- weather_html(station_id = 5401,
                                   date = as.Date("2017-01-01"),
                                   interval = "month"))
  expect_silent(wd <- weather_raw(wd))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 29)
  expect_equal(nrow(wd), 842)
  expect_is(wd[, "Date/Time"], "character")
  expect_lt(length(data.frame(wd)[is.na(data.frame(wd))]),
            length(data.frame(wd)[!is.na(data.frame(wd))]))

  # Expect 'I' flags converted to '^'
  expect_true("^" %in% wd$`Total Precip Flag`)
  expect_false("I" %in% wd$`Total Precip Flag`)
})
