# Steps/Commands to run before a CRAN release -----------------------------

#usethis::use_release_issue(version = version)

gert::git_pull()
urlchecker::url_check()

## Update dependencies
pak::local_install_deps(dependencies = TRUE)

## Update internal data files
source("data-raw/data-index.R")
source("data-raw/data-raw.R")
source("data-raw/metadata.R")

## Documentation

# Update NEWS
file.edit("NEWS.md")

# Check spelling
dict <- hunspell::dictionary('en_CA')
devtools::spell_check()
spelling::update_wordlist()

# Check URLS
urlchecker::url_check()

# Check test coverage
#covr::report()

# Update README.Rmd
devtools::build_readme()

# Update Contributors
allcontributors::add_contributors()

## Update codemeta
codemetar::write_codemeta()

# Precompile Vignettes - BUILD PACKAGE FIRST!
source("vignettes/precompile.R")

## Build site (so website uses newest version)
## Update website
## BUILD PACKAGE FIRST!
#pkgdown::build_articles(lazy = TRUE)
# pkgdown::build_home()
# pkgdown::build_news()
# pkgdown::build_reference()
#pkgdown::build_articles(lazy = FALSE)

pkgdown::build_site(lazy = FALSE)


## Checks
# Run WITH and WITHOUT internet

devtools::run_examples(run_donttest = TRUE)
devtools::test()


# Local tests
devtools::check(cran = FALSE, manual = TRUE, run_dont_test = TRUE)
devtools::check(
  cran = FALSE,
  manual = TRUE,
  args = c("--no-examples", "--no-tests")
) # Quick re-check as needed
devtools::check_win_devel()


# Finalize -------------------------------------------------

## Merge when ready!
usethis::pr_view()

## Once merged close branch
usethis::pr_finish()

## Once it is released create signed release on github
usethis::use_github_release()

## Prep for next
usethis::pr_init("dev")
usethis::use_dev_version()
usethis::pr_push()


# Good practices --------------------
goodpractice::gp()


# Build package to check on Rhub and locally
system("cd ..; R CMD build weathercan")
#system(paste0("cd ..; R CMD check weathercan_", version, ".tar.gz --as-cran --run-donttest")) # Local

# Check Windows
rhub::check_for_cran(
  path = paste0("../weathercan_", version, ".tar.gz"),
  check_args = "--as-cran --run-donttest",
  platforms = c(
    "windows-x86_64-oldrel",
    "windows-x86_64-devel",
    "windows-x86_64-release"
  ),
  show_status = FALSE
)
##                     env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always"))

# Check debian
rhub::check_for_cran(
  path = paste0("../weathercan_", version, ".tar.gz"),
  check_args = "--as-cran --run-donttest",
  platforms = c(
    "debian-clang-devel",
    "debian-gcc-devel", # CRAN = r-devel-linux-x86_64-debian-gcc
    "debian-gcc-patched",
    "debian-gcc-release"
  ), # CRAN = r-patched-linux-x86_64),
  show_status = FALSE
)

# Check fedora
rhub::check_for_cran(
  path = paste0("../weathercan_", version, ".tar.gz"),
  check_args = "--as-cran",
  platforms = c("fedora-clang-devel", "fedora-gcc-devel"), # CRAN = r-devel-linux-x86_64-fedora-gc
  env_vars = c("_R_CHECK_FORCE_SUGGESTS_" = "false"),
  show_status = FALSE
)


## Once it is released create signed release on github
usethis::use_github_release()

# Prep for next
usethis::use_dev_version()
