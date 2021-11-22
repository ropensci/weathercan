
# weathercan <img src="https://github.com/ropensci/weathercan/raw/master/inst/assets/weathercan_logo.png" align = "right" width = 110/>

[![:name status
badge](https://ropensci.r-universe.dev/badges/:name)](https://ropensci.r-universe.dev)
[![weathercan status
badge](https://ropensci.r-universe.dev/badges/weathercan)](https://ropensci.r-universe.dev)
[![R-CMD-check](https://github.com/ropensci/weathercan/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/weathercan/actions)
[![codecov](https://codecov.io/gh/ropensci/weathercan/branch/master/graph/badge.svg)](https://app.codecov.io/gh/ropensci/weathercan)

[![](https://badges.ropensci.org/160_status.svg)](https://github.com/ropensci/software-review/issues/160)
[![DOI](https://zenodo.org/badge/60650396.svg)](https://zenodo.org/badge/latestdoi/60650396)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.00571/status.svg)](https://doi.org/10.21105/joss.00571)

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/weathercan)](https://cran.r-project.org/package=weathercan)
[![CRAN
Downloads](http://cranlogs.r-pkg.org/badges/grand-total/weathercan)](https://CRAN.R-project.org/package=weathercan)

This package makes it easier to search for and download multiple
months/years of historical weather data from [Environment and Climate
Change Canada (ECCC)
website](https://climate.weather.gc.ca/historical_data/search_historic_data_e.html).

Bear in mind that these downloads can be fairly large and performing
multiple downloads may use up ECCC’s bandwidth unnecessarily. Try to
stick to what you need.

For more details and tutorials checkout the [weathercan
website](https://docs.ropensci.org/weathercan/)

> Check out the Demo weathercan shiny dashboard
> ([html](https://steffilazerte.shinyapps.io/weathercan_shiny/);
> [source](https://github.com/steffilazerte/weathercan_shiny))

## Installation

You can install `weathercan` directly from CRAN:

``` r
install.packages("weathercan")
```

Or you can install from the rOpenSci R-Universe:

``` r
install.packages("weathercan", repos = "https://ropensci.r-universe.dev")
```

View the available vignettes with `vignette(package = "weathercan")`

View a particular vignette with, for example,
`vignette("weathercan", package = "weathercan")`

## General usage

To download data, you first need to know the `station_id` associated
with the station you’re interested in.

### Stations

`weathercan` includes the function `stations()` which returns a list of
stations and their details (including `station_id`).

``` r
head(stations())
```

    ## # A tibble: 6 × 16
    ##   prov  station_name        station_id climate_id WMO_id TC_id   lat   lon  elev tz        interval start   end normals normals_1981_2010 normals_1971_2000
    ##   <chr> <chr>                    <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <chr>    <dbl> <dbl> <lgl>   <lgl>             <lgl>            
    ## 1 AB    DAYSLAND                  1795 301AR54        NA <NA>   52.9 -112.  689. Etc/GMT+7 day       1908  1922 FALSE   FALSE             FALSE            
    ## 2 AB    DAYSLAND                  1795 301AR54        NA <NA>   52.9 -112.  689. Etc/GMT+7 hour        NA    NA FALSE   FALSE             FALSE            
    ## 3 AB    DAYSLAND                  1795 301AR54        NA <NA>   52.9 -112.  689. Etc/GMT+7 month     1908  1922 FALSE   FALSE             FALSE            
    ## 4 AB    EDMONTON CORONATION       1796 301BK03        NA <NA>   53.6 -114.  671. Etc/GMT+7 day       1978  1979 FALSE   FALSE             FALSE            
    ## 5 AB    EDMONTON CORONATION       1796 301BK03        NA <NA>   53.6 -114.  671. Etc/GMT+7 hour        NA    NA FALSE   FALSE             FALSE            
    ## 6 AB    EDMONTON CORONATION       1796 301BK03        NA <NA>   53.6 -114.  671. Etc/GMT+7 month     1978  1979 FALSE   FALSE             FALSE

``` r
glimpse(stations())
```

    ## Rows: 26,337
    ## Columns: 16
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
    ## $ interval          <chr> "day", "hour", "month", "day", "hour", "month", "day", "hour", "month", "day", "hour", "month", "day", "hour", "month", "day", "hour…
    ## $ start             <dbl> 1908, NA, 1908, 1978, NA, 1978, 1987, NA, 1987, 1987, NA, 1987, 1980, NA, 1980, 1980, NA, 1980, 1986, NA, 1986, 1987, NA, 1987, 1986…
    ## $ end               <dbl> 1922, NA, 1922, 1979, NA, 1979, 1990, NA, 1990, 1998, NA, 1998, 2009, NA, 2007, 1981, NA, 1981, 2019, NA, 2007, 1991, NA, 1991, 1995…
    ## $ normals           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRU…
    ## $ normals_1981_2010 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRU…
    ## $ normals_1971_2000 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…

You can look through this data frame directly, or you can use the
`stations_search` function:

``` r
stations_search("Kamloops", interval = "hour")
```

    ## # A tibble: 3 × 16
    ##   prov  station_name station_id climate_id WMO_id TC_id   lat   lon  elev tz        interval start   end normals normals_1981_2010 normals_1971_2000
    ##   <chr> <chr>             <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <chr>    <dbl> <dbl> <lgl>   <lgl>             <lgl>            
    ## 1 BC    KAMLOOPS A         1275 1163780     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      1953  2013 TRUE    TRUE              TRUE             
    ## 2 BC    KAMLOOPS A        51423 1163781     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      2013  2021 FALSE   FALSE             FALSE            
    ## 3 BC    KAMLOOPS AUT      42203 1163842     71741 ZKA    50.7 -120.  345  Etc/GMT+8 hour      2006  2021 FALSE   FALSE             FALSE

Time frame must be one of “hour”, “day”, or “month”.

You can also search by proximity:

``` r
stations_search(coords = c(50.667492, -120.329049), dist = 20, interval = "hour")
```

    ## # A tibble: 3 × 17
    ##   prov  station_name station_id climate_id WMO_id TC_id   lat   lon  elev tz        interval start   end normals normals_1981_2010 normals_1971_2000 distance
    ##   <chr> <chr>             <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <chr>    <dbl> <dbl> <lgl>   <lgl>             <lgl>                <dbl>
    ## 1 BC    KAMLOOPS A         1275 1163780     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      1953  2013 TRUE    TRUE              TRUE                  8.64
    ## 2 BC    KAMLOOPS AUT      42203 1163842     71741 ZKA    50.7 -120.  345  Etc/GMT+8 hour      2006  2021 FALSE   FALSE             FALSE                 8.64
    ## 3 BC    KAMLOOPS A        51423 1163781     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      2013  2021 FALSE   FALSE             FALSE                 9.28

You can update this list of stations with

``` r
stations_dl()
```

    ## According to Environment Canada, Modified Date: 2021-10-31 23:34 UTC

    ## Stations data saved...
    ## Use `stations()` to access most recent version and `stations_meta()` to see when this was last updated

And check when it was last updated with

``` r
stations_meta()
```

    ## $ECCC_modified
    ## [1] "2021-10-31 23:34:00 UTC"
    ## 
    ## $weathercan_modified
    ## [1] "2021-11-22"

**Note:** For reproducibility, if you are using the stations list to
gather your data, it can be a good idea to take note of the ECCC date of
modification and include it in your reports/manuscripts.

### Weather

Once you have your `station_id`(s) you can download weather data:

``` r
kam <- weather_dl(station_ids = 51423, start = "2018-02-01", end = "2018-04-15")
```

    ## As of weathercan v0.3.0 time display is either local time or UTC
    ## See Details under ?weather_dl for more information.
    ## This message is shown once per session

``` r
kam
```

    ## # A tibble: 1,776 × 37
    ##    station_name station_id station_operator prov    lat   lon  elev climate_id WMO_id TC_id date       time                year  month day   hour  weather  hmdx
    ##    <chr>             <dbl> <lgl>            <chr> <dbl> <dbl> <dbl> <chr>      <chr>  <chr> <date>     <dttm>              <chr> <chr> <chr> <chr> <chr>   <dbl>
    ##  1 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 00:00:00 2018  02    01    00:00 <NA>       NA
    ##  2 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 01:00:00 2018  02    01    01:00 Snow       NA
    ##  3 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 02:00:00 2018  02    01    02:00 <NA>       NA
    ##  4 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 03:00:00 2018  02    01    03:00 <NA>       NA
    ##  5 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 04:00:00 2018  02    01    04:00 Cloudy     NA
    ##  6 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 05:00:00 2018  02    01    05:00 <NA>       NA
    ##  7 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 06:00:00 2018  02    01    06:00 <NA>       NA
    ##  8 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 07:00:00 2018  02    01    07:00 Cloudy     NA
    ##  9 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 08:00:00 2018  02    01    08:00 <NA>       NA
    ## 10 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 09:00:00 2018  02    01    09:00 <NA>       NA
    ## # … with 1,766 more rows

You can also download data from multiple stations at once:

``` r
kam_pg <- weather_dl(station_ids = c(48248, 51423), start = "2018-02-01", end = "2018-04-15")
```

## Climate Normals

To access climate normals, you first need to know the `climate_id`
associated with the station you’re interested in.

``` r
stations_search("Winnipeg", normals_years = "current")
```

    ## # A tibble: 1 × 13
    ##   prov  station_name                station_id climate_id WMO_id TC_id   lat   lon  elev tz        normals normals_1981_2010 normals_1971_2000
    ##   <chr> <chr>                            <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <lgl>   <lgl>             <lgl>            
    ## 1 MB    WINNIPEG RICHARDSON INT'L A       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/GMT+6 TRUE    TRUE              TRUE

Then you can download the climate normals with the `normals_dl()`
function.

``` r
n <- normals_dl("5023222")
```

See the [Getting
Started](https://docs.ropensci.org/weathercan/articles/weathercan.html)
vignette for more details.

## Citation

``` r
citation("weathercan")
```

    ## 
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

## License

The data and the code in this repository are licensed under multiple
licences. All code is licensed
[GPL-3](https://www.gnu.org/licenses/gpl-3.0.en.html). All weather data
is licensed under the ([Open Government License -
Canada](http://open.canada.ca/en/open-government-licence-canada)).

## `weathercan` in the wild!

-   Browse [`weathercan` use cases](https://ropensci.org/usecases/) on
    rOpenSci.org
-   Checkout the [`weathercan` Shiny
    App](https://nickrongkp.shinyapps.io/WeatherCan/) by Nick Rong
    (@nickyrong) and Nathan Smith (@WraySmith)
-   R package
    [`RavenR`](https://github.com/rchlumsk/RavenR/tree/master/R) has
    functions for converting ECCC data downloaded by `weathercan` to the
    .rvt format for Raven.
-   R package [`meteoland`](https://github.com/emf-creaf/meteoland) has
    functions for converting ECCC data downloaded by `weathercan` to the
    format required for use in `meteoland`.

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

## Contributions

We welcome any and all contributions! To make the process as painless as
possible for all involved, please see our [guide to
contributing](CONTRIBUTING.md)

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://ropensci.org/code-of-conduct/). By participating in
this project you agree to abide by its terms.

[![ropensci\_footer](http://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
