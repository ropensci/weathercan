# weather by hour ---------------------------------------------------------
context("weather_dl() arguments")

test_that("weather_dl() hour format = FALSE", {

  w <- weather_dl(station_ids = 51423, start = "2014-01-01", end = "2014-01-31",
                  format = FALSE)

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 34)
  expect_equal(nrow(w), 744)
  expect_is(w$prov, "character")

  c <- dplyr::select(w, -station_id, -prov, -lat, -lon, -elev)
  expect_true(all(apply(c, 2, is.character)))

  ## Data
  expect_equal(w$station_id[1], 51423)
  expect_equal(w$station_name[1], "KAMLOOPS A")
  expect_equal(w$prov[1], "BC")

  expect_equal(w$`Date/Time`[1], "2014-01-01 00:00")
  #expect_equal(w$`Data Quality`[1], "\u2021")
})

test_that("weather_dl() day format = FALSE", {

  w <- weather_dl(station_ids = 51423, start = "2014-01-01", end = "2014-03-01",
                  interval = "day", format = FALSE)

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 37)
  expect_equal(nrow(w), 365)
  expect_is(w$prov, "character")

  c <- dplyr::select(w, -station_id, -prov, -lat, -lon, -elev)
  expect_true(all(apply(c, 2, is.character)))

  ## Data
  expect_equal(w$station_id[1], 51423)
  expect_equal(w$station_name[1], "KAMLOOPS A")
  expect_equal(w$prov[1], "BC")

  expect_equal(w$`Date/Time`[1], "2014-01-01")
  #expect_equal(w$`Data Quality`[1], "\u2021")
  expect_equal(w$`Data Quality`[1], "")

})

test_that("weather_dl() month format = FALSE", {

  expect_silent(w <- weather_dl(station_ids = 5401,
                                start = "2014-01-01", end = "2014-05-01",
                                interval = "month", format = FALSE))

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 35)
  expect_equal(nrow(w), 842)
  expect_is(w$prov, "character")

  c <- dplyr::select(w, -station_id, -prov, -lat, -lon, -elev)
  expect_true(all(apply(c, 2, is.character)))

  ## Data
  expect_equal(w$station_id[1], 5401)
  expect_equal(w$station_name[1], "MAGOG")
  expect_equal(w$prov[1], "QC")
  expect_equal(w$`Date/Time`[1], "1948-01")
  expect_equal(w$climate_id[1], "7024440")
  expect_equal(w$WMO_id[1], "")
  expect_equal(w$TC_id[1], "")
})


test_that("weather_dl() month string_as = NULL", {
  expect_warning(expect_message(w <- weather_dl(station_id = 49568, interval = "day",
                                                start = "2012-11-01", end = "2013-03-31",
                                                string_as = NULL)),
                 NA)

})
