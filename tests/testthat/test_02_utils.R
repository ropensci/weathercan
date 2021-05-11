context("Testing utility functions")

test_that("tz_offset() returns the correct tz", {
  expect_equal(tz_offset("America/Winnipeg"), "Etc/GMT+6")
  expect_equal(tz_offset("America/Vancouver"), "Etc/GMT+8")
  expect_equal(tz_offset("America/Winnipeg"), "Etc/GMT+6")
  expect_equal(tz_offset("America/Edmonton"), "Etc/GMT+7")
})

test_that("check_int() as expected", {
  expect_silent(check_int("hour"))
  expect_silent(check_int("day"))
  expect_silent(check_int("month"))
  expect_error(check_int("h"), "'interval' can only be")
  expect_error(check_int("year"), "'interval' can only be")
})

test_that("check_ids() as expected", {
  expect_silent(check_ids(1795, stations(), type = "station_id"))
  expect_silent(check_ids("301AR54", stations(), type = "climate_id"))
  expect_error(check_ids(1, stations(), type = "station_id"))
  expect_error(check_ids(1, stations(), type = "climate_id"))
  expect_error(check_ids(1795, stations(), type = "climate_id"),
               "Did you use 'station_id' by accident?")
})

test_that("check_normals() as expected", {
  expect_silent(check_normals("1981-2010"))
  expect_silent(check_normals("1111-1111"))
  expect_error(check_normals(" 1981-2010"), "text string in the format")
  expect_error(check_normals("1981-2010 "), "text string in the format")
  expect_error(check_normals("1981 2010"), "text string in the format")
  expect_error(check_normals("1981/2010"), "text string in the format")
  expect_error(check_normals(1981), "text string in the format")
})

test_that("get_check() as expected", {
  skip_if_offline()
  expect_error(get_check("https://climate.weather.gc.ca/error/dbdown_e.html"),
              "Service is currently down!")
  expect_error(get_check("http://httpbin.org/status/404", task = "test"),
              "Not Found (HTTP 404). Failed to test.", fixed = TRUE)
})
