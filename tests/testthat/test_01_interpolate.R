library(dplyr)

# Raw interpolation (time) ------------------------------------------------
context("Raw interpolation (time)")

test_that("approx_na_rm (time) without NAs", {
  k <- kamloops[kamloops$time > as.POSIXct("2016-03-01") &
                  kamloops$time < as.POSIXct("2016-03-03"), ]
  f <- finches[1:20, ]

  ## Format
  for(i in c(0, 2, lubridate::hours(2), lubridate::days(14))) {
    expect_silent(a <- approx_na_rm(x = k$time, y = k$temp,
                                    xout = f$time, na_gap = i))
    expect_is(a, "data.frame")
    expect_is(a$x, "POSIXct")
    expect_is(a$y, "numeric")
    expect_named(a, c("x", "y"))
    expect_equal(nrow(a), nrow(f))
    expect_true(all(f$time == a$x))
  }

  ## Values
  for(i in sample(seq_len(nrow(a)), size = 10)) {
    k_temp <- k$temp[k$time %in% c(lubridate::floor_date(a$x[i], "hour"),
                                   lubridate::ceiling_date(a$x[i], "hour"))]
    expect_equal(a$y[i],
                 approx(x = c(lubridate::floor_date(a$x[i], "hour"),
                              lubridate::ceiling_date(a$x[i], "hour")),
                        y = k_temp,
                        xout = a$x[i])$y)
  }
})


test_that("approx_na_rm (time) without NAs for different measures", {
  k <- kamloops[kamloops$time > as.POSIXct("2016-03-01") &
                  kamloops$time < as.POSIXct("2016-03-03"), ]
  k <- as.data.frame(k)
  f <- finches[1:20, ]

  ## Format
  for(m in c("temp", "pressure", "rel_hum", "temp_dew", "visib", "wind_spd")){
    expect_silent(a <- approx_na_rm(x = k$time, y = k[, m], xout = f$time))
    expect_is(a, "data.frame")
    expect_is(a$x, "POSIXct")
    expect_is(a$y, "numeric")
    expect_named(a, c("x", "y"))
    expect_equal(nrow(a), nrow(f))
    expect_true(all(f$time == a$x))
  }

})

test_that("approx_na_rm (time) without NAs pads NAs at start/end", {
  k <- kamloops[kamloops$time >= as.POSIXct("2016-03-08 12:00:00",
                                            tz = "Etc/GMT+8") &
                  kamloops$time <= as.POSIXct("2016-03-08 14:00:00",
                                              tz = "Etc/GMT+8"), ]
  f <- finches[finches$time >= as.POSIXct("2016-03-08 04:00:00"), ][1:500,]

  expect_silent(a <- approx_na_rm(x = k$time, y = k$temp,
                                  xout = f$time, na_gap = lubridate::hours(2)))
  expect_true(all(is.na(a$y[a$x < as.POSIXct("2016-03-08 12:00:00",
                                             tz = "Etc/GMT+8")])))
  expect_true(all(is.na(a$y[a$x > as.POSIXct("2016-03-08 14:00:00",
                                             tz = "Etc/GMT+8")])))
  expect_true(all(!is.na(a$y[a$x >= as.POSIXct("2016-03-08 12:00:00",
                                               tz = "Etc/GMT+8") &
                               a$x <= as.POSIXct("2016-03-08 14:00:00",
                                                 tz = "Etc/GMT+8")])))

})

test_that("approx_na_rm (time) replaces gaps with NAs", {
  k <- kamloops[kamloops$time >= as.POSIXct("2016-02-29 08:00:00",
                                            tz = "UTC") &
                  kamloops$time <= as.POSIXct("2016-03-30 9:00:00",
                                              tz = "UTC"), ]
  f <- finches %>%
    dplyr::mutate(time = lubridate::force_tz(.data$time, "UTC")) %>%
    dplyr::filter(time >= as.POSIXct("2016-03-08 06:00:00")) %>%
    dplyr::slice(1:500)

  expect_silent(a <- approx_na_rm(x = k$time, y = k$temp, xout = f$time,
                                  na_gap = lubridate::hours(2)))
  expect_equal(sum(is.na(a$y)), 0)

  expect_silent(a <- approx_na_rm(x = k$time, y = k$temp, xout = f$time,
                                  na_gap = lubridate::hours(1)))
  #expect_equal(sum(is.na(a$y)), 195)

})

# Raw interpolation (numeric) ---------------------------------------------
context("Raw interpolation (numeric)")

