# Index of variables for new Climate Normals

An index matching variables named in weathercan and downloaded with the
[`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
function to those in the original *new* (1991-2020) climate normals data
from ECCC.

## Usage

``` r
variables_normals_new
```

## Format

A data frame with 18 rows and 3 variables:

- measurement_type:

  Measurement category

- ECCC:

  Original variable name from ECCC

- weathercan:

  R-compatible name given when formating the data with the
  [`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
  function
