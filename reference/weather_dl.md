# Download weather data from Environment and Climate Change Canada

Downloads data from Environment and Climate Change Canada (ECCC) for one
or more stations. For details and units, see the glossary vignette
([`vignette("glossary", package = "weathercan")`](https://docs.ropensci.org/weathercan/articles/glossary.md))
or the glossary online <https://climate.weather.gc.ca/glossary_e.html>.

## Usage

``` r
weather_dl(
  station_ids,
  start = NULL,
  end = NULL,
  interval = "hour",
  months = NULL,
  trim = TRUE,
  trim_by_stn = FALSE,
  format = TRUE,
  string_as = NA,
  time_disp = "none",
  encoding = "UTF-8",
  list_col = FALSE
)
```

## Arguments

- station_ids:

  Numeric/Character. A vector containing the ID(s) of the station(s) you
  wish to download data from. See the
  [`stations`](https://docs.ropensci.org/weathercan/reference/stations.md)
  data frame or the
  [`stations_search`](https://docs.ropensci.org/weathercan/reference/stations_search.md)
  function to find IDs.

- start:

  Date/Character. The start date of the data in YYYY-MM-DD format
  (applies to all stations_ids). Defaults to start of range.

- end:

  Date/Character. The end date of the data in YYYY-MM-DD format (applies
  to all station_ids). Defaults to end of range.

- interval:

  Character. Interval of the data, one of "hour", "day", "month".

- months:

  Numeric vector. Can supply 1-12 to optionally filter the data to only
  specific months. For "hour" interval, this selectively downloads data
  by month so can speed up downloads. For intervals of "day" and "month"
  this only filters the data after full years or full data ranges have
  been downloaded.

- trim:

  Logical. Trim missing values from the start and end of the weather
  dataframe. Only applies if `format = TRUE`

- trim_by_stn:

  Logical. Data from different stations are generally padded with NAs to
  have the same date range. If this isn't desirable, use `trim = TRUE`
  and `trim_by_stn = TRUE` to trim `NA`s from the start and end of each
  station. `trim_by_stn = FALSE` (default), only the sides of the entire
  range are trimmed.

- format:

  Logical. If TRUE, formats data for immediate use. If FALSE, returns
  data exactly as downloaded from Environment and Climate Change Canada.
  Useful for dealing with changes by Environment Canada to the format of
  data downloads.

- string_as:

  Character. What value to replace character strings in a numeric
  measurement with. See Details.

- time_disp:

  Character. Either "none" (default) or "UTC". See details.

- encoding:

  Character. Text encoding for download.

- list_col:

  Logical. Return data as nested data set? Defaults to FALSE. Only
  applies if `format = TRUE`

## Value

A tibble with station ID, name and weather data.

## Details

Data can be returned 'raw' (format = FALSE) or can be formatted.
Formatting transforms dates/times to date/time class, renames columns,
and converts data to numeric where possible. If character strings are
contained in traditionally numeric fields (e.g., weather speed may have
values such as "\< 30"), they can be replaced with a character specified
by `string_as`. The default is NA. Formatting also replaces data
associated with certain flags with NA (M = Missing), if they are not
already marked as NA.

Start and end date can be specified, but if not, it will default to the
start and end date of the range (this could result in downloading a lot
of data!).

For hourly data, timezones are always marked "UTC", but the actual times
are either local time (default; `time_disp = "none"`), or UTC
(`time_disp = "UTC"`). When `time_disp = "none"`, times reflect the
local time without daylight savings. This means that relative measures
of time, such as "nighttime", "daytime", "dawn", and "dusk" are
comparable among stations in different timezones. This is useful for
comparing daily cycles. When `time_disp = "UTC"` the times are
transformed into UTC timezone. Thus midnight in Kamloops would register
as 08:00:00 (Pacific time is 8 hours behind UTC). This is useful for
tracking weather events through time, but will result in odd 'daily'
measures of weather (e.g., data collected in the afternoon on Sept 1 in
Kamloops will be recorded as being collected on Sept 2 in UTC).

Files are downloaded from the url stored in
`getOption("weathercan.urls.weather")`. To change this location use
`options(weathercan.urls.weather = "your_new_url")`.

Data is downloaded from ECCC as a series of files which are then bound
together. Each file corresponds to a different month, or year, depending
on the interval. Metadata (station name, lat, lon, elevation, etc.) is
extracted from the start of the most recent file (i.e. most recent
dates) for a given station. Note that important data (i.e. station name,
lat, lon) is unlikely to change between files (i.e. dates), but some
data may or may not be available depending on the date of the file
(e.g., station operator was added as of April 1st 2018, so will be in
all data which includes dates on or after April 2018).

## Verbosity

Verbosity (how 'chatty' weathercan is) can be specified using the option
`weathercan.verbosity`. Which takes "standard" (default), "quiet"
(suppress all messages including those regarding missing data, etc.), or
"verbose" (extra progress messages).

## Examples

``` r
if (FALSE) { # check_eccc()

kam <- weather_dl(station_ids = 51423,
                  start = "2016-01-01", end = "2016-02-15")

stations_search("Kamloops A$", interval = "hour")
stations_search("Prince George Airport", interval = "hour")

kam.pg <- weather_dl(station_ids = c(48248, 51423),
                     start = "2016-01-01", end = "2016-02-15")

library(ggplot2)

ggplot(data = kam.pg, aes(x = time, y = temp,
                          group = station_name,
                          colour = station_name)) +
       geom_line()

# Download only January and December
kam <- weather_dl(
  station_ids = 51423,
  start = "2016-01-01",
  end = "2018-02-15",
  months = c(1, 10)
)
}
```
