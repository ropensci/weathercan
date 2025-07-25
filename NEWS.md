# weathercan 0.7.5
- Fix province names for stations data frame (#175)
# weathercan 0.7.4
- Add `qual` from newly added Flags column to hourly data
- Remove vcr
- Fix long Provincial names (#171)

# weathercan 0.7.3
- Switch stations inventory list to new location
- Don't try to download future weather
- Better test coverage (#149; 🙏 thanks @shandiya, @mciechanumich!)
- Replaced superseded dplyr functions (#150; 🙏 thanks @JauntyJJS, @RichardLitt!)
- Fixed test coverage GitHub Action (🙏 thanks @kellijohnson-NOAA!)

# weathercan 0.7.2
- Fix normals to work with new ECCC data format
- Prepare `normals_dl()` and family for new 1991-2020 normals

# weathercan 0.7.1
- `stations()` now uses the most recent version of the data even if it hasn't changed
  (prevent message regarding age of stations data frame). 
- Remove startup message about deprecated stations data frame
- Move Mapping Article from docs to website (https://steffilazerte.ca/posts/weathercan-mapping/)

# weathercan 0.7.0
- Internal updates to tests (testthat 3rd edition)
- Small changes to messages
- Switch completely to sf (remove sp dependency)
- Remove "Use with tidyverse" vignette - better to go to the source: https://r4ds.hadley.nz/
- Remove "Meteoland" vignette as functions are defunct

## Bug fixes
- Fix bug with Interpolate where silently transforms non-matching timezones.
  This can produce incorrect matching when using "local-UTC" timezones
  (as weathercan does as of v0.3.0). Now timezone mismatch results in an error
  so users can decide how it should be handled.
  

# weathercan 0.6.3
- Internal re-arranging and clean up
- Stations without lat/lon now have NA timezone
- Fixed vignette images

# weathercan 0.6.2

- Create cache dir for stations data recursively
- Fix choice of local vs. package version of stations data frame
- Update to readr v2
- Add flexibility for csv/tsv stations files (fixes #126)
- Update stations url
- Make examples and tests robust to internet issues


# weathercan 0.6.1

## Small changes
- Save `stations()` data to local cache

# weathercan 0.6.0

## Big changes
- Move from data frame `stations` to function `stations()`. Returns same data
  but is updateable with `stations_dl()` and you can check download dates
  version with `stations_meta()` (fixes #10)
- Download climate normals from climate.weather.gc.ca (fixes #88)
  - More stations available (more than 2x as many!)
  - More year ranges available (1981-2010 and 1971-2000; 
    Note that while climate normals from 1961-1990 are available from ECCC, they
    don't have climate ids making it tricky to download reliably)
    
## Small changes
- Remove old deprecated function arguments
- Better test coverage (#81)
- Better handling of http errors (#101, #119; Thanks @KevCaz!)

## Bug fixes
- Download stations data frame from ECCC Google drive rather than ECCC FTP site
- Update dependency versions (#111, #112, #118)


# weathercan 0.5.0 (2020-01-14)

## Small changes
- Internal changes to address change in formatting of historical weather data provided by ECCC 
  (includes new parameters for the amount of precipitation in mm: `precip_amt`, `precip_amt_flag`; fixes #107) 
- Updated stations data frame

## Bug fixes
- Updated normals column values (fixes #106)

# weathercan 0.4.0 (2020-08-26)

## Bug fixes
- Fixed odd bug where some Linux systems failed to download stations data

## Features and potentially breaking changes
- Added caching in memory with memoise (caches for 24hrs, can change this by restarting the R session)
    - Caches individual downloaded files, so you may see a speed up even if you change the parameters of the download.
- Some missing values in meta data previously were "" but are now explicitly NAs

## Internal changes
- Use readr for reading data
- Use vcr for tests

# weathercan 0.3.4 (2020-04-14)

## Small changes
- Internal changes to fix compatibility with tibble v3.0.0
- Internal changes to fix compatibility with dplyr v1.0.0
- Updated internal stations data frame

# weathercan 0.3.3 (2020-01-24)

## Small changes
- Internal changes to address issues with testing
- Remove all reliance on ECCC servers when testing on CRAN
- Update internal datasets

# weathercan 0.3.2 (2020-01-06)

## Small changes
- Internal changes to address expected changes to normals metadata
- Internal changes to address problems with connections on Windows
- Update links to website

# weathercan 0.3.1 (2019-09-27)

## Small changes
- Internal changes to address change in formatting of historical weather data provided by ECCC (fixes #83)


# weathercan 0.3.0 (2019-09-25)

## Big changes
- New function: `normals_dl()` function downloads climate normals. Addresses issue #38.
- New argument: `stations_search()` has `normals_only` to return only stations with climate normals
- Deprecated `url` argument in favour of `weathercan.urls.stations`, `weathercan.urls.weather` and `weathercan.urls.normals` options.
- Deprecated `tz_disp` in favour of `time_disp`. Now all timezones are UTC, but the displayed time is either local time or UTC. When `time_disp` = "none", the time displayed is local time without daylight savings, similar to how ECCC presents the data. This means that data from different time zones will have similar ecological times (i.e. midnights will be comparable), but the actual times are not UTC. When `time_disp` = "UTC', the time displayed is in UTC timezone, meaning that stations from different times zones will have true times (i.e. midnight observation in Toronto will be three hours before midnight observation in Vancouver). Addresses issue #74.

## Small changes
- Add parameter in `station_search()` to restrict by start and end dates. Addresses issue #35.
- Internal change, switching to .data and "" for all non-standard evaluations as opposed to listing global variables
- Tweaks to keep compatibility wit `tidyr`

## Bug fixes
- Fix bug #69 which resulted in daily downloads missing partial years when the date range spanned two calendar years
- Fix bug #70 where internal `stations` data frame references conflicted with local references to `stations`
- Fix bug #72 which was a security vulnerability in an article's json

# weathercan 0.2.8 (2018-10-08)

## Bug fixes
- Add timezones to the `stations` data frame to remove dependency of Google API. Timezones added with the `lutz` package, so updates the the `stations` data frame now require `lutz` and `sf` packages (added to Suggests).

## Changes
- Sort `stations` by `station_id` not by `station_name`

## Other
- Update all internal data frames

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

Now part of [ropensci.org](https://ropensci.org)!

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

