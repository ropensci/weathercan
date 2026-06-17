#' Get test cache directory path
#'
#' Returns the path to a temporary cache directory used for testing.
#'
#' @returns Character. File path to test cache directory
#'
#' @noRd

test_cache <- function() {
  file.path(tempdir(), "wc_test_cache")
}
