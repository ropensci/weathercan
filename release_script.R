# Steps/Commands to run before a CRAN release -----------------------------

## Check if version is appropriate
# http://shiny.andyteucher.ca/shinyapps/rver-deps/

## Internal data files
source("data-raw/data-raw.R")
source("data-raw/data-index.R")

## Documentation
# Update NEWS
# Update README.Rmd
# Compile README.md
# REBUILD!
rmarkdown::render("README.Rmd")
# Update cran-comments

# Check spelling
dict <- hunspell::dictionary('en_CA')
devtools::spell_check()
spelling::update_wordlist()

## Finalize package version
v <- "0.3.2"

## Checks
devtools::check()     # Local

system("cd ..; R CMD build weathercan")
system(paste0("cd ..; R CMD check weathercan_", v, ".tar.gz --as-cran --run-donttest")) # Local

rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"),
                     check_args = "--as-cran --run-donttest",
                     platforms = c("windows-x86_64-oldrel",
                                   "windows-x86_64-devel",
                                   "windows-x86_64-release"),
                     show_status = FALSE)

devtools::check_win_release() # Win builder
devtools::check_win_devel()
devtools::check_win_oldrelease()

rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"),
                     check_args = "--as-cran --run-donttest",
                     platforms = "solaris-x86-patched",
                     show_status = FALSE)

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
pkgdown::build_articles(lazy = FALSE)
pkgdown::build_home()
pkgdown::build_news()
pkgdown::build_reference()
pkgdown::build_site(lazy = TRUE)
## Push to github

## CHECK FOR SECURITY VULNERABILITIES!

## Update codemeta
codemetar::write_codemeta()


## Actually release it (SEND TO CRAN!)
devtools::release()

## Once it is released (Accepted by CRAN) create signed release on github
system("git tag -s v0.3.2 -m 'v0.3.2'")
system("git push --tags")
