context("Testing utility functions")

test_that("tz_offset() returns the correct tz", {
  expect_equal(tz_offset("America/Winnipeg"), "Etc/GMT+6")

  expect_equal(tz_offset("America/Vancouver"), "Etc/GMT+8")

  expect_equal(tz_offset("America/Winnipeg"), "Etc/GMT+6")

  expect_equal(tz_offset("America/Edmonton"), "Etc/GMT+7")

})

test_that("check_urls() as expected", {
  expect_silent(check_url("google.com"))
  expect_silent(check_url("https://dd.meteo.gc.ca/climate/observations/"))
  expect_error(check_url("google"))
  expect_error(check_url("https://dd.meteo.gc.ca/climate/obs/"))
})

test_that("check_ids() as expected", {
  expect_silent(check_ids(1795, stations, type = "station_id"))
  expect_silent(check_ids("301AR54", stations, type = "climate_id"))
  expect_error(check_ids(1, stations, type = "station_id"))
  expect_error(check_ids(1, stations, type = "climate_id"))
  expect_error(check_ids(1795, stations, type = "climate_id"),
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
