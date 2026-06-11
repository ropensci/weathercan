# Changelog

## weathercan 1.0.0

- Fix ECCC change to normals download query parameters again
  ([\#207](https://github.com/ropensci/weathercan/issues/207))
- Added access to 1991-2020 Climate normals
  ([\#141](https://github.com/ropensci/weathercan/issues/141))
  - Added caching functions to support downloading and caching the full
    1991-2020 dataset
    ([`cache_dir()`](https://docs.ropensci.org/weathercan/reference/cache_dir.md),
    [`cache_remove()`](https://docs.ropensci.org/weathercan/reference/cache_remove.md))
- No longer include stations data frame in weathercan, prompt user to
  download always (ensures it’s up to date)
- Add better message control via option `weathercan.verbosity` which can
  be “standard” (default), “verbose” (extra progress messages) or
  “quiet” (little to no messages).
- Use cli for messaging
  ([\#211](https://github.com/ropensci/weathercan/issues/211))
- Add progress bars for downloads
  ([\#58](https://github.com/ropensci/weathercan/issues/58))
- Rewrite formatting functions
  - Increases speed
  - Columns have better types (e.g., year, month, day all numeric now)
  - Column order now reflects original data
- Add option to download only specific months
  ([\#68](https://github.com/ropensci/weathercan/issues/68))

## weathercan 0.7.8

- ECCC reverted some of the changes they made last week, this is a quick
  to address this.

## weathercan 0.7.7

- Quick fix to adjust API calls which require a Day parameter for *all*
  calls (this isn’t actually used for metadata or historical weather,
  but is required).

## weathercan 0.7.6

- Standardize normals year range and checks
- Fix bug in
  [`stations_search()`](https://docs.ropensci.org/weathercan/reference/stations_search.md)
  that precluded doing normals and years searches at the same time
- Change
  [`stations_search()`](https://docs.ropensci.org/weathercan/reference/stations_search.md)
  output to include interval, start and end years

## weathercan 0.7.5

- Fix province names for stations data frame
  ([\#175](https://github.com/ropensci/weathercan/issues/175))
- Don’t allow start times earlier than 1840 (earliest API will return;
  [\#174](https://github.com/ropensci/weathercan/issues/174))

## weathercan 0.7.4

- Add `qual` from newly added Flags column to hourly data
- Remove vcr
- Fix long Provincial names
  ([\#171](https://github.com/ropensci/weathercan/issues/171))

## weathercan 0.7.3

- Switch stations inventory list to new location
- Don’t try to download future weather
- Better test coverage
  ([\#149](https://github.com/ropensci/weathercan/issues/149); 🙏 thanks
  [@shandiya](https://github.com/shandiya),
  [@mciechanumich](https://github.com/mciechanumich)!)
- Replaced superseded dplyr functions
  ([\#150](https://github.com/ropensci/weathercan/issues/150); 🙏 thanks
  [@JauntyJJS](https://github.com/JauntyJJS),
  [@RichardLitt](https://github.com/RichardLitt)!)
- Fixed test coverage GitHub Action (🙏 thanks
  [@kellijohnson-NOAA](https://github.com/kellijohnson-NOAA)!)

## weathercan 0.7.2

- Fix normals to work with new ECCC data format
- Prepare
  [`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
  and family for new 1991-2020 normals

## weathercan 0.7.1

- [`stations()`](https://docs.ropensci.org/weathercan/reference/stations.md)
  now uses the most recent version of the data even if it hasn’t changed
  (prevent message regarding age of stations data frame).
- Remove startup message about deprecated stations data frame
- Move Mapping Article from docs to website
  (<https://steffilazerte.ca/posts/weathercan-mapping/>)

## weathercan 0.7.0

- Internal updates to tests (testthat 3rd edition)
- Small changes to messages
- Switch completely to sf (remove sp dependency)
- Remove “Use with tidyverse” vignette - better to go to the source:
  <https://r4ds.hadley.nz/>
- Remove “Meteoland” vignette as functions are defunct

### Bug fixes

- Fix bug with Interpolate where silently transforms non-matching
  timezones. This can produce incorrect matching when using “local-UTC”
  timezones (as weathercan does as of v0.3.0). Now timezone mismatch
  results in an error so users can decide how it should be handled.

## weathercan 0.6.3

- Internal re-arranging and clean up
- Stations without lat/lon now have NA timezone
- Fixed vignette images

## weathercan 0.6.2

CRAN release: 2021-12-01

- Create cache dir for stations data recursively
- Fix choice of local vs. package version of stations data frame
- Update to readr v2
- Add flexibility for csv/tsv stations files (fixes
  [\#126](https://github.com/ropensci/weathercan/issues/126))
- Update stations url
- Make examples and tests robust to internet issues

## weathercan 0.6.1

CRAN release: 2021-06-05

### Small changes

- Save
  [`stations()`](https://docs.ropensci.org/weathercan/reference/stations.md)
  data to local cache

## weathercan 0.6.0

CRAN release: 2021-05-14

### Big changes

- Move from data frame `stations` to function
  [`stations()`](https://docs.ropensci.org/weathercan/reference/stations.md).
  Returns same data but is updateable with
  [`stations_dl()`](https://docs.ropensci.org/weathercan/reference/stations_dl.md)
  and you can check download dates version with
  [`stations_meta()`](https://docs.ropensci.org/weathercan/reference/stations_meta.md)
  (fixes [\#10](https://github.com/ropensci/weathercan/issues/10))
- Download climate normals from climate.weather.gc.ca (fixes
  [\#88](https://github.com/ropensci/weathercan/issues/88))
  - More stations available (more than 2x as many!)
  - More year ranges available (1981-2010 and 1971-2000; Note that while
    climate normals from 1961-1990 are available from ECCC, they don’t
    have climate ids making it tricky to download reliably)

### Small changes

- Remove old deprecated function arguments
- Better test coverage
  ([\#81](https://github.com/ropensci/weathercan/issues/81))
- Better handling of http errors
  ([\#101](https://github.com/ropensci/weathercan/issues/101),
  [\#119](https://github.com/ropensci/weathercan/issues/119); Thanks
  [@KevCaz](https://github.com/KevCaz)!)

### Bug fixes

- Download stations data frame from ECCC Google drive rather than ECCC
  FTP site
- Update dependency versions
  ([\#111](https://github.com/ropensci/weathercan/issues/111),
  [\#112](https://github.com/ropensci/weathercan/issues/112),
  [\#118](https://github.com/ropensci/weathercan/issues/118))

## weathercan 0.5.0 (2020-01-14)

CRAN release: 2021-01-15

### Small changes

- Internal changes to address change in formatting of historical weather
  data provided by ECCC (includes new parameters for the amount of
  precipitation in mm: `precip_amt`, `precip_amt_flag`; fixes
  [\#107](https://github.com/ropensci/weathercan/issues/107))
- Updated stations data frame

### Bug fixes

- Updated normals column values (fixes
  [\#106](https://github.com/ropensci/weathercan/issues/106))

## weathercan 0.4.0 (2020-08-26)

CRAN release: 2020-09-02

### Bug fixes

- Fixed odd bug where some Linux systems failed to download stations
  data

### Features and potentially breaking changes

- Added caching in memory with memoise (caches for 24hrs, can change
  this by restarting the R session)
  - Caches individual downloaded files, so you may see a speed up even
    if you change the parameters of the download.
- Some missing values in meta data previously were “” but are now
  explicitly NAs

### Internal changes

- Use readr for reading data
- Use vcr for tests

## weathercan 0.3.4 (2020-04-14)

CRAN release: 2020-04-17

### Small changes

- Internal changes to fix compatibility with tibble v3.0.0
- Internal changes to fix compatibility with dplyr v1.0.0
- Updated internal stations data frame

## weathercan 0.3.3 (2020-01-24)

CRAN release: 2020-02-05

### Small changes

- Internal changes to address issues with testing
- Remove all reliance on ECCC servers when testing on CRAN
- Update internal datasets

## weathercan 0.3.2 (2020-01-06)

CRAN release: 2020-01-08

### Small changes

- Internal changes to address expected changes to normals metadata
- Internal changes to address problems with connections on Windows
- Update links to website

## weathercan 0.3.1 (2019-09-27)

CRAN release: 2019-09-29

### Small changes

- Internal changes to address change in formatting of historical weather
  data provided by ECCC (fixes
  [\#83](https://github.com/ropensci/weathercan/issues/83))

## weathercan 0.3.0 (2019-09-25)

CRAN release: 2019-09-25

### Big changes

- New function:
  [`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
  function downloads climate normals. Addresses issue
  [\#38](https://github.com/ropensci/weathercan/issues/38).
- New argument:
  [`stations_search()`](https://docs.ropensci.org/weathercan/reference/stations_search.md)
  has `normals_only` to return only stations with climate normals
- Deprecated `url` argument in favour of `weathercan.urls.stations`,
  `weathercan.urls.weather` and `weathercan.urls.normals` options.
- Deprecated `tz_disp` in favour of `time_disp`. Now all timezones are
  UTC, but the displayed time is either local time or UTC. When
  `time_disp` = “none”, the time displayed is local time without
  daylight savings, similar to how ECCC presents the data. This means
  that data from different time zones will have similar ecological times
  (i.e. midnights will be comparable), but the actual times are not UTC.
  When `time_disp` = “UTC’, the time displayed is in UTC timezone,
  meaning that stations from different times zones will have true times
  (i.e. midnight observation in Toronto will be three hours before
  midnight observation in Vancouver). Addresses issue
  [\#74](https://github.com/ropensci/weathercan/issues/74).

### Small changes

- Add parameter in `station_search()` to restrict by start and end
  dates. Addresses issue
  [\#35](https://github.com/ropensci/weathercan/issues/35).
- Internal change, switching to .data and “” for all non-standard
  evaluations as opposed to listing global variables
- Tweaks to keep compatibility wit `tidyr`

### Bug fixes

- Fix bug [\#69](https://github.com/ropensci/weathercan/issues/69) which
  resulted in daily downloads missing partial years when the date range
  spanned two calendar years
- Fix bug [\#70](https://github.com/ropensci/weathercan/issues/70) where
  internal `stations` data frame references conflicted with local
  references to `stations`
- Fix bug [\#72](https://github.com/ropensci/weathercan/issues/72) which
  was a security vulnerability in an article’s json

## weathercan 0.2.8 (2018-10-08)

CRAN release: 2018-10-08

### Bug fixes

- Add timezones to the `stations` data frame to remove dependency of
  Google API. Timezones added with the `lutz` package, so updates the
  the `stations` data frame now require `lutz` and `sf` packages (added
  to Suggests).

### Changes

- Sort `stations` by `station_id` not by `station_name`

### Other

- Update all internal data frames

## weathercan 0.2.7 (2018-06-27)

CRAN release: 2018-07-05

### Bug fixes

- Fix bug created when ECCC changed file metadata for dates after April
  1st 2018 (only affected downloads which included dates both before AND
  after April 1st, 2018) - Results in a new column `station_operator`
  for all data (NA where unavailable for older stations).
- Adjust code flexibility to handle future changes
- Add catch to warn user if end dates earlier than start dates

### Changes

- Update readme/vignettes/internal data sets to include new columns
- Update internal `stations` data frame as well as `flags` and
  `glossary`
- Remove `tibble` dependency by relying on `dplyr`

## weathercan 0.2.6 (2018-05-25)

### Bug fixes

- Fix bug created when ECCC removed Data Quality Column
- Adjust code flexibility to handle future changes
- Add tests to catch future changes

## weathercan 0.2.5 (2018-03-02)

### Changes

- More sensible messages when missing station data
- Streamline messages from multiple stations
- Accepts older R version
- `stations_dl` fails gracefully on R versions \< 3.3.4
- Update `stations` data frame

### Bug fixes

- Fix error when missing station data from one of several stations

## weathercan 0.2.4 (2018-02-01)

Now part of [ropensci.org](https://ropensci.org)!

### Changes

- `sp` moved to suggests, users are now prompted to install sp if they
  want to search stations by coordinates
- [`weather_dl()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md)
  replaces
  [`weather()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md)
- [`weather_interp()`](https://docs.ropensci.org/weathercan/reference/weather_interp.md)
  replaces
  [`add_weather()`](https://docs.ropensci.org/weathercan/reference/weather_interp.md)
- [`stations_dl()`](https://docs.ropensci.org/weathercan/reference/stations_dl.md)
  replaces `stations_all()`
- `tz_calc()` replaces `get_tz()`
- Internal code modifications to match best practices

## weathercan 0.2.3 (2017-11-22)

### Changes

- Updated `stations` data
- Added `flags` and `glossary` datasets as well as vignettes
- [`stations_search()`](https://docs.ropensci.org/weathercan/reference/stations_search.md)
  warns user if name looks like coords
- [`stations_search()`](https://docs.ropensci.org/weathercan/reference/stations_search.md)
  with `coord` now returns closest 10 stations
- [`add_weather()`](https://docs.ropensci.org/weathercan/reference/weather_interp.md)
  warns user if trying to interpolate weather from \>1 station
- Updated code to conform with rOpenSci requirements
- Data downloaded from multiple timezones defaults to UTC

### Bug fixes

- `weather(format = FALSE)` properly returns data
- updated
  [`weather()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md)
  to work with `lubridate` 1.7.1

## weathercan 0.2.2 (2017-06-16)

### Changes

- Update and expand vignettes (closes
  [\#15](https://github.com/ropensci/weathercan/issues/15))
- Data now returned as tibbles
- Added listcol functionality (closes
  [\#8](https://github.com/ropensci/weathercan/issues/8))
- Added internal tests for interpolation
- Updated R version
- Standardized reference to stations dataset (`stn`) in all functions

### Major changes

- envirocan renamed to weathercan (closes
  [\#17](https://github.com/ropensci/weathercan/issues/17))

### Bug fixes

- Fixed inclusion of New Brunswick stations (closes
  [\#9](https://github.com/ropensci/weathercan/issues/9))
- Downloads with no data return empty tibble and an informative message
  (closes [\#21](https://github.com/ropensci/weathercan/issues/21))
