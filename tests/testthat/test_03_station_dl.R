
# stations_dl() ------------------------------------------------------------

test_that("stations_dl() requires R 3.3.4", {
  # Can't test stations_dl because requires depth = 2 which creates problems:
  # https://github.com/r-lib/mockery/issues
  skip_on_cran()
  mockery::stub(stations_dl_internal, 'getRversion', package_version("3.3.3"))
  expect_message(stations_dl_internal(), "Need R version")
})

test_that("stations_dl() requires lutz and sf", {
  skip_on_cran()
  mockery::stub(stations_dl_internal, 'requireNamespace',  mockery::mock(FALSE, FALSE))
  expect_error(stations_dl_internal(), "Package 'lutz' and its dependency, 'sf'")
})

test_that("stations_dl() errors appropriately", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("sf")
  skip_if_not_installed("lutz")

  bkup <- getOption("weathercan.urls.stations")
  options(weathercan.urls.stations = "https://httpstat.us/404")
  expect_error(stations_dl(), "Not Found (HTTP 404).", fixed = TRUE)
  options(weathercan.urls.stations = bkup)
})

vcr::use_cassette("stations_normals", {
  test_that("stations_normals() gets normals info", {
    skip_on_cran()

    expect_silent(n <- stations_normals()) %>%
      expect_s3_class("data.frame")

    expect_gt(nrow(n), 1500)
    expect_named(n, c("station_name", "climate_id",
                      "normals_1991_2020",
                      "normals_1981_2010",
                      "normals_1971_2000"))
  })
})

test_that("stations_meta() returns metadata", {
  skip_on_cran()
  expect_type(stations_meta(), "list") %>%
    expect_named(c("ECCC_modified", "weathercan_modified"))

  expect_s3_class(stations_meta()$ECCC_modified, "POSIXct")
  expect_s3_class(stations_meta()$weathercan_modified, "Date")
})



test_that("stations_dl() runs and updates data", {
  skip_if_not_installed("sf")
  skip_if_not_installed("lutz")
  skip_on_cran()
  skip_if_offline()

  mockery::stub(stations_dl_internal, "utils::askYesNo", TRUE)
  mockery::stub(stations_dl_internal, "stations_file", file.path("stations.rds"))
  expect_message(stations_dl_internal(internal = FALSE), "Stations data saved") %>%
    expect_message("According to Environment Canada") %>%
    expect_message("Environment Canada Disclaimers")
  expect_type(s <- readRDS("stations.rds"), "list") %>%
    expect_length(2)
  expect_s3_class(s$stn, "data.frame")
  expect_gt(nrow(s$stn), 0)
  expect_type(s$meta, "list") %>%
    expect_length(2)

  # Ensure that we're getting recent data
  expect_equal(max(s$stn$end, na.rm = TRUE), lubridate::year(Sys.Date()))

  # stations_read() ----

  # Without local file, use package file
  expect_silent(s1 <- stations_read()$meta)
  expect_lte(s1$weathercan_modified, Sys.Date())

  expect_gte(s$meta$weathercan_modified, s1$weathercan_modified)

  unlink("stations.rds")
})


# stations() --------------------------------------------------------------
test_that("stations() /stations_meta() return data", {

  expect_silent(s <- stations()) %>%
    expect_s3_class("data.frame")

  expect_silent(stations_meta()) %>%
    expect_type("list")

  expect_named(stations_meta(), c("ECCC_modified", "weathercan_modified"))

  expect_length(s, 17)
  expect_lt(length(data.frame(s)[is.na(data.frame(s))]),
            length(data.frame(s)[!is.na(data.frame(s))]))
  expect_type(s$prov, "character")
  expect_type(s$station_name, "character")
  expect_gt(nrow(s), 10)
  expect_equal(unique(s$interval), c("day", "hour", "month"))

  # Check content
  expect_equal(nrow(s[is.na(s$station_name),]), 0)
  expect_equal(nrow(s[is.na(s$station_id),]), 0)
  expect_equal(nrow(s[is.na(s$prov),]), 0)
  expect_true(all(table(s$station_id) == 3)) # One row per time interval type

})


# stations_search() ---------------------------------------------------------

test_that("stations_search 'name' returns correct format", {
  expect_error(stations_search())
  expect_error(stations_search(name = mean()))
  expect_s3_class(stations_search("XXX"), "data.frame")
  expect_length(stations_search("XXX"), 17)
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
  skip_if_not_installed("sf")
  expect_error(stations_search(coords = c("Hi")))
  expect_error(stations_search(coords = 44))
  expect_message(stn <- stations_search(coords = c(54, -122)), "No stations within")
  expect_s3_class(stn, "data.frame")
  expect_length(stn, 18)
  expect_gt(nrow(stn), 0)

  expect_snapshot_value(stn, style = "json2", tolerance = 0.001)
})

test_that("stations_search 'coords' returns correct data", {
  ## Check specific
  expect_equal(nrow(stn <- stations_search(coords = c(54, -122))), 10) %>%
    expect_message("No stations within 10km")
  expect_equal(stn$station_name[1], "UPPER FRASER")
  expect_equal(round(stn$distance[1], 5), 13.73664)
  expect_lt(max(stn$distance) - min(stn$distance), 10)

  ## Check with Kamloops
  k <- c(50.67452, -120.3273)
  expect_equal(nrow(stn <- stations_search(coords = k)), 26)
  expect_lt(max(stn$distance), 10)

  ## Check messages
  expect_message(stations_search(coords = c(54, -122)),
                 "No stations within 10km. Returning closest 10 records")

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
                 "Searching by name") %>%
    expect_message("The `name` argument looks like a pair of coordinates")
  expect_message(stations_search("Kamloops", verbose = TRUE),
                 "Searching by name")
  expect_message(stations_search(coords = c(54, -122), verbose = TRUE),
                 "Calculating station distances") %>%
    expect_message("No stations within 10km")

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
  expect_warning(s <- stations_search("Brandon", normals_only = TRUE),
                 "`normals_only` is deprecated")
  expect_silent(s <- stations_search("Brandon", normals_years = "current"))
  expect_gt(nrow(stations()), nrow(s))
  expect_true(all(s$normals))
  expect_equal(unique(s$station_id), s$station_id)

  expect_silent(s1 <- stations_search("Brandon", normals_years = "1981-2010"))
  expect_gt(nrow(stations()), nrow(s1))
  expect_equal(s$station_id, s1$station_id)

  expect_silent(s2 <- stations_search("Brandon", normals_years = "1971-2000"))
  expect_gt(nrow(stations()), nrow(s2))
  expect_equal(s$station_id, s1$station_id)

  expect_message(s3 <- stations_search("Brandon", normals_years = "1991-2020"),
                 "be aware that they are not yet available")

  expect_error(
    stations_search(name = "Ottawa", normals_years = "invalid input"),
    "`normals_years` must either be `NULL`"
  )
  expect_no_error(stations_search(name = "Ottawa", normals_years = NULL))
  expect_no_error(stations_search(name = "Ottawa", normals_years = "current"))


})
