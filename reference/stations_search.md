# Search for stations by name or location

Returns stations that match the name provided OR which are within `dist`
km of the location provided. This is designed to provide the user with
information with which to decide which station to then get weather data
from.

## Usage

``` r
stations_search(
  name = NULL,
  coords = NULL,
  dist = 10,
  interval = c("hour", "day", "month"),
  normals_years = NULL,
  normals_only = NULL,
  stn = NULL,
  starts_latest = NULL,
  ends_earliest = NULL,
  verbose = FALSE,
  quiet = FALSE
)
```

## Arguments

- name:

  Character. A vector of length 1 or more with text against which to
  match. Will match station names that contain all components of `name`,
  but they can be in different orders and separated by other text.

- coords:

  Numeric. A vector of length 2 with latitude and longitude of a place
  to match against. Overrides `lat` and `lon` if also provided.

- dist:

  Numeric. Match all stations within this many kilometres of the
  `coords`.

- interval:

  Character. Return only stations with data at these intervals. Must be
  any of "hour", "day", "month".

- normals_years:

  Character. One of `NULL` (default), `current`, `1991-2020`,
  `1981-2010`, or `1971-2000`. `current` returns only stations from the
  most recent *complete* normals year range (i.e. `1981-2010`). Default
  `NULL` does not filter by climate normals. Specific year ranges return
  stations with normals in that period. See Details for more specifics.

- normals_only:

  DEPRECATED. Logical. Return only stations with climate normals?

- stn:

  DEFUNCT. Now use
  [`stations_dl()`](https://docs.ropensci.org/weathercan/reference/stations_dl.md)
  to update internal data and
  [`stations_meta()`](https://docs.ropensci.org/weathercan/reference/stations_meta.md)
  to check the date it was last updated.

- starts_latest:

  Numeric. Restrict results to stations with data collection beginning
  in or before the specified year.

- ends_earliest:

  Numeric. Restrict results to stations with data collection ending in
  or after the specified year.

- verbose:

  Logical. Include progress messages

- quiet:

  Logical. Suppress all messages (including messages regarding missing
  data, etc.)

## Value

Returns a subset of the stations data frame which match the search
parameters. If the search was by location, an extra column 'distance'
shows the distance in kilometres from the location to the station. If no
stations are found withing `dist`, the closest 10 stations are returned.

## Details

To search by coordinates, users must make sure they have the
[sp](https://cran.r-project.org/package=sp) package installed.

The `current`, most recent, climate normals year range is `1981-2010`.

## Examples

``` r
if (FALSE) { # check_eccc()

stations_search(name = "Kamloops")
stations_search(name = "Kamloops", interval = "hour")

stations_search(name = "Ottawa", starts_latest = 1950, ends_earliest = 2010)

stations_search(name = "Ottawa", normals_years = "current")   # 1981-2010
stations_search(name = "Ottawa", normals_years = "1981-2010") # Same as above
stations_search(name = "Ottawa", normals_years = "1971-2000") # 1971-2010

if(requireNamespace("sf")) {
  stations_search(coords = c(53.915495, -122.739379))
}
}
```
