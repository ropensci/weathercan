---
title: "News"
author: "Steffi LaZerte"
output: html_document
---

# weathercan 0.2.7 (2018-06-27)

## Bug fixes
- Fix bug created when ECCC changed file metadata for dates after April 1st 2018 (only affected downloads which included dates both before AND after April 1st, 2018) - Results in a new column `station_operator` for all data (NA where unavailable for older stations).
- Adjust code flexibility to handle future changes
- Add catch to warn user if end dates earlier than start dates

## Changes
- Update readme/vignettes/internal data sets to include new columns
- Update internal `stations` data frame as well as `flags` and `glossary`
- Remove `tibble` dependency by relying on `dplyr`

# weathercan 0.2.6 (2018-05-25)

## Bug fixes
- Fix bug created when ECCC removed Data Quality Column
- Adjust code flexibility to handle future changes
- Add tests to catch future changes

# weathercan 0.2.5 (2018-03-02)

## Changes
- More sensible messages when missing station data
- Streamline messages from multiple stations
- Accepts older R version
- `stations_dl` fails gracefully on R versions < 3.3.4
- Update `stations` dataframe

## Bug fixes
- Fix error when missing station data from one of several stations

# weathercan 0.2.4 (2018-02-01)

Now part of [ropensci.org](http://ropensci.org)!

## Changes
- `sp` moved to suggests, users are now prompted to install sp if they want to search stations by coordinates
- `weather_dl()` replaces `weather()`
- `weather_interp()` replaces `add_weather()`
- `stations_dl()` replaces `stations_all()`
- `tz_calc()` replaces `get_tz()`
- Internal code modifications to match best practices

# weathercan 0.2.3 (2017-11-22)

## Changes
- Updated `stations` data
- Added `flags` and `glossary` datasets as well as vignettes
- `stations_search()` warns user if name looks like coords
- `stations_search()` with `coord` now returns closest 10 stations
- `add_weather()` warns user if trying to interpolate weather from >1 station
- Updated code to conform with rOpenSci requirements
- Data downloaded from multiple timezones defaults to UTC

## Bug fixes
- `weather(format = FALSE)` properly returns data
- updated `weather()` to work with `lubridate` 1.7.1

# weathercan 0.2.2 (2017-06-16)

## Changes
- Update and expand vignettes (closes #15)
- Data now returned as tibbles
- Added listcol functionality (closes #8)
- Added internal tests for interpolation
- Updated R version
- Standardized reference to stations dataset (`stn`) in all functions

## Major changes
- envirocan renamed to weathercan (closes #17)

## Bug fixes
- Fixed inclusion of New Brunswick stations (closes #9)
- Downloads with no data return empty tibble and an informative message (closes #21)


# envirocan 0.2.1 (2017-03-04)
- Minor bug fixes: correcting encoding information for downloads, updating function calls to dplyr package, updating stations dataset

# envirocan 0.2.0 (2016-07-08)

- Added new function, `add_weather()` which performs a linear interpolation and merges weather data into an existing data frame.
- Added two new hourly datasets with weather data downloaded for Kamloops and Prince George, BC: kamloops, pg
- Added a new daily dataset for Kamloops: kamloops_day
- Fixed a bug when downloading data from multiple stations at the same time
- Changed 'timeframe' arguments to 'interval'
- Minor internal adjustments


# envirocan 0.1.1.1 (2016-06-23)

- quick fix to correct duplicated monthly data downloads


# envirocan 0.1.1 (2016-06-23)

## Functionality
- Allow blank start/end dates to download whole data set
- Add option to trim missing data from start and end of the range

## Bug fixes
- Add messages so functions fail gracefully if timezone doesn't exist
- Correct bugs that prevented downloading of monthly data


# envirocan 0.1.0 (2016-06-21)

This is the initial release for envirocan.

## Include functionality:

Finding stations:

- `stations` data frame to look up station data
- `stations_search()` function to search for a station by name or proximity
- `stations_all()` to download a new stations data set from Environment Canada

Downloading weather:

- `weather()` function to specify station_id(s) start and end dates for downloading data.

