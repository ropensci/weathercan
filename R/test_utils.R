test_404 <- function() {
  structure(
    list(
      date = Sys.time(),
      status_code = 404,
      url = "http://example.com"
    ),
    class = "response"
  )
}

test_cache <- function() {
  file.path(tempdir(), "wc_test_cache")
}
