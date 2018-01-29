context("Testing utility functions")

test_that("tz_calc() returns the correct tz", {
  expect_equal(tz_calc(coords = c(49.84847, -99.95009), etc = FALSE),
               "America/Winnipeg")
  expect_equal(tz_calc(coords = c(49.84847, -99.95009), etc = TRUE),
               "Etc/GMT+6")

  expect_equal(tz_calc(coords = c(49.246292, -123.116226), etc = FALSE),
               "America/Vancouver")
  expect_equal(tz_calc(coords = c(49.246292, -123.116226), etc = TRUE),
               "Etc/GMT+8")

  expect_equal(tz_calc(lat = 49.84847, lon = -99.95009, etc = FALSE),
               "America/Winnipeg")
  expect_equal(tz_calc(lat = 49.84847, lon = -99.95009, etc = TRUE),
               "Etc/GMT+6")

  expect_equal(tz_calc(lat = 49.246292, lon = -123.116226, etc = FALSE),
               "America/Vancouver")
  expect_equal(tz_calc(lat = 49.246292, lon = -123.116226, etc = TRUE),
               "Etc/GMT+8")

})
