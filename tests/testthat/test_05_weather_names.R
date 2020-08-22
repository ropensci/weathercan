# weather names ---------------------------------------------------------
context("Data column names")

# Test and alert only if ECCC changes any of the column names
test_that("weather_raw() hour column names as expected", {
  skip_if_offline()
  skip_on_cran()
  wd <- weather_html(station_id = 51423,
                     date = as.Date("2014-01-01"),
                     interval = "hour") %>%
    weather_raw()

  expect_true(all(names(wd) %in% c(w_names$hour,
                                   "Latitude (y)", "Longitude (x)",
                                   "Station Name", "Climate ID")))

  # Data quality no longer present
  temp <- w_names$hour[w_names$hour != "Data Quality"]
  expect_true(all(temp %in% names(wd)))
})

test_that("weather_raw() day column names as expected", {
  skip_if_offline()
  skip_on_cran()
  wd <- weather_html(station_id = 51423,
                     date = as.Date("2014-01-01"),
                     interval = "day") %>%
    weather_raw()

  expect_true(all(names(wd) %in% c(w_names$day,
                                   "Latitude (y)", "Longitude (x)",
                                   "Station Name", "Climate ID")))
  expect_true(all(w_names$day %in% names(wd)))
})

test_that("weather_raw() month column names as expected", {
  skip_if_offline()
  skip_on_cran()
  wd <- weather_html(station_id = 43823,
                     date = as.Date("2005-01-01"),
                     interval = "month") %>%
    weather_raw()

  expect_true(all(names(wd) %in% c(w_names$month,
                                   "Latitude (y)", "Longitude (x)",
                                   "Station Name", "Climate ID")))
  expect_true(all(w_names$month %in% names(wd)))
})

