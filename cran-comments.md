## Release v.0.5.0

* Internal fixes for changes made to ECCC weather and normals data

## Test environments
As of Jan 14th, 2021

ubuntu
* 18.04 - Local (R 4.0.3)
* 16.04.6 - Travis CI (R 4.0.4, 3.6.3, devel)

OSX
* 10.13.6 - Travis CI (R 4.0.2, 3.6.3)
* 10.15.7 - GitHub Actions (R 4.0.3)

Windows 
* Windows Server 2012 r2 64 - AppVeyor (R 4.0.3, 4.0.3 Patched, 3.6.3)
* Windows Server x64 - GitHub Actions (R 4.0.3)
* Windows Server x64 - GitHub Actions (R 3.6.3)
* win-builder (R oldrelease, release, devel)

Other
* Debian GCC - rhub (R release, R patched, R devel)
* Fedora GCC - rhub (R devel)
* Fedora CLANG - rhub (R devel)
* Solaris - rhub (R patched)

## R CMD check results

Generally, there were no ERRORs, no WARNINGs, no NOTEs:

Fedora had one NOTEs:
* Package suggested but not available for checking: ‘sf’

Solaris had two NOTEs:
* Packages suggested but not available for checking: 'devtools', 'sf'
* Files ‘README.md’ or ‘NEWS.md’ cannot be checked without ‘pandoc’ being installed.

## Downstream dependencies

* RavenR suggests weathercan, I checked and found no problems
