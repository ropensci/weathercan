# Access Station data downloaded from Environment and Climate Change Canada

This function access the built-in stations data frame. You can update
this data frame with
[`stations_dl()`](https://docs.ropensci.org/weathercan/reference/stations_dl.md)
which will update the locally stored data.

## Usage

``` r
stations()
```

## Format

A data frame:

- prov:

  Province

- station_name:

  Station name

- station_id:

  Environment Canada's station ID number. Required for downloading
  station data.

- climate_id:

  Climate ID number

- WMO_id:

  Climate ID number

- TC_id:

  Climate ID number

- lat:

  Latitude of station location in degree decimal format

- lon:

  Longitude of station location in degree decimal format

- elev:

  Elevation of station location in metres

- tz:

  Local timezone excluding any Daylight Savings

- interval:

  Interval of the data measurements ('hour', 'day', 'month')

- start:

  Starting year of data record

- end:

  Ending year of data record

- normals:

  Whether *any* climate normals are available for that station (new
  behaivour)

- normals_1991_2020:

  Whether 1991-2020 climate normals are available for that station.
  **Note** that even if available, these are not yet downloadable via
  weathercan.

- normals_1981_2010:

  Whether 1981-2010 climate normals are available for that station

- normals_1971_2000:

  Whether 1971-2000 climate normals are available for that station

## Source

<https://climate.weather.gc.ca/index_e.html>

## Details

You can check when this was last updated with
[`stations_meta()`](https://docs.ropensci.org/weathercan/reference/stations_meta.md).

A dataset containing station information downloaded from Environment and
Climate Change Canada. Note that a station may have several station IDs,
depending on how the data collection has changed over the years. Station
information can be updated by running
[`stations_dl()`](https://docs.ropensci.org/weathercan/reference/stations_dl.md).

## Examples

``` r
if (FALSE) { # check_eccc()
stations()
stations_meta()

# Which Manitoba stations have *any* climate normals?

library(dplyr)
filter(stations(), interval == "hour", normals == TRUE, prov == "MB")
}
```
