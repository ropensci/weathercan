context("Climate Normals")

test_that("normals_url() correctly creates urls", {
  expect_equal(
    normals_url(prov = "MB", climate_id = c("5010480", "5010480"),
                normals_years = "1981-2010"),
    paste0("https://dd.meteo.gc.ca/climate/observations/normals/csv/1981-2010/",
           "MB/climate_normals_MB_", c("5010480", "5010480"), "_1981-2010.csv"))

  expect_error(normals_url(prov = "MB", climate_id = c("5010480", "5010480"),
                           normals_years = "1971-2000"), "Climate normals are not")

  expect_silent(normals_url(prov = "MB", climate_id = "5010480",
                            normals_years = "1981-2010"))

  bkup <- getOption("weathercan.urls.normals")
  options(weathercan.urls.normals = "https://httpstat.us/404")
  expect_error(normals_url(prov = "MB", climate_id = "5010480",
                           normals_years = "1981-2010"),
               "Failed to access",
               class = "http_error")
  options(weathercan.urls.normals = bkup)
})

test_that("normals_raw() download normals as character", {
  url <- paste0("https://dd.meteo.gc.ca/climate/observations/normals/csv/",
                "1981-2010/MB/climate_normals_MB_5010480_1981-2010.csv")
  expect_silent(normals_raw(url)) %>%
    expect_is("character")

  expect_error(normals_raw("https://httpstat.us/404"),
               "Failed to access climate normals",
               class = "http_error")
})

test_that("normals_extract() cleans up raw data", {
  n <- paste0("https://dd.meteo.gc.ca/climate/observations/normals/csv/",
              "1981-2010/MB/climate_normals_MB_5010480_1981-2010.csv") %>%
    normals_raw()
  expect_silent(n1 <- normals_extract(n)) %>%
    expect_is("character")
  expect_lt(length(n1), length(n))
  expect_true(stringr::str_detect(n1[1], "Jan"))
})

test_that("data_extract() / frost_extract() extract data", {
  n <- paste0("https://dd.meteo.gc.ca/climate/observations/normals/csv/",
         "1981-2010/MB/climate_normals_MB_5010480_1981-2010.csv") %>%
    normals_raw() %>%
    normals_extract()
  expect_silent(data_extract(n, climate_id = "5010480")) %>%
    expect_is("data.frame")
  expect_silent(frost_extract(n, climate_id = "5010480")) %>%
    expect_is("data.frame")
})

test_that("normals_format()/frost_format() format data to correct class", {
  n <- paste0("https://dd.meteo.gc.ca/climate/observations/normals/csv/",
              "1981-2010/MB/climate_normals_MB_5010480_1981-2010.csv") %>%
    normals_raw() %>%
    normals_extract()

  f <- frost_extract(n, climate_id = "5010480")
  n <- data_extract(n, climate_id = "5010480")

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
  expect_silent(normals_dl(climate_id = "5010480")) %>%
    expect_is("tbl_df")

  expect_silent(n <- normals_dl(climate_id = c("2403500",
                                               "5010480",
                                               "1096450"))) %>%
    expect_is("tbl_df")
  expect_equal(nrow(n), 3)
  expect_is(tidyr::unnest(n, normals), "data.frame")
  expect_is(tidyr::unnest(n, frost), "data.frame")
  expect_length(tidyr::unnest(n, normals) %>%
                  dplyr::pull(climate_id) %>%
                  unique(), 3)
  expect_length(tidyr::unnest(n, frost) %>%
                  dplyr::pull(climate_id) %>%
                  unique(), 3)
})
