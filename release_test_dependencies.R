# Testing dependency package versions

# Test min version of tidyr
remotes::install_version("tidyr", "0.8.0")
packageVersion("tidyr")
devtools::test()
install.packages("tidyr")

# Test current version
devtools::test()
