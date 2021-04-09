context("Climate Normals")

test_that("normals_html correctly retrieves request", {

  vcr::use_cassette("normals_html_5010480", {
    expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                     normals_years = "1981-2010", prov = "MB"))
  })

  ## Basics
  expect_is(nd, "response")
  expect_false(httr::http_error(nd))
  expect_gt(length(nd$content), 10000)


  skip_on_cran()
  skip_if_offline()

  bkup <- getOption("weathercan.urls.normals")
  options(weathercan.urls.normals = "https://httpstat.us/404")
  expect_error(normals_html(prov = "MB", station_id = 3471,
                            climate_id = "5010480",
                            normals_years = "1981-2010"),
               "Failed to access",
               class = "http_error")
  options(weathercan.urls.normals = bkup)
})

test_that("normals_raw() extracts normals as character", {

  vcr::use_cassette("normals_html_5010480", {
    expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                     normals_years = "1981-2010", prov = "MB"))
  })

  expect_silent(nd <- normals_raw(nd)) %>%
    expect_is("character")
  expect_false(any(stringr::str_detect(nd, "[^\001-\177]")))

})

test_that("normals_extract() cleans up raw data", {
  vcr::use_cassette("normals_html_5010480", {
    expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                     normals_years = "1981-2010", prov = "MB"))
  })

  n <- normals_raw(nd)

  expect_silent(n1 <- normals_extract(n)) %>%
    expect_is("character")
  expect_lt(length(n1), length(n))
  expect_true(stringr::str_detect(n1[1], "Jan"))
})

test_that("data_extract() / frost_extract() extract data", {
  vcr::use_cassette("normals_html_5010480", {
    expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                     normals_years = "1981-2010", prov = "MB"))
  })

  n <- nd %>%
    normals_raw() %>%
    normals_extract()

  expect_silent(data_extract(n, climate_id = "5010480")) %>%
    expect_is("data.frame")
  expect_silent(frost_extract(n, climate_id = "5010480")) %>%
    expect_is("data.frame")
})

test_that("normals_format()/frost_format() format data to correct class", {

  vcr::use_cassette("normals_html_5010480", {
    expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                     normals_years = "1981-2010", prov = "MB"))
  })

  n <- nd %>%
    normals_raw() %>%
    normals_extract()

  expect_silent(f <- frost_extract(n, climate_id = "5010480"))
  expect_silent(n <- data_extract(n, climate_id = "5010480"))

  expect_silent(n_fmt <- data_format(n)) %>%
    expect_is("data.frame")
  expect_is(n_fmt[["temp_daily_average"]], "numeric")
  expect_is(n_fmt[["temp_extreme_max_date"]], "Date")
  expect_is(n_fmt[["wind_dir"]], "character")

  expect_silent(f_fmt <- frost_format(f)) %>%
    expect_is("data.frame")
  expect_is(f_fmt[["date_first_fall_frost"]], "numeric")
  expect_is(f_fmt[["prob_first_fall_temp_below_0_on_date"]], "numeric")
  expect_is(f_fmt[["frost_code"]], "character")
})

test_that("normals_dl() downloads normals/frost dates as tibble", {

  vcr::use_cassette("normals_dl_5010480", {
    expect_silent(nd <- normals_dl(climate_id = "5010480")) %>%
      expect_is("tbl_df")
  })


  vcr::use_cassette("normals_dl_1096450_2403500_5010480", {
    expect_silent(nd <- normals_dl(climate_id = c("2403500", "5010480",
                                                  "1096450"))) %>%
      expect_is("tbl_df")
  })


  expect_equal(nrow(nd), 3)
  expect_is(tidyr::unnest(nd, normals), "data.frame")
  expect_is(tidyr::unnest(nd, frost), "data.frame")
  expect_length(tidyr::unnest(nd, normals) %>%
                  dplyr::pull(climate_id) %>%
                  unique(), 3)
  expect_length(tidyr::unnest(nd, frost) %>%
                  dplyr::pull(climate_id) %>%
                  unique(), 3)
})

# Fix issue #106 - Added (C) to extreme wind chill

test_that("normals_dl() gets extreme wind chill correctly", {
  vcr::use_cassette("normals_dl_2100517", {
    expect_silent(nd <- normals_dl(climate_id = "2100517")) %>%
      expect_is("tbl_df")
  })
})
