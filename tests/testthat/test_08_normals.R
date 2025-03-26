
# normals_html() ------------------------------------------------------------

test_that("normals_html() correctly retrieves request 1991-2020", {
  skip("New normals not ready yet")
  skip_on_cran()
  skip_if_offline()

  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                   normals_years = "1991-2020", prov = "MB"))

  expect_s3_class(nd, "response")
  expect_false(httr::http_error(nd))
  expect_gt(length(nd$content), 10000)
})

test_that("normals_html() correctly retrieves request 1981-2010", {
  skip_on_cran()
  skip_if_offline()

  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                   normals_years = "1981-2010", prov = "MB"))
  expect_s3_class(nd, "response")
  expect_false(httr::http_error(nd))
  expect_gt(length(nd$content), 10000)
})

test_that("normals_html() correctly retrieves request 1971-2000", {
  skip_on_cran()
  skip_if_offline()
  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                   normals_years = "1971-2000", prov = "MB"))
  expect_s3_class(nd, "response")
  expect_false(httr::http_error(nd))
  expect_gt(length(nd$content), 10000)
})

# Proper error when 404
test_that("normals_html() errors", {
  skip_on_cran()
  memoise::forget(normals_html) # Reset cache so we can test a different url
  bkup <- getOption("weathercan.urls.normals")
  options(weathercan.urls.normals = "https://httpstat.us/404")
  expect_error(normals_html(prov = "MB", station_id = 3471,
                            climate_id = "5010480",
                            normals_years = "1981-2010"),
               "Failed to access",
               class = "http_error")
  options(weathercan.urls.normals = bkup)
})


# normals_raw() -------------------------------------------------------------
test_that("normals_raw() extracts normals as character", {
  skip_on_cran()
  skip_if_offline()

  #1981
  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                   normals_years = "1981-2010", prov = "MB"))

  expect_silent(nd <- normals_raw(nd)) %>%
    expect_type("character")
  expect_false(any(stringr::str_detect(nd, "[^\001-\177]")))


  #1971
  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                   normals_years = "1971-2000", prov = "MB"))

  expect_silent(nd <- normals_raw(nd)) %>%
    expect_type("character")
  expect_false(any(stringr::str_detect(nd, "[^\001-\177]")))

})


# normals_extract() ---------------------------------------------------------
test_that("normals_extract() cleans up raw data", {
  skip_on_cran()
  skip_if_offline()

  #1981-2010
  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                   normals_years = "1981-2010", prov = "MB"))

  n <- normals_raw(nd)

  expect_silent(n1 <- normals_extract(n)) %>%
    expect_type("character")
  expect_lt(length(n1), length(n))
  expect_true(stringr::str_detect(n1[1], "Jan"))

  #1971-2000
  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                   normals_years = "1971-2000", prov = "MB"))

  n <- normals_raw(nd)

  expect_silent(n1 <- normals_extract(n)) %>%
    expect_type("character")
  expect_lt(length(n1), length(n))
  expect_true(stringr::str_detect(n1[1], "Jan"))
})


# data/frost_extract() ----------------------------------------------------
test_that("data_extract() / frost_extract() extract data", {
  skip_on_cran()
  skip_if_offline()

  # 1981-2010
  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                     normals_years = "1981-2010", prov = "MB"))

  n <- nd %>%
    normals_raw() %>%
    normals_extract()

  expect_silent(data_extract(n, climate_id = "5010480")) %>%
    expect_s3_class("data.frame")
  expect_silent(frost_extract(n, climate_id = "5010480")) %>%
    expect_s3_class("data.frame")


  # 1971-2000
  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                   normals_years = "1971-2000", prov = "MB"))

  n <- nd %>%
    normals_raw() %>%
    normals_extract()

  expect_silent(data_extract(n, climate_id = "5010480")) %>%
    expect_s3_class("data.frame")
  expect_silent(frost_extract(n, climate_id = "5010480")) %>%
    expect_s3_class("data.frame")

})


# normals_format/frost_format ---------------------------------------------
test_that("normals_format()/frost_format() format data to correct class", {
  skip_on_cran()
  skip_if_offline()

  # 1981-2010
  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                   normals_years = "1981-2010", prov = "MB"))

  n <- nd %>%
    normals_raw() %>%
    normals_extract()

  expect_silent(f <- frost_extract(n, climate_id = "5010480"))
  expect_silent(n <- data_extract(n, climate_id = "5010480"))

  expect_silent(n_fmt <- data_format(n)) %>%
    expect_s3_class("data.frame")
  expect_type(n_fmt[["temp_daily_average"]], "double")
  expect_s3_class(n_fmt[["temp_extreme_max_date"]], "Date")
  expect_type(n_fmt[["wind_dir"]], "character")

  expect_silent(f_fmt <- frost_format(f)) %>%
    expect_s3_class("data.frame")
  expect_type(f_fmt[["date_first_fall_frost"]], "double")
  expect_type(f_fmt[["prob_first_fall_temp_below_0_on_date"]], "double")
  expect_type(f_fmt[["frost_code"]], "character")


  # 1971-2000
  expect_silent(nd <- normals_html(station_id = 3471, climate_id = "5010480",
                                   normals_years = "1971-2000", prov = "MB"))

  n <- nd %>%
    normals_raw() %>%
    normals_extract()

  expect_silent(f <- frost_extract(n, climate_id = "5010480"))
  expect_silent(n <- data_extract(n, climate_id = "5010480"))

  expect_silent(n_fmt <- data_format(n)) %>%
    expect_s3_class("data.frame")
  expect_type(n_fmt[["temp_daily_average"]], "double")
  expect_s3_class(n_fmt[["temp_extreme_max_date"]], "Date")
  expect_type(n_fmt[["wind_dir"]], "character")

  expect_silent(f_fmt <- frost_format(f)) %>%
    expect_s3_class("data.frame")
  expect_length(f_fmt[["date_first_fall_frost"]], 0)
  expect_length(f_fmt[["prob_first_fall_temp_below_0_on_date"]], 0)
  expect_length(f_fmt[["frost_code"]], 0)
})


