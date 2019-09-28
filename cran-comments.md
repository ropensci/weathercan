## Release v.0.3.1

* This is a patch following quickly after a major release (~3 days)
* The format of the data at source changed suddenly and unexpectedly the day after v0.3.0 was pushed to CRAN (this was bad luck, not data source that is prone to constant changes)
* Changes made fix the package to work with the newly formated data

## Test environments
As of Sept 28th, 2019

* Local - ubuntu 18.04 (R 3.6.1)
* Travis CI - ubuntu 14.04.5 (R 3.6.1, 3.5.3, and devel)
* Travis CI - OSX 10.13.3 (R 3.6.1,  3.5.3)
* win-builder (oldrelease, release, devel)
* rhub - windows-x86_64-oldrelease, release, devel

## R CMD check results

There were no ERRORs, no WARNINGs, and 1 NOTEs

"NOTE: Days since last update: 3"

## Downstream dependencies

There are no downstream dependencies
