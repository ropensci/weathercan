# Steps/Commands to run before a CRAN release -----------------------------

library(magrittr)
library(cchecks)
cch_pkgs_history("weathercan")$data$history %>%
  dplyr::select(date_updated, "summary")

cks <- cch_pkgs("weathercan")

cks$data$checks %>%
  dplyr::filter(!status %in% c("OK", "NOTE"))

cks$data$check_details$details %>%
  dplyr::select(flavors, output) %>%
  cat()

cchn_pkg_rule_list()
#cchn_pkg_rule_add(status = 'error', time = 2)
#cchn_pkg_rule_add(status = 'warn', time = 2)


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
file.remove("README.html")

# Update cran-comments

# Check spelling
dict <- hunspell::dictionary('en_CA')
devtools::spell_check()
spelling::update_wordlist()

## Finalize package version
v <- "0.3.5"

## Checks
devtools::check()     # Local
devtools::check(run_dont_test = TRUE)     # Local

# Win builder
devtools::check_win_release() #   <------------
devtools::check_win_devel()
devtools::check_win_oldrelease()

# Build package to check on Rhub and locally
system("cd ..; R CMD build weathercan")

rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"))

rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"),
                     check_args = "--as-cran --run-donttest",
                     platforms = c("windows-x86_64-oldrel",
                                   "windows-x86_64-devel",
                                   "windows-x86_64-release"),
                     show_status = FALSE)

rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"),
                     check_args = "--as-cran",
                     platforms = "solaris-x86-patched",
                     env_vars = c("_R_CHECK_FORCE_SUGGESTS_" = "false"),
                     show_status = FALSE)

rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"),
                     check_args = "--as-cran",
                     platforms = c("fedora-clang-devel", "fedora-gcc-devel"),
                     env_vars = c("_R_CHECK_FORCE_SUGGESTS_" = "false"),
                     show_status = FALSE)

rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"),
                     check_args = "--as-cran --run-donttest",
                     platforms = c("debian-gcc-devel",
                                   "ubuntu-gcc-devel",
                                   "ubuntu-rchk"),
                     show_status = FALSE)

system(paste0("cd ..; R CMD check weathercan_", v, ".tar.gz --as-cran --run-donttest")) # Local

# Problems with latex, open weathercan-manual.tex and compile to get actual errors
# Re-try (skip tests for speed)
#system("cd ..; R CMD check weathercan_0.3.0.tar.gz --as-cran --no-tests")

## Push to github
## Check travis / appveyor

## Check Reverse Dependencies (are there any?)
tools::dependsOnPkgs("weathercan")

## Double check
options(repos = c(CRAN = 'http://cran.rstudio.com'))
db <- available.packages()
pkgs <- rownames(db)
deps <- tools::package_dependencies(pkgs, db, which = 'all', reverse = TRUE)
deps$weathercan


## Update codemeta
codemetar::write_codemeta()


## Build site (so website uses newest version)
## Update website
## BUILD PACKAGE FIRST!
pkgdown::build_articles(lazy = FALSE)
pkgdown::build_home()
pkgdown::build_news()
pkgdown::build_reference()
pkgdown::build_site(lazy = TRUE)
unlink("./vignettes/normals_cache/", recursive = TRUE)
## Push to github

## CHECK FOR SECURITY VULNERABILITIES!


## Actually release it (SEND TO CRAN!)
devtools::release()

## Once it is released (Accepted by CRAN) create signed release on github
system("git tag -s v0.3.4 -m 'v0.3.4'")
system("git push --tags")
