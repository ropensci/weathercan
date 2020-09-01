## Release v.0.4.0

* Resubmission with requested changes from CRAN (Thank you!)
* \dontrun removed where unnecessary (normals_dl example)
* Removed "quietly = TRUE" for requireNamespace() in examples
* Reset user's options in Vignettes

## Test environments
As of August 26th, 2020

* Local - ubuntu 18.04 (R 3.6.3)
* AppVeyor - Windows Server 2012 R2 64 (R 4.0.2, 4.0.2 Patched, 3.6.3)
* Travis CI - ubuntu 16.04.5 (R 4.0.0, 3.6.3, devel)
* Travis CI - OSX 10.13.6 (R 4.0.2, 3.6.3) (devel not available)
* win-builder (R oldrelease, release, devel)
* rhub - Debian GCC (R release, R patched, R devel)
* rhub - Fedora GCC (R devel)
* rhub - Fedora CLANG (R devel)
* rhub - Solaris (R patched)

## R CMD check results

Generally, there were no ERRORs, no WARNINGs, and one NOTE:

- "New submission
   Package was archived on CRAN"

Additionally, Solaris had one WARNING and one additional NOTE:

- WARNING: "‘qpdf’ is needed for checks on size reduction of PDFs"
- NOTE: "Files ‘README.md’ or ‘NEWS.md’ cannot be checked without ‘pandoc’ being installed."

## Downstream dependencies

There are no downstream dependencies
