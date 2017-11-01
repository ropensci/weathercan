# weather by hour ---------------------------------------------------------
context("weather() arguments")

test_that("weather() hour format = FALSE", {

  w <- weather(station_ids = 51423, start = "2014-01-01", end = "2014-01-31",
               format = FALSE)

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 34)
  expect_equal(nrow(w), 744)
  expect_is(w$station_name, "character")
  expect_is(w$prov, "factor")
  expect_is(w$`Temp (°C)`, "character")
  expect_is(w$`Temp Flag`, "character")
  expect_is(w$`Date/Time`, "character")

  ## Data
  expect_equal(w$station_id[1], 51423)
  expect_equal(w$station_name[1], "KAMLOOPS A")
  expect_equal(w$prov[1], factor("BC", levels = levels(stations$prov)))
  expect_equal(w$`Date/Time`[1], "2014-01-01 00:00")
  expect_equal(w$`Data Quality`[1], "‡")
})

test_that("weather() day format = FALSE", {

  w <- weather(station_ids = 51423, start = "2014-01-01", end = "2014-03-01",
               interval = "day", format = FALSE)

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 36)
  expect_equal(nrow(w), 365)
  expect_is(w$station_name, "character")
  expect_is(w$prov, "factor")
  expect_is(w$`Max Temp (°C)`, "character")
  expect_is(w$`Max Temp Flag`, "character")
  expect_is(w$`Date/Time`, "character")

  ## Data
  expect_equal(w$station_id[1], 51423)
  expect_equal(w$station_name[1], "KAMLOOPS A")
  expect_equal(w$prov[1], factor("BC", levels = levels(stations$prov)))
  expect_equal(w$`Date/Time`[1], "2014-01-01")
  expect_equal(w$`Data Quality`[1], "‡")

})

test_that("weather() month format = FALSE", {

  expect_silent(w <- weather(station_ids = 5401,
                             start = "2014-01-01", end = "2014-05-01",
                             interval = "month", format = FALSE))

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 34)
  expect_equal(nrow(w), 836)
  expect_is(w$station_name, "character")
  expect_is(w$prov, "factor")
  expect_is(w$`Mean Max Temp (°C)`, "character")
  expect_is(w$`Mean Max Temp Flag`, "character")
  expect_is(w$`Date/Time`, "character")

  ## Data
  expect_equal(w$station_id[1], 5401)
  expect_equal(w$station_name[1], "MAGOG")
  expect_equal(w$prov[1], factor("QC", levels = levels(stations$prov)))
  expect_equal(w$`Date/Time`[1], "1948-01")
  expect_equal(w$climat_id[1], "7024440")
  expect_equal(w$WMO_id[1], "")
  expect_equal(w$TC_id[1], "")
})
