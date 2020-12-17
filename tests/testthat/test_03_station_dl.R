
# stations_dl ------------------------------------------------------------
context("stations_dl")

test_that("stations_normals() gets normals info", {
  skip_on_cran()
  skip_on_travis()
  skip_if_offline()
  expect_silent(n <- stations_normals(years = "1981-2010")) %>%
    expect_is("character")
  expect_gt(length(n), 500)
  expect_true(all(nchar(n) == 7))
})

test_that("stations_dl() runs and returns data", {
  skip_on_cran()
  skip_on_travis()
  skip_if_offline()

  if(getRversion() < "3.3.4") {
    expect_message(s <- stations_dl(),
                   paste0("Need R version 3.3.4 or greater to update the ",
                          "stations data"))
  } else if(getRversion() >= "3.3.4") {
    # If get message about not reachable, try again
    expect_error({s <- stations_dl()}, regexp = NA)
    expect_warning(stations_dl(url = "test.csv"))
    expect_is(s, "data.frame")
    expect_length(s, 14)
    expect_lt(length(data.frame(s)[is.na(data.frame(s))]),
              length(data.frame(s)[!is.na(data.frame(s))]))
    expect_is(s$prov, "character")
    expect_is(s$station_name, "character")
    expect_gt(nrow(s), 10)
    expect_equal(unique(s$interval), c("day", "hour", "month"))

    # Check content
    expect_equal(nrow(s[is.na(s$station_name),]), 0)
    expect_equal(nrow(s[is.na(s$station_id),]), 0)
    expect_equal(nrow(s[is.na(s$prov),]), 0)
    expect_true(all(table(s$station_id) == 3)) # One row per time interval type
  }
})


# stations_search ---------------------------------------------------------
context("stations_search")

test_that("stations_search 'name' returns correct format", {
  expect_error(stations_search())
  expect_error(stations_search(name = mean()))
  expect_is(stations_search("XXX"), "data.frame")
  expect_length(stations_search("XXX"), 14)

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

  ## Check numbers
  expect_message(stations_search(c(54, -122)),
                 paste0("The `name` argument looks like a pair of coordinates.",
                        " Did you mean `coords = c\\(54, -122\\)`?"))

  ## Check specific
  expect_equal(nrow(stations_search("Kamloops A$")), 5)
  expect_equal(unique(stations_search("Kamloops A$")$station_name),
               "KAMLOOPS A")
  expect_equal(sum(stations_search("Kamloops A$")$interval == "month"), 1)
  expect_equal(sum(stations_search("Kamloops A$")$interval == "hour"), 2)
})



test_that("stations_search 'coords' returns correct format", {
  expect_error(stations_search(coords = c("Hi")))
  expect_error(stations_search(coords = 44))
  expect_message(stn <- stations_search(coords = c(54, -122)))
  expect_is(stn, "data.frame")
  expect_length(stn, 15)
  expect_gt(nrow(stn), 0)
})

test_that("stations_search 'coords' returns correct data", {
  ## Check specific
  expect_equal(nrow(stn <- stations_search(coords = c(54, -122))), 10)
  expect_equal(stn$station_name[1], "UPPER FRASER")
  expect_equal(round(stn$distance[1], 5), 13.75226)
  expect_lt(max(stn$distance) - min(stn$distance), 10)

  ## Check with Kamloops
  k <- c(50.67452, -120.3273)
  expect_equal(nrow(stn <- stations_search(coords = k)), 26)
  expect_lt(max(stn$distance), 10)

  ## Check messages
  expect_message(stations_search(coords = c(54, -122)),
                 "No stations within 10km. Returning closest 10 stations.")

  ## Check distance
  expect_equal(nrow(stn <- stations_search(coords = k, dist = 30)), 58)
  expect_lt(max(stn$distance), 30)

  ## Check interval
  expect_equal(nrow(stations_search(coords = k,
                                    dist = 30, interval = "hour")), 3)
})

test_that("stations_search quiet/verbose", {

  expect_silent(stations_search(c(54, -122), quiet = TRUE))
  expect_silent(stations_search(coords = c(54, -122), quiet = TRUE))

  expect_message(stations_search(c(54, -122), verbose = TRUE),
                 "Searching by name")
  expect_message(stations_search("Kamloops", verbose = TRUE),
                 "Searching by name")
  expect_message(stations_search(coords = c(54, -122), verbose = TRUE),
                 "Calculating station distances")

})

test_that("stations_search 'starts_latest' returns correct data", {

  expect_equal(nrow(stations_search(name="Yoho", starts_latest = 1800)), 0)
  expect_gt(nrow(stations_search(name="Yoho", starts_latest = 1965)), 0)
  expect_error(stations_search(name="Yoho", starts_latest = "nineteen eighty-four"))

  expect_gt(nrow(stations_search(name="Yoho", starts_latest = 2000)),
            nrow(stations_search(name="Yoho", starts_latest = 1965)))

  expect_equal(stations_search(name="Yoho", starts_latest = "1984"),
        stations_search(name="Yoho", starts_latest = 1984) )
})

test_that("stations_search 'ends_earliest' returns correct data", {

  expect_equal(nrow(stations_search(name="Halifax", ends_earliest = 3000)), 0)
  expect_gt(nrow(stations_search(name="Halifax", ends_earliest = 1965)), 0)
  expect_error(stations_search(name="Halifax", ends_earliest = "nineteen eighty-four"))

  expect_lt(nrow(stations_search(name="Halifax", ends_earliest = 2000)),
            nrow(stations_search(name="Halifax", ends_earliest = 1965)))

  expect_equal(stations_search(name="Halifax", ends_earliest = "1984"),
               stations_search(name="Halifax", ends_earliest = 1984) )

})

test_that("stations_search 'starts_latest' and 'ends_earliest' together", {

  expect_equal(nrow(stations_search(name="Halifax",
                                    starts_latest = 2000,
                                    ends_earliest = 2005)), 3)

  expect_lt(nrow(stations_search(name="Halifax",
                                 starts_latest = 1940,
                                 ends_earliest = 2017)),
            nrow(stations_search(name="Halifax",
                                 starts_latest = 2000,
                                 ends_earliest = 2005)))

  expect_true(all(stations_search(name="Halifax",
                                  starts_latest = 2000,
                                  ends_earliest = 2001)$start <= 2000))
  expect_true(all(stations_search(name="Halifax",
                                  starts_latest = 2000,
                                  ends_earliest = 2001)$end >= 2001))

})

test_that("stations_search returns normals only", {
  expect_silent(s <- stations_search("Brandon", normals_only = TRUE))
  expect_gt(nrow(stations), nrow(s))
  expect_true(all(s$normals))
  expect_equal(unique(s$station_id), s$station_id)
})
