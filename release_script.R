# Steps/Commands to run before a CRAN release -----------------------------

## Check if version is appropriate
# http://shiny.andyteucher.ca/shinyapps/rver-deps/

## Internal data files
source("data-raw/data-raw.R")
source("data-raw/data-index.R")

## Checks
devtools::check()     # Local
devtools::build_win() # Win builder

library(rhub)
check_on_debian()
check_on_windows()
check_on_ubuntu()
check_on_macos()

## Run in console
system("cd ..; R CMD build weathercan")
system("cd ..; R CMD check weathercan_0.2.7.tar.gz --as-cran")

## Update codemeta
codemetar::write_codemeta()

## Documentation
# Update NEWS
# Update cran-comments

# Check spelling
dict <- hunspell::dictionary('en_CA')
devtools::spell_check()

## Push to github
## Check travis / appveyor

## Update website
## Push to github

## Actually release it (SEND TO CRAN!)
devtools::release()

## Once it is released (Accepted by CRAN) create signed release on github
system("git tag -s v0.2.7 -m 'v0.2.7'")
system("git push --tags")
