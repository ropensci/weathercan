
# stations_all ------------------------------------------------------------
context("stations_all")

test_that("stations_all() runs and returns data", {
  skip_on_cran()
  expect_error({s <- stations_all()}, regexp = NA)
  expect_warning(expect_error({stations_all(url = "test.csv")}))
  expect_is(s, "data.frame")
  expect_length(s, 12)
  expect_lt(length(data.frame(s)[is.na(data.frame(s))]),
            length(data.frame(s)[!is.na(data.frame(s))]))
  expect_is(s$prov, "factor")
  expect_is(s$station_name, "character")
  expect_gt(nrow(s), 10)
  expect_equal(unique(s$interval), c("hour", "day", "month"))

  # Check content
  expect_equal(nrow(s[is.na(s$station_name),]), 0)
  expect_equal(nrow(s[is.na(s$station_id),]), 0)
  expect_equal(nrow(s[is.na(s$prov),]), 0)
  expect_true(all(table(s$station_id) == 3)) # One row per time interval type
})


# stations_search ---------------------------------------------------------
context("stations_search")

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
  expect_gt(nrow(stations_search("Kamloops A")),
            nrow(stations_search("Kamloops A$")))

  ## Check multinames
  expect_equal(unique(stations_search(c("Kamloops", "Terrace"))$station_name),
               "KAMLOOPS RIDGEVIEW TERRACE")

  ## Check specific
  expect_equal(nrow(stations_search("Kamloops A$")), 5)
  expect_equal(unique(stations_search("Kamloops A$")$station_name), "KAMLOOPS A")
  expect_equal(sum(stations_search("Kamloops A$")$interval == "month"), 1)
  expect_equal(sum(stations_search("Kamloops A$")$interval == "hour"), 2)
})




test_that("stations_search quiet/verbose", {
  expect_message(stations_search("Kamloops", verbose = TRUE), "Searching by name")

})
