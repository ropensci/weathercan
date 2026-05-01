test_that("normals_file()", {
  expect_silent(normals_file())
  expect_type(normals_file(), "character")
})

test_that("normals_cached_dl()", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(cache_dir = function() test_cache())

  expect_message(
    n <- normals_cached_dl(),
    "Cache successfully created"
  ) |>
    expect_message("Downloading 1991-2020 Canadian Climate Normals") |>
    expect_message("Unzipping") |>
    expect_message("Climate normals for 1991-2020 successfully downloaded")

  expect_true(normals_cached_check())
})

test_that("normals_cached_location()", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(cache_dir = function() test_cache())

  expect_equal(
    normals_cached_location(c("502S001", "5023227", "5023222")),
    "WINNIPEG RICHARDSON (AIRPORT)"
  ) |>
    expect_message("Using composite locations:")

  expect_equal(
    normals_cached_location(c("5010480", "5023222")),
    c("BRANDON", "WINNIPEG RICHARDSON (AIRPORT)")
  ) |>
    expect_message("Using composite locations:")
})

test_that("normals_cached()", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(cache_dir = function() test_cache())

  expect_message(
    n <- normals_cached(climate_ids = "5010480"),
    "Using composite locations"
  )
  expect_s3_class(n, "data.frame")
  expect_all_true(
    c(
      "location_name",
      "prov",
      "composite_stations",
      "period_of_record",
      "element_group",
      "period"
    ) %in%
      names(n)
  )
})


test_that("normals_dl() - multi 1991", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(cache_dir = function() test_cache())

  expect_message(
    n <- normals_dl(
      climate_id = c("2403500", "5010480", "1096450"),
      normals_years = "1991-2020"
    ),
    "Using composite locations"
  )
  expect_s3_class(n, c("tbl_df", "data.frame"))
  expect_all_true(
    c(
      "location_name",
      "prov",
      "composite_stations",
      "period_of_record",
      "element_group",
      "period"
    ) %in%
      names(n)
  )
})

unlink(test_cache(), recursive = TRUE)
