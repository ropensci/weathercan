# Get available stations

This function can be used to download a Station Inventory CSV file from
Environment and Climate Change Canada. This is only necessary if the
station you're interested was only recently added. The 'stations' data
set included in this package contains station data downloaded when the
package was last compiled. This function may take a few minutes to run.

## Usage

``` r
stations_dl(skip = NULL)
```

## Arguments

- skip:

  Numeric. Number of lines to skip at the beginning of the csv. If NULL,
  automatically derived.

## Details

The stations list is downloaded from the url stored in the option
`weathercan.urls.stations`. To change this location use
`options(weathercan.urls.stations = "your_new_url")`.

The list of which stations have climate normals is downloaded from the
url stored in the option `weathercan.urls.stations.normals`. To change
this location use `options(weathercan.urls.normals = "your_new_url")`.

Currently there are two sets of climate normals available: 1981-2010 and
1971-2000. Whether a station has climate normals for a given year range
is specified in `normals_1981_2010` and `normals_1971_2000`,
respectively.

The column `normals` represents the most current year range of climate
normals (i.e. currently 1981-2010)

@inheritSection weather_dl Verbosity

## Examples

``` r
if (FALSE) { # check_eccc()

# Update stations data frame
stations_dl()

# Updated stations data frame is now automatically used
stations_search("Winnipeg")
}
```