test_that("approx_na_rm (numeric) without NAs", {
  k <- data.frame(x = 1:100, y = sample(1:1000, 100))
  f <- data.frame(x = sample(seq(1.1, 99.5, length.out = 10)))

  ## Format
  for(i in c(0, 2, lubridate::hours(2), lubridate::days(14))) {
    expect_silent(a <- approx_na_rm(x = k$x, y = k$y, xout = f$x, na_gap = i))
    expect_is(a, "data.frame")
    expect_is(a$x, "numeric")
    expect_is(a$y, "numeric")
    expect_named(a, c("x", "y"))
    expect_equal(nrow(a), nrow(f))
    expect_true(all(f$x == a$x))
  }

  ## Values
  for(i in sample(seq_len(nrow(a)), size = 10)) {
    expect_equal(a$y[i],
                 approx(x = c(floor(a$x[i]), ceiling(a$x[i])),
                        y = k$y[k$x %in% c(floor(a$x[i]), ceiling(a$x[i]))],
                        xout = a$x[i])$y)
  }

  ## Make sure what's expected
  expect_equal(c(22, 21.25), approx(x = c(11, 12, 13),
                                    y = c(21, 25, 20),
                                    xout = c(11.25, 12.75))$y)
})


test_that("approx_na_rm (numeric) with NAs", {
  k <- data.frame(x = 1:100, y = sample(1:1000, 100))
  k$y[30:33] <- NA
  f <- data.frame(x = sort(sample(seq(1.1, 99.5, length.out = 10))))

  ## Format
  expect_error(approx_na_rm(x = k$x, y = k$y, xout = f$x, na_gap = NULL))
  expect_error(approx_na_rm(x = k$x, y = k$y, xout = f$x,
                            na_gap = lubridate::hours(1)))

  ## Get NAs returned
  expect_silent(a <- approx_na_rm(x = k$x, y = k$y, xout = f$x, na_gap = 1))
  expect_true(any(is.na(a)))
  expect_silent(a <- approx_na_rm(x = k$x, y = k$y, xout = f$x, na_gap = 3))
  expect_true(any(is.na(a)))

  ## Skip enough, get no NAs
  expect_silent(a <- approx_na_rm(x = k$x, y = k$y, xout = f$x, na_gap = 5))
  expect_true(all(!is.na(a)))
  expect_is(a, "data.frame")
  expect_is(a$x, "numeric")
  expect_is(a$y, "numeric")
  expect_named(a, c("x", "y"))
  expect_equal(nrow(a), nrow(f))
  expect_true(all(f$x == a$x))

})

# Add interpolation (hour) ------------------------------------------------
context("Add interpolation (hour)")

test_that("weather_interp (hour) fails with incorrect data types", {
  k <- kamloops[kamloops$time > as.POSIXct("2016-03-01") &
                  kamloops$time < as.POSIXct("2016-03-03"), ]
  f <- finches[1:20, ]

  ## Expect failure
  expect_error(weather_interp(f, dplyr::mutate(k, time = as.numeric(time))),
               regexp = paste0("'data' and 'weather' must be data frames with ",
                               "columns 'time' in POSIXct format or 'date' in ",
                               "Date format."))
  expect_error(weather_interp(dplyr::mutate(f, time = as.numeric(time)), k),
               regexp = paste0("'data' and 'weather' must be data frames with ",
                               "columns 'time' in POSIXct format or 'date' in ",
                               "Date format."))
})

test_that("weather_interp (hour) interpolates particular columns", {
  k <- kamloops[kamloops$time > as.POSIXct("2016-03-01") &
                  kamloops$time < as.POSIXct("2016-03-03"), ]
  f <- finches[1:20, ]

  ## Expect success
  for(m in c("temp", "temp_dew", "rel_hum", "wind_spd", "visib", "pressure")) {
    expect_silent(a <- weather_interp(f, k, cols = m))
    expect_named(a, c(names(f), m))
    expect_gt(nrow(a), sum(is.na(a[, m]))) # Not all NA
    expect_equal(a[, seq_len(ncol(f))], f)
  }

  ## Multiple columns
  expect_silent(a <- weather_interp(f, k, cols = c("temp", "temp_dew")))
  expect_named(a, c(names(f), c("temp", "temp_dew")))
  expect_gt(nrow(a), sum(is.na(a$temp))) # Not all NA
  expect_gt(nrow(a), sum(is.na(a$temp_dew))) # Not all NA
  expect_equal(a[, seq_len(ncol(f))], f)
})

test_that("weather_interp (hour) interpolates 'all'", {
  k <- kamloops[kamloops$time > as.POSIXct("2016-03-01") &
                  kamloops$time < as.POSIXct("2016-03-03"), ]
  f <- finches[1:20, ]

  ## Expect success
  expect_message(a <- weather_interp(f, k))
  expect_named(a, c(names(f), c("temp", "temp_dew", "rel_hum",
                                "wind_spd", "visib", "pressure")))
  expect_equal(a[, seq_len(ncol(f))], f)
})

test_that("weather_interp (hour) fails on character columns", {
  k <- kamloops[kamloops$time > as.POSIXct("2016-03-01") &
                  kamloops$time < as.POSIXct("2016-03-03"), ]
  f <- finches[1:20, ]

  k$temp <- as.character(k$temp)

  ## Expect failure
  expect_error(expect_message(weather_interp(f, k, cols = "temp")),
               "No columns over which to interpolate.")

  expect_message(weather_interp(f, k, cols = c("temp", "rel_hum")),
                 "Some columns \\(temp\\)")
})

