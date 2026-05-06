# Glossary of units and terms

A reference dataset matching information on columns in data downloaded
using the
[`weather_dl()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md)
function. Indicates the units of the data, and contains a link to the
ECCC glossary page explaining the measurement.

## Usage

``` r
glossary
```

## Format

A data frame with 77 rows and 5 variables:

- interval:

  Data interval type, 'hour', 'day', or 'month'.

- ECCC:

  Original column name when downloaded directly from ECCC

- weathercan:

  R-compatible name given when downloaded with the
  [`weather_dl()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md)
  function using the default argument `format = TRUE`.

- units:

  Units of the measurement.

- ECCC_ref:

  Link to the glossary or reference page on the ECCC website.
