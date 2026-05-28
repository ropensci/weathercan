# Download climate normals from Environment and Climate Change Canada

Downloads climate normals from Environment and Climate Change Canada
(ECCC) for one or more stations (defined by `climate_id`s). For details
and units, see the
[`glossary_normals`](https://docs.ropensci.org/weathercan/reference/glossary_normals.md),
[`variables_normals_old`](https://docs.ropensci.org/weathercan/reference/variables_normals_old.md),
and
[`variables_normals_new`](https://docs.ropensci.org/weathercan/reference/variables_normals_new.md)
included data sets and/or the `glossary_normals` vignette:
[`vignette("glossary_normals", package = "weathercan")`](https://docs.ropensci.org/weathercan/articles/glossary_normals.md).

## Usage

``` r
normals_dl(climate_ids, normals_years = "current", format = TRUE)
```

## Arguments

- climate_ids:

  Character. A vector containing the Climate ID(s) of the station(s) you
  wish to download data from. See the
  [`stations()`](https://docs.ropensci.org/weathercan/reference/stations.md)
  data frame or the
  [`stations_search()`](https://docs.ropensci.org/weathercan/reference/stations_search.md)
  function to find Climate IDs.

- normals_years:

  Character. The year range for which you want climate normals. Default
  `current` (i.e. 1991-2020). One of `current`, `1991-2020`,
  `1981-2010`, or `1971-2000`. `current` returns only stations from the
  most recent *complete* normals year range (i.e. `1991-2020`).

- format:

  Logical. If TRUE (default) formats measurements to numeric and date
  accordingly. Unlike
  [`weather_dl()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md),
  `normals_dl()` will always format column headings as normals data from
  ECCC cannot be directly made into a data frame without doing so.

## Value

For new climate normals, a tibble of normals. For older climate normals,
a tibble with *nested* normals and first/last frost data.

## Details

The format and method of downloading climate normals from ECCC varies by
year span.

Regardless of year, each normals measurement column has a corresponding
`_code` column which reflects the data quality of that measurement (see
the
[1991-2020](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1991_2020_Calculation_Information.pdf),
[1981-2010](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1981_2010_Calculation_Information.pdf),
or
[1971-2000](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1971_2000_Calculation_Information.pdf)
for more details) ECCC calculation documents.

### Newer normals (1991-2020)

Newer normals from ECCC are provided in one bulk downloaded which
weathercan will fetch and store in a local cache directory
([`cache_dir()`](https://docs.ropensci.org/weathercan/reference/cache_dir.md)).
Then `normals_dl()` will read, filter, format, and return the climate
normals in a data frame easier to work with in R than the original data.

These normals are also provided in a single table, so both 'normals' and
'frost' data are combined in one.

Newer climate normals are downloaded from the url stored in option
`weathercan.urls.normals_1991_2020`. To change this location use:
`options(weathercan.urls.normals_1991_2020 = "your_new_url")`.

### Older normals (1981-2010 and earlier)

Older normals from ECCC are provided by individual file downloads which
weathercan will fetch, format and return as requested (no local on-disk
cache storage).

These older normals also include two separate data types: averages by
month for a variety of measurements as well as data relating to the
frost-free period. Because these two data sources are quite different,
we return them as nested data so the user can extract them as they wish.
See examples for how to use the
[`unnest()`](https://tidyr.tidyverse.org/reference/unnest.html) function
from the [`tidyr`](https://tidyr.tidyverse.org/) package to extract the
two different datasets.

The data also returns a column called `meets_wmo` this reflects whether
or not the climate normals for this station met the WMO standards for
temperature and precipitation (i.e. both have code \>= A).

Older climate normals are downloaded from the url stored in option
`weathercan.urls.normals`. To change this location use:
`options(weathercan.urls.normals = "your_new_url")`.

@inheritSection weather_dl Verbosity

## Examples

``` r
if (FALSE) { # check_eccc()

# Find the climate_id
stations_search("Brandon A", normals_years = "current")

# Download climate normals 1991-2020 ("current" normals)
n <- normals_dl(climate_ids = "5010480")
n

# Download multiple climate Ids - But only one location!
# - 1990-2010 normals use composite stations
stations_search("Winnipeg", normals_years = "current")
n <- normals_dl(climate_ids = c("502S001", "5023227", "5023222"))
unique(dplyr::select(n, "location_name", "composite_stations"))

# Download multiple climate Ids
n <- normals_dl(climate_ids = c("5010480", "5023222"))
unique(dplyr::select(n, "location_name", "composite_stations"))

# Download climate normals 1981-2010
# - Note: Very different data format from current normals!
n <- normals_dl(climate_ids = "5010480", normals_years = "1981-2010")

# Pull out last frost data *with* station information
library(tidyr)
f <- unnest(n, frost)
f

# Pull out normals *with* station information
nm <- unnest(n, normals)
nm

# Download climate normals 1971-2000
n <- normals_dl(climate_ids = "5010480", normals_years = "1971-2000")
n

# Note that some do not have last frost dates
n$frost

# Download multiple stations for 1981-2010,
n <- normals_dl(
  climate_ids = c("301C3D4", "301FFNJ", "301N49A"),
  normals_years = "1981-2010"
)
unnest(n, frost)

# Note, putting both normals and frost data into the same data set can be
# done, but makes for a very unweildly dataset (there is lots of repetition).
nm <- unnest(n, normals) |>
  unnest(frost)
}
```
