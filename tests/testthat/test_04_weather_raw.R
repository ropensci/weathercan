
# weather_raw --------------------------------------------------------------
context("weather_raw")

test_that("weather_html/raw (hour) download a data frame", {
  skip_on_cran()
  #if(on_CRAN()) mockery::stub(weather_html, "get_html", tests$weather_html_01)

  vcr::use_cassette("weather_raw1", {
    expect_silent(wd <- weather_html(station_id = 51423,
                                     date = as.Date("2014-01-01"),
                                     interval = "hour"))
  })

  expect_silent(wd <- weather_raw(wd))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 30)
  expect_equal(nrow(wd), 744)
  expect_is(dplyr::pull(wd, "Date/Time (LST)"), "character")
  expect_lt(length(data.frame(wd)[is.na(data.frame(wd))]),
            length(data.frame(wd)[!is.na(data.frame(wd))]))
  #expect_true(stringi::stri_escape_unicode(wd[, "Data Quality"][1]) %in%
  #              c("\\u2021"))
})

test_that("weather_html/raw (day) download a data frame", {
  skip_on_cran()
  vcr::use_cassette("weather_raw2", {
    expect_silent(wd <- weather_html(station_id = 51423,
                                     date = as.Date("2014-01-01"),
                                     interval = "day"))
  })

  expect_silent(wd <- weather_raw(wd))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 31)
  expect_equal(nrow(wd), 365)
  expect_is(dplyr::pull(wd, "Date/Time"), "character")
  expect_lt(length(data.frame(wd)[is.na(data.frame(wd))]),
            length(data.frame(wd)[!is.na(data.frame(wd))]))
  # expect_true(stringi::stri_escape_unicode(wd[, "Data Quality"][1]) %in%
  #              c("\\u2021"))
})


test_that("weather_html/raw (month) download a data frame", {
  skip_on_cran()
  vcr::use_cassette("weather_raw3", {
    expect_silent(wd <- weather_html(station_id = 5401,
                                     date = as.Date("2017-01-01"),
                                     interval = "month"))
  })

  expect_silent(wd <- weather_raw(wd))

  ## Basics
  expect_is(wd, "data.frame")
  expect_length(wd, 29)
  expect_equal(nrow(wd), 842)
  expect_is(dplyr::pull(wd, "Date/Time"), "character")
  expect_lt(length(data.frame(wd)[is.na(data.frame(wd))]),
            length(data.frame(wd)[!is.na(data.frame(wd))]))

  # Expect 'I' flags converted to '^'
  expect_true("^" %in% wd$`Total Precip Flag`)
  expect_false("I" %in% wd$`Total Precip Flag`)
})

test_that("meta_html/raw (hour) download meta data", {
  skip_on_cran()
  vcr::use_cassette("meta_raw1", {
    expect_silent(meta <- meta_html(station_id = 51423, interval = "hour"))
  })
    expect_silent(meta <- meta_raw(meta, interval = "hour"))

  ## Basics
  expect_is(meta, "data.frame")
  expect_length(meta, 2)
  expect_equal(nrow(meta), 8)
  m <- paste0("(", paste0(m_names, collapse = ")|("), ")")
  expect_true(all(stringr::str_detect(meta$X1, m)))
  expect_lt(length(data.frame(meta)[is.na(data.frame(meta))]),
            length(data.frame(meta)[!is.na(data.frame(meta))]))

})

test_that("meta_html/raw (day) download meta data", {
  skip_on_cran()
  vcr::use_cassette("meta_raw2", {
    expect_silent(meta <- meta_html(station_id = 51423, interval = "day"))
  })
  expect_silent(meta <- meta_raw(meta, interval = "day"))

  ## Basics
  expect_is(meta, "data.frame")
  expect_length(meta, 2)
  expect_equal(nrow(meta), 8)
  m <- paste0("(", paste0(m_names, collapse = ")|("), ")")
  expect_true(all(stringr::str_detect(meta$X1, m)))
  expect_lt(length(data.frame(meta)[is.na(data.frame(meta))]),
            length(data.frame(meta)[!is.na(data.frame(meta))]))

})

test_that("meta_html/raw (month) download meta data", {
  skip_on_cran()
  vcr::use_cassette("meta_raw3", {
    expect_silent(meta <- meta_html(station_id = 5401, interval = "month"))
  })
  expect_silent(meta <- meta_raw(meta, interval = "month"))

  ## Basics
  expect_is(meta, "data.frame")
  expect_length(meta, 2)
  expect_equal(nrow(meta), 8)
  m <- paste0("(", paste0(m_names, collapse = ")|("), ")")
  expect_true(all(stringr::str_detect(meta$X1, m)))
  expect_lt(length(data.frame(meta)[is.na(data.frame(meta))]),
            length(data.frame(meta)[!is.na(data.frame(meta))]))

})

