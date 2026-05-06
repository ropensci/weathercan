# Glossary of terms for Climate Normals

A reference dataset matching information on general columns in older
climate normals (pre 1991-2020) data downloaded using the
[`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
function. Indicates the names and descriptions of different data
measurements.

## Usage

``` r
glossary_normals
```

## Format

A data frame with 18 rows and 3 variables:

- ECCC:

  Original measurement type from ECCC

- weathercan:

  R-compatible name given when downloaded with the
  [`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
  function

- description:

  Description of the measurement type from ECCC
