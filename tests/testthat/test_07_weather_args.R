# weather by hour ---------------------------------------------------------
context("weather_dl() arguments")

test_that("weather_dl() hour format = FALSE", {
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_01)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_01)
  }

  w <- weather_dl(station_ids = 51423, start = "2014-01-01", end = "2014-01-31",
                  format = FALSE)

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 38)
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
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_02)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_02)
  }

  w <- weather_dl(station_ids = 51423, start = "2014-01-01", end = "2014-03-01",
                  interval = "day", format = FALSE)

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 41)
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
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_03)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_03)
  }
  expect_silent(w <- weather_dl(station_ids = 5401,
                                start = "2017-01-01", end = "2017-05-01",
                                interval = "month", format = FALSE))

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 39)
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
  if(on_CRAN()) {
    mockery::stub(weather_dl, "weather_html", tests$weather_html_02)
    mockery::stub(weather_dl, "meta_html", tests$meta_html_02)
  }
  expect_warning(expect_message(w <- weather_dl(station_id = 51423, interval = "day",
                                                start = "2014-01-01", end = "2014-03-01",
                                                string_as = NULL)),
                 NA)

})
