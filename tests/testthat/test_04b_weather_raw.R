context("weather_raw with vcr")

test_that("weather_html/raw (hour) download a data frame", {
  vcr::use_cassette("weather_html_hour", {
    expect_silent(wd <- weather_html(station_id = 51423,
                                     date = as.Date("2014-01-01"),
                                     interval = "hour"))
  })

  expect_silent(wd <- weather_raw(wd))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 28)
  expect_equal(nrow(wd), 744)
  expect_is(wd[, "Date/Time"], "character")
  expect_lt(length(data.frame(wd)[is.na(data.frame(wd))]),
            length(data.frame(wd)[!is.na(data.frame(wd))]))

})