test_that("weather_interp (hour) quiet", {
  k <- kamloops[kamloops$time > as.POSIXct("2016-03-01") &
                  kamloops$time < as.POSIXct("2016-03-03"), ]
  k$temp[1:10] <- NA
  f <- finches[1:20, ]
  expect_message(weather_interp(f, k, cols = "temp"))
  expect_silent(weather_interp(f, k, cols = "temp", quiet = TRUE))
})

# Add interpolation (day) -------------------------------------------------
context("Add interpolation (day)")

test_that("weather_interp (day) fails with incorrect data types", {
  k <- kamloops_day[kamloops_day$date < as.Date("2016-04-01"), ]
  f <- finches[1:20, ] %>%
    dplyr::mutate(date = as.Date(time))

  ## Expect failure
  expect_error(weather_interp(f, dplyr::mutate(k, date = as.numeric(date)),
                           interval = "day"),
               regexp = paste0("'data' and 'weather' must be data frames ",
                               "with columns 'time' in POSIXct format or ",
                               "'date' in Date format."))
  expect_error(weather_interp(dplyr::mutate(f, date = as.numeric(date)), k,
                           interval = "day"),
               regexp = paste0("'data' and 'weather' must be data frames ",
                               "with columns 'time' in POSIXct format or ",
                               "'date' in Date format."))
})


test_that("weather_interp (day) interpolates particular columns", {
  k <- kamloops_day[kamloops_day$date < as.Date("2016-04-01"), ]
  f <- finches[1:20, ] %>%
    dplyr::mutate(date = as.Date(time)) %>%
    dplyr::arrange(animal_id)

  ## Expect success
  for(m in c("max_temp", "min_temp", "mean_temp", "heat_deg_days",
             "cool_deg_days", "snow_grnd", "spd_max_gust", "total_precip",
             "total_rain", "total_snow")[7]) {
    if(any(is.na(k[, m]))) {
      expect_message(expect_error(a <- weather_interp(f, k, cols = m,
                                                   interval = "day"), NA))
    } else {
      expect_silent(a <- weather_interp(f, k, cols = m, interval = "day"))
    }
    expect_named(a, c(names(f), m))
    expect_equal(a[, seq_len(ncol(f))], f)
  }

  ## Multiple columns
  expect_silent(a <- weather_interp(f, k,
                                    cols = c("max_temp", "min_temp",
                                             "mean_temp"),
                                    interval = "day"))
  expect_named(a, c(names(f), c("max_temp", "min_temp", "mean_temp")))
  expect_equal(a[, seq_len(ncol(f))], f)
})

test_that("weather_interp (day) interpolates 'all'", {
  k <- kamloops_day[kamloops_day$date < as.Date("2016-04-01"), ]
  f <- finches[1:20, ] %>%
    dplyr::mutate(date = as.Date(time))

  ## Expect success
  expect_message(a <- weather_interp(f, k, interval = "day"))
  expect_named(a, c(names(f), c("max_temp", "min_temp", "mean_temp",
                                "heat_deg_days", "cool_deg_days", "total_rain",
                                "total_snow", "total_precip", "snow_grnd",
                                "spd_max_gust")))
  expect_equal(a[, seq_len(ncol(f))], f)
})


test_that("weather_interp (day) skips character columns", {
  k <- kamloops_day[kamloops_day$date < as.Date("2016-04-01"), ]
  f <- finches[1:20, ] %>%
    dplyr::mutate(date = as.Date(time))

  k$max_temp <- as.character(k$max_temp)

  ## Expect failure
  expect_error(expect_message(weather_interp(f, k, cols = "max_temp",
                                          interval = "day"),
                              paste0("Some columns \\(max\\_temp\\) are not ",
                                     "numeric and will thus be omitted from ",
                                     "the interpolation.\n")),
               "No columns over which to interpolate.")

  expect_message(weather_interp(f, k, cols = c("max_temp", "mean_temp"),
                             interval = "day"),
                 "Some columns \\(max\\_temp\\)")
})

test_that("weather_interp messages", {
  k <- kamloops_day[kamloops_day$date < as.Date("2016-04-01"), ]
  k$max_temp[1:10] <- NA
  f <- finches[1:20, ] %>%
    dplyr::mutate(date = as.Date(time))

  k2 <- rbind(k, dplyr::mutate(k, station_id = 234))

  expect_message(weather_interp(f, k, interval = "day", cols = "max_temp"),
                 "max_temp is missing 10 out of 91 data")
  expect_silent(weather_interp(f, k, interval = "day", cols = "max_temp",
                               quiet = TRUE))

  expect_error(weather_interp(f, k2, interval = "day", cols = "max_temp"),
               "Can only interpolate weather from one station at a time")
})
