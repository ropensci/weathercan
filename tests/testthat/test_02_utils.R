context("Testing utility functions")

test_that("tz_offset() returns the correct tz", {
  expect_equal(tz_offset("America/Winnipeg"), "Etc/GMT+6")

  expect_equal(tz_offset("America/Vancouver"), "Etc/GMT+8")

  expect_equal(tz_offset("America/Winnipeg"), "Etc/GMT+6")

  expect_equal(tz_offset("America/Edmonton"), "Etc/GMT+7")

})
