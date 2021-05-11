context("onLoad")

test_that("URLS correctly set", {

  expect_type(w <- getOption("weathercan.urls.weather"), "character")
  expect_true(stringr::str_detect(w, "climate.weather.gc.ca"))

  expect_type(w <- getOption("weathercan.urls.normals"), "character")
  expect_true(stringr::str_detect(w, "climate.weather.gc.ca"))

  expect_type(w <- getOption("weathercan.urls.stations"), "character")
  expect_true(stringr::str_detect(w, "drive.google.com"))

  expect_type(w <- getOption("weathercan.urls.stations.normals"), "character")
  expect_true(stringr::str_detect(w, "climate.weather.gc.ca"))
})

test_that("Functions cached correctly", {
  expect_true(memoise::is.memoised(get_html))
  expect_true(memoise::is.memoised(normals_html))

  skip_on_cran()
  skip_if_offline()
  t1 <- system.time(w <- weather_dl(station_ids = 51423, start = "2014-01-01",
                                    end = "2014-01-31"))
  t2 <- system.time(w <- weather_dl(station_ids = 51423, start = "2014-01-01",
                                    end = "2014-01-31"))
  expect_gt(t1[3], t2[3])

  t1 <- system.time(normals_dl(climate_id = c("2403500", "5010480", "1096450")))
  t2 <- system.time(normals_dl(climate_id = c("2403500", "5010480", "1096450")))
  expect_gt(t1[3], t2[3])
})
