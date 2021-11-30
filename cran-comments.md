## Release v.0.6.2

* General changes to avoid CRAN policy violations, namely, errors when API is inaccessible:
  * Use @examplesIf to ONLY run examples if resources are available 
     (I believe this was the problem that resulted in archival)
  * Avoid tests where API calls used (even if mocking, or using vcr)
  * Pre-compiled the vignettes which rely on the API
* Fixed minor bugs with new stations data
* Increased robustness to ECCC data changes

## Test environments
As of November 30th, 2021

* ubuntu 20.04 - Local (4.1.1), GitHub Actions (devel, release, old release)
* Windows Server - GitHub Actions (release), winbuilder (devel), rhub (devel, release, old release)
* OSX 11.6.1 - GitHub Actions (release)
* Solaris - rhub (release)
* Fedora GCC - rhub (devel)
* Fedora CLANG - rhub (devel)
* Debian CLANG - rhub (devel)
* Debian GCC - rhub (release, patched, devel)


## R CMD check results

There were no ERRORs and no WARNINGs

In addition to the NOTE that this is a new submission:

1 NOTEs:

Solaris had one NOTEs:
* checking top-level files ... NOTE
  Files ‘README.md’ or ‘NEWS.md’ cannot be checked without ‘pandoc’ being installed.

## Downstream dependencies

* RavenR suggests weathercan, I checked and found no problems
