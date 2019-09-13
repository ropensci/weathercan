context("Climate Normals")

test_that("normals_url() correctly creates urls", {
  expect_equal(
    normals_url(prov = "MB", climate_id = c("5010480", "5010480"),
                normals_years = "1981-2010"),
    paste0("https://dd.meteo.gc.ca/climate/observations/normals/csv/1981-2010/",
           "MB/climate_normals_MB_", c("5010480", "5010480"), "_1981-2010.csv"))

  expect_error(normals_url(prov = "MB", climate_id = c("5010480", "5010480"),
                           normals_years = "1971-2000"), "Climate normals are not")

  expect_silent(h <- httr::GET(normals_url(prov = "MB", climate_id = "5010480",
                                           normals_years = "1981-2010")))
    expect_equal(httr::status_code(h), 200)
})

test_that("normals_raw() download normals as character", {
  url <- paste0("https://dd.meteo.gc.ca/climate/observations/normals/csv/",
                "1981-2010/MB/climate_normals_MB_5010480_1981-2010.csv")
  expect_silent(normals_raw(url)) %>%
    expect_is("character")
})

test_that("normals_extract() extracts data from characters", {
  n <- paste0("https://dd.meteo.gc.ca/climate/observations/normals/csv/",
         "1981-2010/MB/climate_normals_MB_5010480_1981-2010.csv") %>%
    normals_raw()
  expect_silent(normals_extract(n, climate_id = "5010480"))

})

test_that("normals_dl() downloads normals as tibble", {
  expect_silent(normals_dl(climate_id = "5010480")) %>%
    expect_is("tbl_df")
})
