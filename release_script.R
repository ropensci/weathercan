# Steps/Commands to run before a CRAN release -----------------------------

library(magrittr)
library(cchecks)
cch_pkgs_history("weathercan")$data$history %>%
  dplyr::select(date_updated, "summary")

cks <- cch_pkgs("weathercan")

cks$data$checks %>%
  dplyr::filter(!status %in% c("OK", "NOTE"))

cks$data$check_details$details %>%
  dplyr::mutate(output = glue::glue("{flavors}\n{output}\n\n")) %>%
  dplyr::pull(output) %>%
  cat()

cchn_pkg_rule_list()
#cchn_pkg_rule_add(status = 'error', time = 2)
#cchn_pkg_rule_add(status = 'warn', time = 2)


## Check if version is appropriate
# http://shiny.andyteucher.ca/shinyapps/rver-deps/

## Update dependencies
remotes::package_deps("weathercan", dependencies = TRUE) %>%
  update()

## Internal data files
source("data-raw/data-index.R")
source("data-raw/data-raw.R")
source("data-raw/metadata.R")

## Documentation

# Update NEWS

# Update README.Rmd
# Compile README.md
# REBUILD!
rmarkdown::render("README.Rmd")
unlink("README.html")

# Update cran-comments

# Check spelling
dict <- hunspell::dictionary('en_CA')
devtools::spell_check()
spelling::update_wordlist()

## Checks
devtools::check(run_dont_test = TRUE)     # Local

## Local Tests with vcr turned off, run in terminal
#VCR_TURN_OFF=true Rscript -e "devtools::test()"

# Win builder
devtools::check_win_release()
devtools::check_win_devel()
devtools::check_win_oldrelease()

# Build package to check on Rhub and locally
v <- "0.4.1"
system("cd ..; R CMD build weathercan")
system(paste0("cd ..; R CMD check weathercan_", v, ".tar.gz --as-cran --run-donttest")) # Local

# Check Windows
# rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"),
#                      check_args = "--as-cran --run-donttest",
#                      platforms = c("windows-x86_64-oldrel",
#                                    "windows-x86_64-devel",
#                                    "windows-x86_64-release"),
#                      show_status = FALSE,
#                      env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always"))

# Check debian
rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"),
                     check_args = "--as-cran --run-donttest",
                     platforms = c("debian-clang-devel",
                                   "debian-gcc-devel", # CRAN = r-devel-linux-x86_64-debian-gcc
                                   "debian-gcc-patched",
                                   "debian-gcc-release"), # CRAN = r-patched-linux-x86_64),
                     show_status = FALSE)

# Check fedora
rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"),
                     check_args = "--as-cran",
                     platforms = c("fedora-clang-devel",
                                   "fedora-gcc-devel"), # CRAN = r-devel-linux-x86_64-fedora-gc
                     env_vars = c("_R_CHECK_FORCE_SUGGESTS_" = "false"),
                     show_status = FALSE)

# Check solaris
rhub::check_for_cran(path = paste0("../weathercan_", v, ".tar.gz"),
                     check_args = "--as-cran",
                     platforms = "solaris-x86-patched",   # CRAN = r-patched-solaris-x86
                     env_vars = c("_R_CHECK_FORCE_SUGGESTS_" = "false"),
                     show_status = FALSE)

# Problems with latex, open weathercan-manual.tex and compile to get actual errors
# Re-try (skip tests for speed)
#system("cd ..; R CMD check weathercan_0.3.0.tar.gz --as-cran --no-tests")

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
## Check travis / appveyor / GA

## Check Reverse Dependencies (are there any?)
tools::dependsOnPkgs("weathercan")

## Double check
old <- options(repos = c(CRAN = 'http://cran.rstudio.com'))
db <- available.packages()
pkgs <- rownames(db)
deps <- tools::package_dependencies(pkgs, db, which = 'all', reverse = TRUE)
deps$weathercan
options(old)

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
system("git tag -s v0.4.0 -m 'v0.4.0'")
system("git push --tags")
