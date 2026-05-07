test_that("cache_dir() works on different operating systems", {
  # Test Linux
  with_mocked_bindings(
    expect_equal(cache_dir(), "~/.local/share/weathercan"),
    get_os = function() "unix",
    .package = "rappdirs"
  )

  # Test Windows
  withr::with_envvar(c("USERPROFILE" = "testcache"), {
    with_mocked_bindings(
      expect_match(cache_dir(), "weathercan"),
      get_os = function() "win",
      .package = "rappdirs"
    )
  })

  # Test macOS
  with_mocked_bindings(
    expect_match(cache_dir(), "weathercan"),
    get_os = function() "mac",
    .package = "rappdirs"
  )
})

test_that("cache_check() / cache_remove()", {
  temp_dir <- test_cache()
  local_mocked_bindings(cache_dir = function() test_cache())

  expect_false(dir.exists(temp_dir))
  expect_message(cache_check(), "Cache successfully created")
  expect_true(dir.exists(temp_dir))
  expect_message(cache_remove(), "Cache successfully removed")
  expect_false(dir.exists(temp_dir))

  # Cleanup
  unlink(test_cache(), recursive = TRUE)
})
