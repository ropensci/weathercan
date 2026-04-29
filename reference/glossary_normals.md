# Glossary of terms for Climate Normals

A reference dataset matching information on columns in climate normals
data downloaded using the
[`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
function. Indicates the names and descriptions of different data
measurements.

## Usage

``` r
glossary_normals
```

## Format

A data frame with 18 rows and 3 variables:

- ECCC_name:

  Original measurement type from ECCC

- weathercan_name:

  R-compatible name given when downloaded with the
  [`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
  function

- description:

  Description of the measurement type from ECCC
