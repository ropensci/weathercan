context("Weather data")

test_that("weather_dl (hour) downloads a data frame", {
  expect_silent(wd <- weather_dl(station_id = 51423, date = as.Date("2014-01-01"), skip = 15, interval = "hour"))
  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 25)
  expect_equal(nrow(wd), 744)
  expect_is(wd$Date.Time, "character")
  expect_lt(length(data.frame(wd)[is.na(data.frame(wd))]), length(data.frame(wd)[!is.na(data.frame(wd))]))
  expect_true(stringi::stri_escape_unicode(wd$Data.Quality[1]) %in% c("\\u2021"))
})

test_that("weather_dl (day) downloads a data frame", {
  expect_silent(wd <- weather_dl(station_id = 51423, date = as.Date("2014-01-01"), skip = 25, interval = "day"))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 27)
  expect_equal(nrow(wd), 365)
  expect_is(wd$Date.Time, "character")
  expect_lt(length(wd[is.na(wd)]), length(wd[!is.na(wd)]))
  expect_true(stringi::stri_escape_unicode(wd$Data.Quality[1]) %in% c("\\u2021"))
})

test_that("weather_dl (month) downloads a data frame", {
  expect_silent(wd <- weather_dl(station_id = 43823, date = as.Date("2005-01-01"), skip = 17, interval = "month"))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 25)
  expect_equal(nrow(wd), 4)
  expect_is(wd$Date.Time, "character")
  expect_lt(length(data.frame(wd)[is.na(data.frame(wd))]), length(data.frame(wd)[!is.na(data.frame(wd))]))
})


#####################
## HOURLY
#####################

test_that("weather(hour) returns a data frame", {
  expect_silent({weather(station_ids = 51423, start = "2014-01-01", end = "2014-01-31")})
  expect_message({w <- weather(station_ids = 51423, start = "2014-01-01", end = "2014-01-31", verbose = TRUE)})

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 35)
  expect_equal(nrow(w), 744)
  expect_is(w$station_name, "character")
  expect_is(w$prov, "factor")
  expect_is(w$temp, "numeric")
  expect_is(w$temp_flag, "character")
  expect_is(w$date, "Date")
  expect_is(w$time, "POSIXct")
  expect_lt(length(data.frame(w)[is.na(data.frame(w))]), length(data.frame(w)[!is.na(data.frame(w))]))

  ## Data
  expect_equal(w$station_id[1], 51423)
  expect_equal(w$station_name[1], "KAMLOOPS A")
  expect_equal(w$prov[1], factor("BC", levels = levels(stations$prov)))
  expect_equal(w$time[1], as.POSIXct("2014-01-01 00:00:00", tz = "Etc/GMT+8"))
  expect_equal(w$qual[1], "Partner data that is not subject to review by the National Climate Archives")
})

test_that("weather(hourly) formats timezone display", {
  expect_silent({w <- weather(station_ids = 51423, start = "2014-03-01", end = "2014-04-01", tz_disp = "America/Vancouver")})
  expect_equal(w$time[1], as.POSIXct("2014-03-01 00:00:00", tz = "America/Vancouver"))
  expect_equal(w$time[w$date == as.Date("2014-04-01")][1], as.POSIXct("2014-04-01 01:00:00", tz = "America/Vancouver"))
})

test_that("weather(hourly) gets all", {
  expect_silent(w <- weather(station_ids = 10816, start = Sys.Date() - lubridate::days(1), interval = "hour", trim = FALSE))
  expect_is(w, "data.frame")
  expect_length(w, 35)
  expect_equal(nrow(w), 48)
  expect_equal(w$date[1], Sys.Date() - lubridate::days(1))
  expect_equal(w$date[nrow(w)], Sys.Date())
})

test_that("weather(hourly) trims NAs", {

})

test_that("weather(hour) multiple stations", {
  expect_silent({w <- weather(station_ids = c(51423, 10816), start = "2014-03-01", end = "2014-04-01")})

  expect_equal(unique(w$station_name), c("KAMLOOPS A", "SQUAMISH AIRPORT"))
  expect_equal(nrow(w[w$station_id == 51423,]), nrow(w[w$station_id == 10816,]))
})


#####################
## DAILY
#####################

test_that("weather (day) returns a data frame", {
  expect_message(expect_error({weather(station_ids = 51423, start = "2014-01-01", end = "2014-03-01", interval = "day")}, NA))
  expect_message(expect_error({w <- weather(station_ids = 51423, start = "2014-01-01", end = "2014-03-01", interval = "day", verbose = TRUE)}, NA))

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 36)
  expect_equal(nrow(w), lubridate::int_length(lubridate::interval(min(w$date), max(w$date)))/60/60/24 + 1)
  expect_is(w$station_name, "character")
  expect_is(w$prov, "factor")
  expect_is(w$mean_temp, "numeric")
  expect_is(w$mean_temp_flag, "character")
  expect_is(w$date, "Date")
  expect_lt(length(data.frame(w)[is.na(data.frame(w))]), length(data.frame(w)[!is.na(data.frame(w))]))

  ## Data
  expect_equal(w$station_id[1], 51423)
  expect_equal(w$station_name[1], "KAMLOOPS A")
  expect_equal(w$prov[1], factor("BC", levels = levels(stations$prov)))
  expect_equal(w$qual[1], "Partner data that is not subject to review by the National Climate Archives")
})

