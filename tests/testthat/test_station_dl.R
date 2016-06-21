library(envirocan)
context("Station data")

test_that("stations_all() runs and returns data", {
  expect_error({s <- stations_all()}, regexp = NA)
  expect_warning(expect_error({stations_all(url = "test.csv")}))
  expect_is(s, "data.frame")
  expect_length(s, 12)
  expect_lt(length(s[is.na(s)]), length(s[!is.na(s)]))
  expect_is(s$prov, "factor")
  expect_is(s$station_name, "character")
  expect_gt(nrow(s), 10)
  expect_equal(unique(s$timeframe), c("hour", "day", "month"))
})

test_that("stations_search 'name' returns correct format", {
  expect_error(stations_search())
  expect_error(stations_search(name = mean()))
  expect_is(stations_search("XXX"), "data.frame")
  expect_length(stations_search("XXX"), 12)

})

test_that("stations_search 'name' returns correct data", {
  ## No returns
  expect_equal(nrow(stations_search("XXX")), 0)

  ## Check basic regex
  expect_gt(nrow(stations_search("Kamloops A")), nrow(stations_search("Kamloops A$")))

  ## Check multinames
  expect_equal(unique(stations_search(c("Kamloops", "Terrace"))$station_name), "KAMLOOPS RIDGEVIEW TERRACE")

  ## Check specific
  expect_equal(nrow(stations_search("Kamloops A$")), 5)
  expect_equal(unique(stations_search("Kamloops A$")$station_name), "KAMLOOPS A")
  expect_equal(sum(stations_search("Kamloops A$")$timeframe == "month"), 1)
  expect_equal(sum(stations_search("Kamloops A$")$timeframe == "hour"), 2)
})



test_that("stations_search 'coords' returns correct format", {
  expect_error(stations_search(coords = c("Hi")))
  expect_error(stations_search(coords = 44))
  expect_message(stn <- stations_search(coords = c(54, -122)))
  expect_is(stn, "data.frame")
  expect_length(stn, 13)
  expect_gt(nrow(stn), 0)
})

test_that("stations_search 'coords' returns correct data", {
  ## Check specific
  expect_equal(nrow(stn <- stations_search(coords = c(54, -122))), 12)
  expect_equal(stn$station_name[1], "UPPER FRASER")
  expect_equal(round(stn$distance[1], 5), 13.74476)
  expect_lt(max(stn$distance) - min(stn$distance), 10)

  ## Check with Kamloops
  #ggmap::geocode("Kamloops")
  k <- c(50.67452, -120.3273)
  expect_equal(nrow(stn <- stations_search(coords = k)), 26)
  expect_lt(max(stn$distance), 10)

  ## Check distance
  expect_equal(nrow(stn <- stations_search(coords = k, dist = 30)), 58)
  expect_lt(max(stn$distance), 30)

  ## Check timeframe
  expect_equal(nrow(stations_search(coords = k, dist = 30, timeframe = "hour")), 3)
})
