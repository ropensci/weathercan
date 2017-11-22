context("Testing utility functions")

test_that("get_tz() returns the correct tz", {
  expect_equal(get_tz(coords = c(49.84847, -99.95009), etc = FALSE), "America/Winnipeg")
  expect_equal(get_tz(coords = c(49.84847, -99.95009), etc = TRUE), "Etc/GMT+6")

  expect_equal(get_tz(coords = c(49.246292, -123.116226), etc = FALSE), "America/Vancouver")
  expect_equal(get_tz(coords = c(49.246292, -123.116226), etc = TRUE), "Etc/GMT+8")

  expect_equal(get_tz(lat = 49.84847, lon = -99.95009, etc = FALSE), "America/Winnipeg")
  expect_equal(get_tz(lat = 49.84847, lon = -99.95009, etc = TRUE), "Etc/GMT+6")

  expect_equal(get_tz(lat = 49.246292, lon = -123.116226, etc = FALSE), "America/Vancouver")
  expect_equal(get_tz(lat = 49.246292, lon = -123.116226, etc = TRUE), "Etc/GMT+8")

})
