# Steps/Commands to run before a CRAN release -----------------------------

## Check if version is appropriate
# http://shiny.andyteucher.ca/shinyapps/rver-deps/

## Internal data files
source("data-raw/data-raw.R")
source("data-raw/data-index.R")

## Documentation
# Update NEWS
# Update cran-comments

# Check spelling
dict <- hunspell::dictionary('en_CA')
devtools::spell_check()
spelling::update_wordlist()

## Finalize package version

## Update codemeta
codemetar::write_codemeta()

## Checks
devtools::check()     # Local

#devtools::check_win_release() # Win builder
devtools::check_win_devel()
devtools::check_win_oldrelease()

system("cd ..; R CMD build weathercan")
system("cd ..; R CMD check weathercan_0.3.0.tar.gz --as-cran --run-donttest")
rhub::check_for_cran(path = "../weathercan_0.3.0.tar.gz",
                     check_args = "--as-cran --run-donttest",
                     platforms = "windows-x86_64-devel")

# Problems with latex, open weathercan-manual.tex and compile to get actual errors
# Re-try (skip tests for speed)
#system("cd ..; R CMD check weathercan_0.3.0.tar.gz --as-cran --no-tests")

## Push to github
## Check travis / appveyor

## Check Reverse Dependencies (are there any?)
tools::dependsOnPkgs("weathercan")
devtools::revdep()

## Build site (so website uses newest version
## Update website
pkgdown::build_site(lazy = TRUE)
## Push to github

## CHECK FOR SECURITY VULNERABILITIES!

## Actually release it (SEND TO CRAN!)
devtools::release()

## Once it is released (Accepted by CRAN) create signed release on github
system("git tag -s v0.2.8 -m 'v0.2.8'")
system("git push --tags")
