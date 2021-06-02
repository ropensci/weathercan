## Release v.0.6.1

* Switch from stations_dl() function asks users to store data in cache (doesn't run during tests or setup)
* Don't test get_check() on CRAN because requires internet

## Test environments
As of June 3rd, 2021

ubuntu
* 18.04 - Local (4.0.3)
* 16.04 - GitHub Actions (devel, release, old release)

OSX
* 10.15.7 - GitHub Actions (release)

Windows 
* Windows Server 2019 x64 - GitHub Actions (release, old release)
* Windows Server 2008 x64 - win-builder (devel, release, old release)

Other
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