test_that("weather(daily) gets all", {
  expect_silent(weather(station_ids = 54398, interval = "day", trim = FALSE))
  expect_message(expect_error({w <- weather(station_ids = 54398, interval = "day", trim = FALSE, verbose = TRUE)}, NA))

  expect_is(w, "data.frame")
  expect_length(w, 36)
  expect_gte(nrow(w), 20)
  expect_equal(min(w$date), as.Date("2016-01-01"))
  expect_equal(max(w$date), Sys.Date())

  expect_silent(w <- weather(station_ids = 54398, start = "2017-01-01", interval = "day", trim = FALSE))
  expect_equal(min(w$date), as.Date("2017-01-01"))
  expect_equal(max(w$date), Sys.Date())

  expect_silent(w <- weather(station_ids = 54398, end = "2016-04-01", interval = "day", trim = FALSE))
  expect_equal(min(w$date), as.Date("2016-01-01"))
  expect_equal(max(w$date), as.Date("2016-04-01"))

})




test_that("weather(daily) trims NAs", {
  expect_silent(w1 <- weather(station_ids = 54398, interval = "day", trim = FALSE))
  expect_silent(w2 <- weather(station_ids = 54398, interval = "day", trim = TRUE))

  expect_gte(nrow(w1), nrow(w2))
  expect_gte(length(data.frame(w1)[is.na(data.frame(w1))]), length(data.frame(w2)[is.na(data.frame(w2))]))
})

test_that("weather(day) no data fails nicely", {
  expect_message(expect_error(w0 <- weather(station_ids = 51457, start = "2014-01-01", end = "2014-05-01", interval = "day"), NA))

  ## Basics
  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
})

test_that("weather(day) mutliple stations", {
  expect_error(w <- weather(station_ids = c(54398, 51423), start = "2016-03-01", end = "2016-04-01", interval = "day"), NA)

  expect_equal(unique(w$station_name), c("MUSKOKA SNOW", "KAMLOOPS A"))
  expect_equal(nrow(w[w$station_id == 54398,]), nrow(w[w$station_id == 51423,]))
})


#####################
## MONTHLY
#####################

test_that("weather returns a data frame MONTHLY", {
  expect_silent(w <- weather(station_ids = 5401, start = "2014-01-01", end = "2014-05-01", interval = "month"))

  ## Basics
  expect_is(w, "data.frame")
  expect_length(w, 34)
  expect_equal(nrow(w), 5)
  expect_is(w$station_name, "character")
  expect_is(w$prov, "factor")
  expect_is(w$mean_temp, "numeric")
  expect_is(w$mean_temp_flag, "character")
  expect_is(w$date, "Date")
  expect_lt(length(data.frame(w)[is.na(data.frame(w))]), length(data.frame(w)[!is.na(data.frame(w))]))

  ## Data
  expect_equal(w$station_id[1], 5401)
  expect_equal(w$station_name[1], "MAGOG")
  expect_equal(w$climat_id[1], "7024440")
  expect_equal(w$WMO_id[1], "")
  expect_equal(w$TC_id[1], "")
  expect_equal(w$prov[1], factor("QC", levels = levels(stations$prov)))

})

test_that("weather(monthly) trims NAs", {

})

test_that("weather(monthly) no data fails nicely", {
  expect_message(expect_error(w0 <- weather(station_ids = 51423, start = "2014-01-01", end = "2014-05-01", interval = "month"), NA))

  ## Basics
  expect_is(w0, "data.frame")
  expect_length(w0, 0)
  expect_equal(nrow(w0), 0)
})

test_that("weather(month) multiple stations", {
  expect_silent(w <- weather(station_ids = c(5401, 5940), start = "2014-01-01", end = "2014-05-01", interval = "month"))

  expect_equal(unique(w$station_name), c("MAGOG", "ST PRIME"))
  expect_equal(nrow(w[w$station_id == 5401,]), nrow(w[w$station_id == 5940,]))
})

test_that("weather(month) multiple stations (one NA)", {
  expect_message(expect_error(w <- weather(station_ids = c(5401, 51423), start = "2014-01-01", end = "2014-05-01", interval = "month"), NA))
  expect_equal(unique(w$station_name), c("MAGOG"))
})


##################
### list_col
##################
context("Generating list_col")

test_that("list_col=TRUE and interval=hour groups on the right level", {
  expect_equal(ncol(weather(station_ids = c(27226), start = "2015-01-01", end = "2015-01-15", interval = "hour") %>%
                 tidyr::nest(-station_name,-station_id,-lat,-lon, -date)),
               ncol(weather(station_ids = c(27226), start = "2015-01-01", end = "2015-01-15", interval = "hour", list_col=TRUE)) )
})

test_that("list_col=TRUE and interval=day groups on the right level", {
  expect_equal(ncol(weather(station_ids = c(27119), start = "2015-01-01", end = "2015-01-15", interval = "day") %>%
                      tidyr::nest(-station_name,-station_id,-lat,-lon, -month)),
               ncol(weather(station_ids = c(27119), start = "2015-01-01", end = "2015-01-15", interval = "day", list_col=TRUE))
  )
})

test_that("list_col=TRUE and interval=month groups on the right level", {
  expect_equal(ncol(weather(station_ids = c(5217), start = "2015-01-01", end = "2015-01-15", interval = "month") %>%
                      tidyr::nest(-station_name,-station_id,-lat,-lon, -year)),
               ncol(weather(station_ids = c(5217), start = "2015-01-01", end = "2015-01-15", interval = "month", list_col=TRUE))
               )
})


