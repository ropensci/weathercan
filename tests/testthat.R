library(testthat)
library(weathercan)

Sys.setenv("R_TESTS" = "")

test_check("weathercan")
