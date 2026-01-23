# weather_raw --------------------------------------------------------------

test_that("weather_html/raw (hour) download a data frame", {
  skip_on_cran()

  expect_silent(
    wd <- weather_html(
      station_id = 51423,
      date = as.Date("2014-01-01"),
      interval = "hour"
    )
  )

  expect_silent(wd <- weather_raw(wd))

  # expect_error(
  #   weather_html(station_id = 9999999999,
  #                date = as.Date("2014-01-01"),
  #                interval = "hour"),
  #   "API could not fetch data with this query")

  ## Basics
  expect_s3_class(wd, "data.frame")
  expect_length(wd, 31)
  expect_equal(nrow(wd), 744)
  expect_type(dplyr::pull(wd, "Date/Time (LST)"), "character")
  expect_lt(
    length(data.frame(wd)[is.na(data.frame(wd))]),
    length(data.frame(wd)[!is.na(data.frame(wd))])
  )
})

test_that("weather_html/raw (day) download a data frame", {
  skip_on_cran()
  expect_silent(
    wd <- weather_html(
      station_id = 51423,
      date = as.Date("2014-01-01"),
      interval = "day"
    )
  )

  expect_silent(wd <- weather_raw(wd))

  ## Basics
  expect_s3_class(wd, "data.frame")
  expect_length(wd, 31)
  expect_equal(nrow(wd), 365)
  expect_type(dplyr::pull(wd, "Date/Time"), "character")
  expect_lt(
    length(data.frame(wd)[is.na(data.frame(wd))]),
    length(data.frame(wd)[!is.na(data.frame(wd))])
  )
  # expect_true(stringi::stri_escape_unicode(wd[, "Data Quality"][1]) %in%
  #              c("\\u2021"))
})


test_that("weather_html/raw (month) download a data frame", {
  skip_on_cran()
  expect_silent(
    wd <- weather_html(
      station_id = 5401,
      date = as.Date("2017-01-01"),
      interval = "month"
    )
  )

  expect_silent(wd <- weather_raw(wd))

  ## Basics
  expect_s3_class(wd, "data.frame")
  expect_length(wd, 29)
  expect_equal(nrow(wd), 842)
  expect_type(dplyr::pull(wd, "Date/Time"), "character")
  expect_lt(
    length(data.frame(wd)[is.na(data.frame(wd))]),
    length(data.frame(wd)[!is.na(data.frame(wd))])
  )

  # Expect 'I' flags converted to '^'
  expect_true("^" %in% wd$`Total Precip Flag`)
  expect_false("I" %in% wd$`Total Precip Flag`)
})

test_that("meta_html/raw (hour) download meta data", {
  skip_on_cran()
  expect_silent(
    meta <- meta_html(station_id = 51423, date = Sys.Date(), interval = "hour")
  )
  expect_silent(meta <- meta_raw(meta, interval = "hour"))

  ## Basics
  expect_s3_class(meta, "data.frame")
  expect_length(meta, 2)
  m <- paste0("(", paste0(m_names, collapse = ")|("), ")")
  expect_true(all(stringr::str_detect(meta$X1, m)))
  expect_lt(
    length(data.frame(meta)[is.na(data.frame(meta))]),
    length(data.frame(meta)[!is.na(data.frame(meta))])
  )
})

test_that("meta_html/raw (day) download meta data", {
  skip_on_cran()
  expect_silent(
    meta <- meta_html(station_id = 51423, date = Sys.Date(), interval = "day")
  )
  expect_silent(meta <- meta_raw(meta, interval = "day"))

  ## Basics
  expect_s3_class(meta, "data.frame")
  expect_length(meta, 2)
  m <- paste0("(", paste0(m_names, collapse = ")|("), ")")
  expect_true(all(stringr::str_detect(meta$X1, m)))
  expect_lt(
    length(data.frame(meta)[is.na(data.frame(meta))]),
    length(data.frame(meta)[!is.na(data.frame(meta))])
  )
})

test_that("meta_html/raw (month) download meta data", {
  skip_on_cran()
  expect_silent(
    meta <- meta_html(station_id = 5401, date = Sys.Date(), interval = "month")
  )
  expect_silent(meta <- meta_raw(meta, interval = "month"))

  ## Basics
  expect_s3_class(meta, "data.frame")
  expect_length(meta, 2)
  m <- paste0("(", paste0(m_names, collapse = ")|("), ")")
  expect_true(all(stringr::str_detect(meta$X1, m)))
  expect_lt(
    length(data.frame(meta)[is.na(data.frame(meta))]),
    length(data.frame(meta)[!is.na(data.frame(meta))])
  )
})
