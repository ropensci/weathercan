---
title: "News"
author: "Steffi LaZerte"
output: html_document
---

# weathercan 0.2.2

## Changes
- Update and expand vignettes (closes #15)
- Data now returned as tibbles
- Added listcol functionality (closes #8)
- Added internal tests for interpolation
- Updated R version

## Major changes
- envirocan renamed to weathercan (closes #17)

## Bug fixes
- Fixed inclusion of New Brunswick stations (closes #9)


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

