## Release v.0.3.3

* The last test archived on CRAN highlighted errors on Windows and Solaris. 
  However the Windows errors related to weathercan v0.3.1 and were fixed in v0.3.2
* This patch (v0.3.3) addresses the remaining problem with testing on Solaris

## Test environments
As of Jan 29th, 2020

* Local - ubuntu 18.04 (R 3.6.2)
* AppVeyor - Windows Server 2012 R2 x86 & 64 (R 3.6.2, 3.6.2 Patched, 3.5.3)
* Travis CI - ubuntu 14.04.5 (R 3.6.1, 3.5.3, and devel)
* Travis CI - OSX 10.13.6 (R 3.6.2,  3.5.3)
* win-builder (oldrelease, release, devel)
* rhub - windows-x86_64-oldrelease, release, devel
* rhub - fedora-clang-devel, fedora-gcc-devel

## R CMD check results

There were no ERRORs, no WARNINGs, and one NOTEs

> New submission
> 
> Package was archived on CRAN

## Downstream dependencies

There are no downstream dependencies
