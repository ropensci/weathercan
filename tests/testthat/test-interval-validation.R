test_that("stations_search rejects invalid interval", {
  expect_error(
    stations_search(interval = "year")
  )

  expect_error(
    stations_search(interval = c("day", "month"))
  )
})

test_that("weather_interp rejects invalid interval", {
  expect_error(
    weather_interp(interval = "year")
  )

  expect_error(
    weather_interp(interval = c("day", "month"))
  )
})
