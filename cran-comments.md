## Release v.0.6.1

* Switch from stations_dl() function asks users to store data in cache (doesn't run during tests or setup)
* Don't test get_check() on CRAN because requires internet
* Uses vcr v1.0.2 to avoid test directory problems

## Test environments
As of June 4th, 2021

* ubuntu 20.04 - Local (4.1.0)
* ubuntu 16.04 - GitHub Actions (devel, release, old release)
* OSX 10.15.7 - GitHub Actions (release)
* Windows Server 2019 x64 - GitHub Actions (devel, release, old release)
* Debian GCC - rhub (release, patched, devel)
* Debian CLANG - rhub (devel)
* Fedora GCC - rhub (devel)
* Fedora CLANG - rhub (devel)
* Solaris - rhub (release)

## R CMD check results

There were no ERRORs and no WARNINGs

2 NOTEs:

Debian GCC (patched and devel) had one NOTE:
* checking for future file timestamps ... NOTE
  unable to verify current time

Solaris had one NOTEs:
* checking top-level files ... NOTE
  Files ‘README.md’ or ‘NEWS.md’ cannot be checked without ‘pandoc’ being installed.

## Downstream dependencies

* RavenR suggests weathercan, I checked and found no problems
