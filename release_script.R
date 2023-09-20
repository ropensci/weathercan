# Steps/Commands to run before a CRAN release -----------------------------

version <- "0.7.0"
#usethis::use_release_issue(version = v)


# Good practices --------------------
goodpractice::gp()


## Update dependencies
update(remotes::package_deps("weathercan", dependencies = TRUE))

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

# Precompile Vignettes
source("vignettes/precompile.R")

# Run WITH and WITHOUT internet
#devtools::run_examples(run_donttest = TRUE)
#devtools::test()

# Local tests, as CRAN and not as CRAN
devtools::check(remote = TRUE, manual = TRUE, run_dont_test = TRUE,
                env_vars = list("NOT_CRAN" = ""))
devtools::check(remote = TRUE, manual = TRUE, run_dont_test = TRUE)


## Update codemeta
codemetar::write_codemeta()

## Build site (so website uses newest version)
## Update website
## BUILD PACKAGE FIRST!
#pkgdown::build_articles(lazy = TRUE)
# pkgdown::build_home()
# pkgdown::build_news()
# pkgdown::build_reference()
#pkgdown::build_articles(lazy = FALSE)

pkgdown::build_site(lazy = FALSE)

## Once it is released create signed release on github
usethis::use_github_release()

# Prep for next
usethis::use_dev_version()








# CRAN workflow ---------------------------------
# TURN OFF INTERNET AND TRY AGAIN
devtools::check(remote = TRUE, manual = TRUE, run_dont_test = TRUE,
                env_vars = list("NOT_CRAN" = ""))

# Win builder
devtools::check_win_release()
devtools::check_win_devel()
devtools::check_win_oldrelease()

# Build package to check on Rhub and locally
system("cd ..; R CMD build weathercan")
#system(paste0("cd ..; R CMD check weathercan_", version, ".tar.gz --as-cran --run-donttest")) # Local

# Check Windows
rhub::check_for_cran(path = paste0("../weathercan_", version, ".tar.gz"),
                     check_args = "--as-cran --run-donttest",
                     platforms = c("windows-x86_64-oldrel",
                                   "windows-x86_64-devel",
                                   "windows-x86_64-release"),
                     show_status = FALSE)
##                     env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always"))

# Check debian
rhub::check_for_cran(path = paste0("../weathercan_", version, ".tar.gz"),
                     check_args = "--as-cran --run-donttest",
                     platforms = c("debian-clang-devel",
                                   "debian-gcc-devel", # CRAN = r-devel-linux-x86_64-debian-gcc
                                   "debian-gcc-patched",
                                   "debian-gcc-release"), # CRAN = r-patched-linux-x86_64),
                     show_status = FALSE)

# Check fedora
rhub::check_for_cran(path = paste0("../weathercan_", version, ".tar.gz"),
                     check_args = "--as-cran",
                     platforms = c("fedora-clang-devel",
                                   "fedora-gcc-devel"), # CRAN = r-devel-linux-x86_64-fedora-gc
                     env_vars = c("_R_CHECK_FORCE_SUGGESTS_" = "false"),
                     show_status = FALSE)

# Check solaris
rhub::check_for_cran(path = paste0("../weathercan_", version, ".tar.gz"),
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





## Push to github
## Check GitHub Actions

## Check Reverse Dependencies (are there any?)
#tools::dependsOnPkgs("weathercan")

# Check RavenR which suggests weathercan
#weathercan::kamloops_day %>%
#  RavenR::rvn_rvt_write_met(metdata = .,
#                            filenames = file.path(tempdir(), "rvn_rvt_metfile.rvt"),
#                            filename_stndata = file.path(tempdir(), "met_stndata.rvt"))
# Warnings about NA okay

## Push to github

## Actually release it (SEND TO CRAN!)
#devtools::release()

## Once it is released (Accepted by CRAN) create signed release on github
usethis::use_github_release()

# Prep for next
usethis::use_dev_version()




# Appendix --------------

# Check existing errors
# https://cran.rstudio.org/web/checks/check_results_weathercan.html

hist <- cchecks::cch_pkgs_history("weathercan")$data$history
dplyr::select(hist, date_updated, "summary")

dplyr::bind_cols(dplyr::select(hist, date_updated, checks),
                 hist$summary,
                 hist$check_details) %>%
  dplyr::filter(stringr::str_detect(date_updated, "2021-05-18")) %>%
  tidyr::unnest(checks) %>%
  dplyr::filter(status %in% c("WARN", "ERROR")) %>%
  dplyr::select(-version, -tinstall, -tcheck, -ttotal, -any,
                -ok, -note, -warn, -error, -fail) %>%
  tidyr::unnest(details) %>%
  dplyr::pull(output) %>%
  unique()

cchecks::cch_pkgs("weathercan")$data$checks %>%
  dplyr::filter(!status %in% c("OK", "NOTE"))

cchecks::cch_pkgs("weathercan")$data$check_details$details %>%
  dplyr::mutate(output = glue::glue("{flavors}\n{output}\n\n")) %>%
  dplyr::pull(output)