# normals_dl() ------------------------------------------------------------
test_that("normals_dl() downloads normals/frost dates as tibble - single", {
  skip_on_cran()
  skip_if_offline()

  memoise::forget(normals_html) # Reset cache so we can test fully

  # 1981-2010
  expect_silent(nd1 <- normals_dl(climate_id = "5010480",
                                  normals_years = "1981-2010")) %>%
    expect_s3_class("tbl_df")

  # 1971-2000
  expect_silent(nd2 <- normals_dl(climate_id = "5010480",
                                  normals_years = "1971-2000")) %>%
    expect_s3_class("tbl_df")

  expect_snapshot_value(nd1, style = "json2", tolerance = 0.001)
  expect_snapshot_value(nd2, style = "json2", tolerance = 0.001)


  skip("New normals not ready yet")
  # 1991-2020
  expect_silent(nd1 <- normals_dl(climate_id = "5010480",
                                  normals_years = "1991-2020")) %>%
    expect_s3_class("tbl_df")
})

test_that("normals_dl() downloads normals/frost dates as tibble - multi 1991", {
  skip("New normals not ready yet")
  skip_on_cran()
  skip_if_offline()

  expect_silent(nd <- normals_dl(climate_id = c("2403500", "5010480",
                                                "1096450"),
                                 normals_years = "1991-2020")) %>%
    expect_s3_class("tbl_df")

  expect_equal(nrow(nd), 3)
  expect_s3_class(tidyr::unnest(nd, normals), "data.frame")
  expect_s3_class(tidyr::unnest(nd, frost), "data.frame")
  expect_length(tidyr::unnest(nd, normals) %>%
                  dplyr::pull(climate_id) %>%
                  unique(), 3)
  expect_length(tidyr::unnest(nd, frost) %>%
                  dplyr::pull(climate_id) %>%
                  unique(), 0)
})

test_that("normals_dl() downloads normals/frost dates as tibble - multi 1981", {
  skip_on_cran()
  skip_if_offline()

  expect_silent(nd <- normals_dl(climate_id = c("2403500", "5010480",
                                                "1096450"),
                                 normals_years = "1981-2010")) %>%
    expect_s3_class("tbl_df")

  expect_equal(nrow(nd), 3)
  expect_s3_class(tidyr::unnest(nd, normals), "data.frame")
  expect_s3_class(tidyr::unnest(nd, frost), "data.frame")
  expect_length(tidyr::unnest(nd, normals) %>%
                  dplyr::pull(climate_id) %>%
                  unique(), 3)
  expect_length(tidyr::unnest(nd, frost) %>%
                  dplyr::pull(climate_id) %>%
                  unique(), 3)
})

test_that("normals_dl() downloads normals/frost dates as tibble - multi 1971", {
  skip_on_cran()
  skip_if_offline()

  expect_silent(nd <- normals_dl(climate_id = c("2403500", "5010480",
                                                "1096450"),
                                 normals_years = "1971-2000")) %>%
    expect_s3_class("tbl_df")

  expect_equal(nrow(nd), 3)
  expect_s3_class(tidyr::unnest(nd, normals), "data.frame")
  expect_s3_class(tidyr::unnest(nd, frost), "data.frame")
  expect_length(tidyr::unnest(nd, normals) %>%
                  dplyr::pull(climate_id) %>%
                  unique(), 3)
  expect_length(tidyr::unnest(nd, frost) %>%
                  dplyr::pull(climate_id) %>%
                  unique(), 0)
})

test_that("normals_dl() stops if stn argument is provided", {
  expect_error(normals_dl(stn = "BRANDON A"))
  expect_error(normals_dl(stn = ""))
})

test_that("normals_dl() stops if climate normals are not available for stations", {
  expect_error(normals_dl(climate_ids = c("301AR54", "301B6L0", "301B8LR"),
                          normals_years = "1971-2000"))
})

test_that("normals_dl() messages if climate normals are not available some stations", {
  skip_on_cran()
  skip_if_offline()

  expect_message(normals_dl(climate_ids = c("301AR54", "2100685", "301B8LR"),
                            normals_years = "1971-2000"),
                 "Not all stations have climate normals available \\(climate ids: 301AR54, 301B8LR\\)")
})


# Bug fixes ------------------------------------------------------------------
# Fix issue #106 - Added (C) to extreme wind chill
test_that("normals_dl() gets extreme wind chill correctly", {
  skip_on_cran()
  skip_if_offline()

  expect_silent(nd <- normals_dl(climate_id = "2100517")) %>%
    expect_s3_class("tbl_df")
})

test_that("normals_dl() multiple weird stations", {
  skip_on_cran()
  skip_if_offline()
  expect_silent(nd <- normals_dl(climate_ids = c("301C3D4", "301FFNJ", "301N49A")))

  expect_snapshot_value(nd, style = "json2", tolerance = 0.001)
})
