# Steps/Commands to run before a CRAN release -----------------------------

v <- "0.6.0"
#usethis::use_release_issue(version = v)

# Check existing errors
# https://cran.rstudio.org/web/checks/check_results_weathercan.html

hist <- cchecks::cch_pkgs_history("weathercan")$data$history
dplyr::select(hist, date_updated, "summary")

dplyr::bind_cols(dplyr::select(hist, date_updated, checks),
                 hist$summary,
                 hist$check_details) %>%
  tidyr::unnest(checks) %>%
  dplyr::filter(status %in% c("WARN", "ERROR")) %>%
  dplyr::select(-version, -tinstall, -tcheck, -ttotal, -any, -ok, -note, -warn, -error, -fail) %>%
  tidyr::unnest(details) %>%
  tidyr::unnest(additional_issues) %>%
  tidyr::unnest(donttest) %>%
  dplyr::pull(donttest) %>%
  unique()

cchecks::cch_pkgs("weathercan")$data$checks %>%
  dplyr::filter(!status %in% c("OK", "NOTE"))

cchecks::cch_pkgs("weathercan")$data$check_details$details %>%
  dplyr::mutate(output = glue::glue("{flavors}\n{output}\n\n")) %>%
  dplyr::pull(output)



## Update dependencies
remotes::package_deps("weathercan", dependencies = TRUE) %>%
  update()

## Internal data files
source("data-raw/data-index.R")
source("data-raw/data-raw.R")
source("data-raw/metadata.R")

## Documentation

# Update NEWS

# Check spelling
dict <- hunspell::dictionary('en_CA')
devtools::spell_check()
spelling::update_wordlist()

# Check test coverage
#covr::report()

# Update README.Rmd
# Compile README.md
# REBUILD!
devtools::build_readme()

# Check/update URLS
urlchecker::url_check()


## Checks
unlink("./vignettes/normals_cache/", recursive = TRUE)

# Run WITH and WITHOUT internet
devtools::run_examples(run_donttest = TRUE)
devtools::test()

devtools::check(remote = TRUE, manual = TRUE, run_dont_test = TRUE)     # Local


## Local Tests with vcr turned off, run in terminal
#VCR_TURN_OFF=true Rscript -e "devtools::test()"

# Win builder
devtools::check_win_release()
devtools::check_win_devel()
devtools::check_win_oldrelease()

# Build package to check on Rhub and locally
system("cd ..; R CMD build weathercan")
#system(paste0("cd ..; R CMD check weathercan_", v, ".tar.gz --as-cran --run-donttest")) # Local

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


# Problems with latex
# - open weathercan-manual.tex and compile to get actual errors
# - Missing `inconsolata.sty' - install.packages("tinytex"); tinytex::install_tinytex()

# Re-try (skip tests for speed)
#system("cd ..; R CMD check weathercan_0.3.0.tar.gz --as-cran --no-tests")


# Update cran-comments


## Update codemeta
codemetar::write_codemeta()

## Build site (so website uses newest version)
## Update website
## BUILD PACKAGE FIRST!
#pkgdown::build_articles(lazy = TRUE)
# pkgdown::build_home()
# pkgdown::build_news()
# pkgdown::build_reference()
pkgdown::build_site(lazy = TRUE)
pkgdown::build_articles(lazy = FALSE)
unlink("./vignettes/normals_cache/", recursive = TRUE)



## Push to github
## Check GitHub Actions

## Check Reverse Dependencies (are there any?)
tools::dependsOnPkgs("weathercan")

revdepcheck::revdep_check(num_workers = 4)

## Double check
old <- options(repos = c(CRAN = 'http://cran.rstudio.com'))
db <- available.packages()
pkgs <- rownames(db)
deps <- tools::package_dependencies(pkgs, db, which = 'all', reverse = TRUE)
deps$weathercan
options(old)


## Push to github

## Actually release it (SEND TO CRAN!)
devtools::release()

## Once it is released (Accepted by CRAN) create signed release on github
usethis::use_github_release()

# Prep for next
usethis::use_dev_version()
