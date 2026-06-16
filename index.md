# weathercan

[![:name status
badge](https://ropensci.r-universe.dev/badges/:name)](https://ropensci.r-universe.dev)
[![weathercan status
badge](https://ropensci.r-universe.dev/badges/weathercan)](https://ropensci.r-universe.dev)
[![R-CMD-check](https://github.com/ropensci/weathercan/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci/weathercan/actions)
[![codecov](https://codecov.io/gh/ropensci/weathercan/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ropensci/weathercan)

[![](https://badges.ropensci.org/160_status.svg)](https://github.com/ropensci/software-review/issues/160)
[![DOI](https://zenodo.org/badge/60650396.svg)](https://zenodo.org/badge/latestdoi/60650396)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.00571/status.svg)](https://doi.org/10.21105/joss.00571)

This package makes it easier to search for and download multiple
months/years of historical weather data from [Environment and Climate
Change Canada (ECCC)
website](https://climate.weather.gc.ca/historical_data/search_historic_data_e.html).

Bear in mind that these downloads can be fairly large and performing
multiple downloads may use up ECCC’s bandwidth unnecessarily. Try to
stick to what you need.

For more details and tutorials checkout the [weathercan
website](https://docs.ropensci.org/weathercan/) (or see the [development
docs](http://ropensci.github.io/weathercan/))

> Check out the Demo weathercan shiny dashboard
> ([html](https://steffilazerte.shinyapps.io/weathercan_shiny/);
> [source](https://github.com/steffilazerte/weathercan_shiny))

## Installation

You can install `weathercan` from the [rOpenSci
r-Universe](https://ropensci.r-universe.dev/):

``` r

install.packages(
  "weathercan",
  repos = c("https://ropensci.r-universe.dev", "https://cloud.r-project.org")
)
```

View the available vignettes with `vignette(package = "weathercan")`

View a particular vignette with, for example,
[`vignette("weathercan", package = "weathercan")`](https://docs.ropensci.org/weathercan/articles/weathercan.md)

## General usage

To download data, you first need to know the `station_id` associated
with the station you’re interested in.

### Stations

`weathercan` includes the function
[`stations()`](https://docs.ropensci.org/weathercan/reference/stations.md)
which returns a list of stations and their details (including
`station_id`).

``` r

head(stations())
```

``` R
## # A tibble: 6 × 17
##   prov  station_name        station_id climate_id WMO_id TC_id   lat   lon  elev tz        interval start   end normals normals_1991_2020 normals_1981_2010
##   <chr> <chr>                    <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <fct>    <dbl> <dbl> <lgl>   <lgl>             <lgl>            
## 1 AB    DAYSLAND                  1795 301AR54        NA <NA>   52.9 -112.  689. Etc/GMT+7 hour        NA    NA FALSE   FALSE             FALSE            
## 2 AB    DAYSLAND                  1795 301AR54        NA <NA>   52.9 -112.  689. Etc/GMT+7 day       1908  1922 FALSE   FALSE             FALSE            
## 3 AB    DAYSLAND                  1795 301AR54        NA <NA>   52.9 -112.  689. Etc/GMT+7 month     1908  1922 FALSE   FALSE             FALSE            
## 4 AB    EDMONTON CORONATION       1796 301BK03        NA <NA>   53.6 -114.  671. Etc/GMT+7 hour        NA    NA FALSE   FALSE             FALSE            
## 5 AB    EDMONTON CORONATION       1796 301BK03        NA <NA>   53.6 -114.  671. Etc/GMT+7 day       1978  1979 FALSE   FALSE             FALSE            
## 6 AB    EDMONTON CORONATION       1796 301BK03        NA <NA>   53.6 -114.  671. Etc/GMT+7 month     1978  1979 FALSE   FALSE             FALSE            
## # ℹ 1 more variable: normals_1971_2000 <lgl>
```

``` r

glimpse(stations())
```

``` R
## Rows: 26,448
## Columns: 17
## $ prov              <chr> "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", "AB", …
## $ station_name      <chr> "DAYSLAND", "DAYSLAND", "DAYSLAND", "EDMONTON CORONATION", "EDMONTON CORONATION", "EDMONTON CORONATION", "FLEET", "FLEET", "FLEET", …
## $ station_id        <dbl> 1795, 1795, 1795, 1796, 1796, 1796, 1797, 1797, 1797, 1798, 1798, 1798, 1799, 1799, 1799, 1800, 1800, 1800, 1801, 1801, 1801, 1802, …
## $ climate_id        <chr> "301AR54", "301AR54", "301AR54", "301BK03", "301BK03", "301BK03", "301B6L0", "301B6L0", "301B6L0", "301B8LR", "301B8LR", "301B8LR", …
## $ WMO_id            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
## $ TC_id             <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
## $ lat               <dbl> 52.87, 52.87, 52.87, 53.57, 53.57, 53.57, 52.15, 52.15, 52.15, 53.20, 53.20, 53.20, 52.40, 52.40, 52.40, 54.08, 54.08, 54.08, 53.52,…
## $ lon               <dbl> -112.28, -112.28, -112.28, -113.57, -113.57, -113.57, -111.73, -111.73, -111.73, -110.15, -110.15, -110.15, -115.20, -115.20, -115.2…
## $ elev              <dbl> 688.8, 688.8, 688.8, 670.6, 670.6, 670.6, 838.2, 838.2, 838.2, 640.0, 640.0, 640.0, 1036.0, 1036.0, 1036.0, 585.2, 585.2, 585.2, 668…
## $ tz                <chr> "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "E…
## $ interval          <fct> hour, day, month, hour, day, month, hour, day, month, hour, day, month, hour, day, month, hour, day, month, hour, day, month, hour, …
## $ start             <dbl> NA, 1908, 1908, NA, 1978, 1978, NA, 1987, 1987, NA, 1987, 1987, NA, 1980, 1980, NA, 1980, 1980, NA, 1986, 1986, NA, 1987, 1987, NA, …
## $ end               <dbl> NA, 1922, 1922, NA, 1979, 1979, NA, 1990, 1990, NA, 1998, 1998, NA, 2009, 2007, NA, 1981, 1981, NA, 2019, 2007, NA, 1991, 1991, NA, …
## $ normals           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRU…
## $ normals_1991_2020 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ normals_1981_2010 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRU…
## $ normals_1971_2000 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
```

You can look through this data frame directly, or you can use the
`stations_search` function:

``` r

stations_search("Kamloops", interval = "hour")
```

``` R
## # A tibble: 3 × 17
##   prov  station_name station_id climate_id WMO_id TC_id   lat   lon  elev tz        interval start   end normals normals_1991_2020 normals_1981_2010
##   <chr> <chr>             <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <fct>    <dbl> <dbl> <lgl>   <lgl>             <lgl>            
## 1 BC    KAMLOOPS A         1275 1163780     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      1953  2013 TRUE    TRUE              TRUE             
## 2 BC    KAMLOOPS A        51423 1163781     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      2013  2026 TRUE    TRUE              FALSE            
## 3 BC    KAMLOOPS AUT      42203 1163842     71741 ZKA    50.7 -120.  345  Etc/GMT+8 hour      2006  2026 TRUE    TRUE              FALSE            
## # ℹ 1 more variable: normals_1971_2000 <lgl>
```

Time frame must be one of “hour”, “day”, or “month”.

You can also search by proximity:

``` r

stations_search(
  coords = c(50.667492, -120.329049),
  dist = 20,
  interval = "hour"
)
```

``` R
## # A tibble: 3 × 18
##   prov  station_name station_id climate_id WMO_id TC_id   lat   lon  elev tz        interval start   end normals normals_1991_2020 normals_1981_2010
##   <chr> <chr>             <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <fct>    <dbl> <dbl> <lgl>   <lgl>             <lgl>            
## 1 BC    KAMLOOPS A         1275 1163780     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      1953  2013 TRUE    TRUE              TRUE             
## 2 BC    KAMLOOPS AUT      42203 1163842     71741 ZKA    50.7 -120.  345  Etc/GMT+8 hour      2006  2026 TRUE    TRUE              FALSE            
## 3 BC    KAMLOOPS A        51423 1163781     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      2013  2026 TRUE    TRUE              FALSE            
## # ℹ 2 more variables: normals_1971_2000 <lgl>, distance <dbl>
```

You can update this list of stations with

``` r

stations_dl()
```

``` R
## According to Environment Canada, Modified Date: 2026-06-03 23:30 UTC
## Environment Canada Disclaimers: "Station Inventory Disclaimer: Please note that this inventory list is a snapshot of stations on our website as of the modified
## date, and may be subject to change without notice." "Station ID Disclaimer: Station IDs are an internal index numbering system and may be subject to change
## without notice."
## Stations data saved... Use `stations()` to access most recent version and `stations_meta()` to see when this was last updated
```

And check when it was last updated with

``` r

stations_meta()
```

``` R
## # A tibble: 1 × 2
##   ECCC_modified       weathercan_modified
##   <dttm>              <date>             
## 1 2026-06-03 23:30:00 2026-06-16
```

**Note:** For reproducibility, if you are using the stations list to
gather your data, it can be a good idea to take note of the ECCC date of
modification and include it in your reports/manuscripts.

### Weather

Once you have your `station_id`(s) you can download weather data:

``` r

kam <- weather_dl(station_ids = 51423, start = "2018-02-01", end = "2018-04-15")
```

``` R
## As of weathercan v0.3.0 time display is either local time or UTC See Details under `weather_dl()` (`?weather_dl()`) for more information. This message is shown
## once per session
```

``` r

kam
```

``` R
## # A tibble: 1,776 × 38
##    station_name station_id station_operator prov    lat   lon  elev climate_id WMO_id TC_id date       time                 year month   day hour   qual   temp
##    <chr>             <dbl> <chr>            <chr> <dbl> <dbl> <dbl> <chr>      <chr>  <chr> <date>     <dttm>              <dbl> <int> <int> <time> <chr> <dbl>
##  1 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 00:00:00  2018     2     1 00:00  <NA>    0.2
##  2 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 01:00:00  2018     2     1 01:00  <NA>   -0.8
##  3 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 02:00:00  2018     2     1 02:00  <NA>   -0.4
##  4 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 03:00:00  2018     2     1 03:00  <NA>   -0.7
##  5 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 04:00:00  2018     2     1 04:00  <NA>   -1  
##  6 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 05:00:00  2018     2     1 05:00  <NA>   -1  
##  7 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 06:00:00  2018     2     1 06:00  <NA>   -1  
##  8 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 07:00:00  2018     2     1 07:00  <NA>   -0.9
##  9 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 08:00:00  2018     2     1 08:00  <NA>   -0.9
## 10 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 09:00:00  2018     2     1 09:00  <NA>   -0.7
## # ℹ 1,766 more rows
```

You can also download data from multiple stations at once:

``` r

kam_pg <- weather_dl(
  station_ids = c(48248, 51423),
  start = "2018-02-01",
  end = "2018-04-15"
)
```

## Climate Normals

To access climate normals, you first need to know the `climate_id`
associated with the station you’re interested in.

``` r

stations_search("Winnipeg", normals_years = "current")
```

``` R
## The most current normals available for download by weathercan are '1991-2020'

## # A tibble: 10 × 17
##    prov  station_name                station_id climate_id WMO_id TC_id   lat   lon  elev tz    interval start   end normals normals_1991_2020 normals_1981_2010
##    <chr> <chr>                            <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr> <fct>    <dbl> <dbl> <lgl>   <lgl>             <lgl>            
##  1 MB    WINNIPEG A CS                    27174 502S001     71849 XWG    49.9 -97.2  239. Etc/… hour      2013  2026 TRUE    TRUE              FALSE            
##  2 MB    WINNIPEG A CS                    27174 502S001     71849 XWG    49.9 -97.2  239. Etc/… day       1996  2026 TRUE    TRUE              FALSE            
##  3 MB    WINNIPEG A CS                    27174 502S001     71849 XWG    49.9 -97.2  239. Etc/… month     1996  2007 TRUE    TRUE              FALSE            
##  4 MB    WINNIPEG INTL A                  51097 5023227        NA YWG    49.9 -97.2  239. Etc/… hour      2013  2026 TRUE    TRUE              FALSE            
##  5 MB    WINNIPEG INTL A                  51097 5023227        NA YWG    49.9 -97.2  239. Etc/… day       2018  2026 TRUE    TRUE              FALSE            
##  6 MB    WINNIPEG RICHARDSON AWOS         47407 5023226     71852 YWG    49.9 -97.2  239. Etc/… hour      2008  2013 TRUE    TRUE              FALSE            
##  7 MB    WINNIPEG RICHARDSON AWOS         47407 5023226     71852 YWG    49.9 -97.2  239. Etc/… day       2008  2013 TRUE    TRUE              FALSE            
##  8 MB    WINNIPEG RICHARDSON INT'L A       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/… hour      1953  2013 TRUE    TRUE              TRUE             
##  9 MB    WINNIPEG RICHARDSON INT'L A       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/… day       1938  2008 TRUE    TRUE              TRUE             
## 10 MB    WINNIPEG RICHARDSON INT'L A       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/… month     1938  2007 TRUE    TRUE              TRUE             
## # ℹ 1 more variable: normals_1971_2000 <lgl>
```

Then you can download the climate normals with the
[`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
function.

``` r

n <- normals_dl("5023222")
```

``` R
## As of weathercan v1.0.0 the default normals are 1991-2020. Note that these normals are in a different format from previous years. See ?normals_dl for more
## details or use `normals_years = '1981-2010'` to revert to the previous set of normals. This message is shown once per session
## 
## 
## The most current normals available for download by weathercan are '1991-2020'
## Using composite locations: WINNIPEG RICHARDSON (AIRPORT)
```

``` r

n
```

``` R
## # A tibble: 26 × 313
##    location_name             prov  composite_stations period_of_record period daily_average_c daily_average_c_code stddev_mean_monthly_…¹ stddev_mean_monthly_…²
##    <chr>                     <chr> <chr>              <chr>            <chr>            <dbl> <chr>                                 <dbl> <chr>                 
##  1 WINNIPEG RICHARDSON (AIR… MB    WINNIPEG A CS (50… Normal           Jan              -16.3 A                                       3.6 A                     
##  2 WINNIPEG RICHARDSON (AIR… MB    WINNIPEG A CS (50… Normal           Feb              -14.1 A                                       4   A                     
##  3 WINNIPEG RICHARDSON (AIR… MB    WINNIPEG A CS (50… Normal           Mar               -6.1 A                                       3.7 A                     
##  4 WINNIPEG RICHARDSON (AIR… MB    WINNIPEG A CS (50… Normal           Apr                3.8 A                                       2.9 A                     
##  5 WINNIPEG RICHARDSON (AIR… MB    WINNIPEG A CS (50… Normal           May               11.1 A                                       1.9 A                     
##  6 WINNIPEG RICHARDSON (AIR… MB    WINNIPEG A CS (50… Normal           Jun               17.1 A                                       1.5 A                     
##  7 WINNIPEG RICHARDSON (AIR… MB    WINNIPEG A CS (50… Normal           Jul               19.5 A                                       1.4 A                     
##  8 WINNIPEG RICHARDSON (AIR… MB    WINNIPEG A CS (50… Normal           Aug               18.7 A                                       1.5 A                     
##  9 WINNIPEG RICHARDSON (AIR… MB    WINNIPEG A CS (50… Normal           Sep               13.3 A                                       1.6 A                     
## 10 WINNIPEG RICHARDSON (AIR… MB    WINNIPEG A CS (50… Normal           Oct                5.1 A                                       2.1 A                     
## # ℹ 16 more rows
## # ℹ abbreviated names: ¹​stddev_mean_monthly_temperature_c, ²​stddev_mean_monthly_temperature_c_code
## # ℹ 304 more variables: daily_maximum_c <dbl>, daily_maximum_c_code <chr>, daily_minimum_c <dbl>, daily_minimum_c_code <chr>, maximum_daily_mean_c <dbl>,
## #   maximum_daily_mean_c_code <lgl>, maximum_daily_mean_c_date <date>, maximum_daily_mean_c_date_code <lgl>, minimum_daily_mean_c <dbl>,
## #   minimum_daily_mean_c_code <lgl>, minimum_daily_mean_c_date <date>, minimum_daily_mean_c_date_code <lgl>, extreme_maximum_c <dbl>,
## #   extreme_maximum_c_code <lgl>, extreme_maximum_c_date <date>, extreme_maximum_c_date_code <lgl>, minimum_daily_maximum_c <dbl>,
## #   minimum_daily_maximum_c_code <lgl>, minimum_daily_maximum_c_date <date>, minimum_daily_maximum_c_date_code <lgl>, maximum_daily_minimum_c <dbl>, …
```

See the [Getting
Started](https://docs.ropensci.org/weathercan/articles/weathercan.html)
vignette for more details.

## Citation

``` r

citation("weathercan")
```

``` R
## To cite 'weathercan' in publications, please use:
## 
##   LaZerte, Stefanie E and Sam Albers (2018). weathercan: Download and format weather data from Environment and Climate Change Canada. The
##   Journal of Open Source Software 3(22):571. doi:10.21105/joss.00571.
## 
## A BibTeX entry for LaTeX users is
## 
##   @Article{,
##     title = {{weathercan}: {D}ownload and format weather data from Environment and Climate Change Canada},
##     author = {Stefanie E LaZerte and Sam Albers},
##     journal = {The Journal of Open Source Software},
##     volume = {3},
##     number = {22},
##     pages = {571},
##     year = {2018},
##     url = {https://joss.theoj.org/papers/10.21105/joss.00571},
##   }
```

## License

The data and the code in this repository are licensed under multiple
licences. All code is licensed
[GPL-3](https://www.gnu.org/licenses/gpl-3.0.en.html). All weather data
is licensed under the ([Open Government License -
Canada](http://open.canada.ca/en/open-government-licence-canada)).

## `weathercan` in the wild!

- Browse [`weathercan` use cases](https://ropensci.org/usecases/) on
  rOpenSci.org
- Checkout the [`weathercan` Shiny
  App](https://nickrongkp.shinyapps.io/WeatherCan/) by Nick
  Rong (@nickyrong) and Nathan Smith (@WraySmith)
- R package [`RavenR`](https://github.com/rchlumsk/RavenR/) has
  functions for converting ECCC data downloaded by `weathercan` to the
  .rvt format for Raven.

## Similar packages

**[`rclimateca`](https://github.com/paleolimbot/rclimateca)**

`weathercan` and `rclimateca` were developed at roughly the same time
and as a result, both present up-to-date methods for accessing and
downloading data from ECCC. The largest differences between the two
packages are: a) `weathercan` includes functions for interpolating
weather data and directly integrating it into other data sources. b)
`weathercan` actively seeks to apply tidy data principles in R and
integrates well with the tidyverse including using tibbles and nested
listcols. c) `rclimateca` contains arguments for specifying short
vs. long data formats. d) `rclimateca` has the option of formatting data
in the MUData format using the
[`mudata2`](https://cran.r-project.org/package=mudata2) package by the
same author.

**[`CHCN`](https://cran.r-project.org/package=CHCN)**

`CHCN` is an older package last updated in 2012. Unfortunately, ECCC
updated their services within the last couple of years which caused a
great many of the previous web scrapers to fail. `CHCN` relies on a
decommissioned [older web-scraper](https://quickcode.io/) and so is
currently broken.

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://ropensci.org/code-of-conduct/). By participating in
this project you agree to abide by its terms.

## Contributions

We welcome any and all contributions! To make the process as painless as
possible for all involved, please see our [guide to
contributing](https://docs.ropensci.org/weathercan/CONTRIBUTING.md)

## Contributors

All contributions to this project are gratefully acknowledged using the
[`allcontributors` package](https://github.com/ropensci/allcontributors)
following the [allcontributors](https://allcontributors.org)
specification. Contributions of any kind are welcome!

### Code

[TABLE]

### Issue Authors

[TABLE]

### Issue Contributors

[TABLE]
