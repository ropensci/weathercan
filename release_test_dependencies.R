# Testing dependency package versions

# Test min version of tidyr
remotes::install_version("tidyr", "0.8.0")
remotes::install_version("rlang", "0.3.2")
packageVersion("tidyr")
packageVersion("rlang")
devtools::test()
install.packages("tidyr")

# Test current version
devtools::test()
