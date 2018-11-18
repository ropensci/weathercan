
# weathercan <img src="https://github.com/ropensci/weathercan/raw/master/inst/assets/weathercan_logo.png" align = "right" width = 110/>

[![Build
Status](https://travis-ci.org/ropensci/weathercan.svg?branch=master)](https://travis-ci.org/ropensci/weathercan)
[![AppVeyor Build
status](https://ci.appveyor.com/api/projects/status/l2afqnduhmmir3xl/branch/master?svg=true)](https://ci.appveyor.com/project/steffilazerte/weathercan/branch/master)
[![codecov](https://codecov.io/gh/ropensci/weathercan/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/weathercan)

[![](https://badges.ropensci.org/160_status.svg)](https://github.com/ropensci/onboarding/issues/160)
[![DOI](https://zenodo.org/badge/60650396.svg)](https://zenodo.org/badge/latestdoi/60650396)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.00571/status.svg)](https://doi.org/10.21105/joss.00571)

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/weathercan)](https://cran.r-project.org/package=weathercan)
[![CRAN
Downloads](http://cranlogs.r-pkg.org/badges/grand-total/weathercan)](https://CRAN.R-project.org/package=weathercan)

This package makes it easier to search for and download multiple
months/years of historical weather data from [Environment and Climate
Change Canada (ECCC)
website](http://climate.weather.gc.ca/historical_data/search_historic_data_e.html).

Bear in mind that these downloads can be fairly large and performing
multiple downloads may use up ECCC’s bandwidth unecessarily. Try to
stick to what you need.

For more details and tutorials checkout the [weathercan
website](http://ropensci.github.io/weathercan)

## Installation

You can install `weathercan` directly from CRAN:

``` r
install.packages("weathercan")
```

Use the `devtools` package to install the developmental package from
GitHub:

``` r
install.packages("devtools") # If not already installed
devtools::install_github("ropensci/weathercan") 
```

To build the developmental vignettes (tutorials) locally, use:

``` r
devtools::install_github("ropensci/weathercan", build_vignettes = TRUE) 
```

View the available vignettes with `vignette(package = "weathercan")`

View a particular vignette with, for example, `vignette("weathercan",
package = "weathercan")`

## General usage

To download data, you first need to know the `station_id` associated
with the station you’re interested in.

### Stations

`weathercan` includes a data frame called `stations` which includes a
list of stations and their details (including `station_id`.

``` r
head(stations)
```

    ## # A tibble: 6 x 13
    ##   prov  station_name station_id climate_id WMO_id TC_id   lat   lon  elev tz   interval start   end
    ##   <fct> <chr>        <fct>      <fct>      <fct>  <fct> <dbl> <dbl> <dbl> <ch> <chr>    <int> <int>
    ## 1 AB    DAYSLAND     1795       301AR54    <NA>   <NA>   52.9 -112.  689. Etc… day       1908  1922
    ## 2 AB    DAYSLAND     1795       301AR54    <NA>   <NA>   52.9 -112.  689. Etc… hour        NA    NA
    ## 3 AB    DAYSLAND     1795       301AR54    <NA>   <NA>   52.9 -112.  689. Etc… month     1908  1922
    ## 4 AB    EDMONTON CO… 1796       301BK03    <NA>   <NA>   53.6 -114.  671. Etc… day       1978  1979
    ## 5 AB    EDMONTON CO… 1796       301BK03    <NA>   <NA>   53.6 -114.  671. Etc… hour        NA    NA
    ## 6 AB    EDMONTON CO… 1796       301BK03    <NA>   <NA>   53.6 -114.  671. Etc… month     1978  1979

``` r
glimpse(stations)
```

    ## Observations: 26,217
    ## Variables: 13
    ## $ prov         <fct> AB, AB, AB, AB, AB, AB, AB, AB, AB, AB, AB, AB, AB, AB, AB, AB, AB, AB, AB...
    ## $ station_name <chr> "DAYSLAND", "DAYSLAND", "DAYSLAND", "EDMONTON CORONATION", "EDMONTON CORON...
    ## $ station_id   <fct> 1795, 1795, 1795, 1796, 1796, 1796, 1797, 1797, 1797, 1798, 1798, 1798, 17...
    ## $ climate_id   <fct> 301AR54, 301AR54, 301AR54, 301BK03, 301BK03, 301BK03, 301B6L0, 301B6L0, 30...
    ## $ WMO_id       <fct> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
    ## $ TC_id        <fct> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
    ## $ lat          <dbl> 52.87, 52.87, 52.87, 53.57, 53.57, 53.57, 52.15, 52.15, 52.15, 53.20, 53.2...
    ## $ lon          <dbl> -112.28, -112.28, -112.28, -113.57, -113.57, -113.57, -111.73, -111.73, -1...
    ## $ elev         <dbl> 688.8, 688.8, 688.8, 670.6, 670.6, 670.6, 838.2, 838.2, 838.2, 640.0, 640....
    ## $ tz           <chr> "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+7", "Etc/GMT+...
    ## $ interval     <chr> "day", "hour", "month", "day", "hour", "month", "day", "hour", "month", "d...
    ## $ start        <int> 1908, NA, 1908, 1978, NA, 1978, 1987, NA, 1987, 1987, NA, 1987, 1980, NA, ...
    ## $ end          <int> 1922, NA, 1922, 1979, NA, 1979, 1990, NA, 1990, 1998, NA, 1998, 2009, NA, ...

You can look through this data frame directly, or you can use the
`stations_search` function:

``` r
stations_search("Kamloops", interval = "hour")
```

    ## # A tibble: 3 x 13
    ##   prov  station_name station_id climate_id WMO_id TC_id   lat   lon  elev tz   interval start   end
    ##   <fct> <chr>        <fct>      <fct>      <fct>  <fct> <dbl> <dbl> <dbl> <ch> <chr>    <int> <int>
    ## 1 BC    KAMLOOPS A   1275       1163780    71887  YKA    50.7 -120.  345. Etc… hour      1953  2013
    ## 2 BC    KAMLOOPS A   51423      1163781    71887  YKA    50.7 -120.  345. Etc… hour      2013  2018
    ## 3 BC    KAMLOOPS AUT 42203      1163842    71741  ZKA    50.7 -120.  345  Etc… hour      2006  2018

Time frame must be one of “hour”, “day”, or “month”.

You can also search by
proximity:

``` r
stations_search(coords = c(50.667492, -120.329049), dist = 20, interval = "hour")
```

    ## # A tibble: 3 x 14
    ##   prov  station_name station_id climate_id WMO_id TC_id   lat   lon  elev tz    interval start   end
    ##   <fct> <chr>        <fct>      <fct>      <fct>  <fct> <dbl> <dbl> <dbl> <chr> <chr>    <int> <int>
    ## 1 BC    KAMLOOPS A   1275       1163780    71887  YKA    50.7 -120.  345. Etc/… hour      1953  2013
    ## 2 BC    KAMLOOPS AUT 42203      1163842    71741  ZKA    50.7 -120.  345  Etc/… hour      2006  2018
    ## 3 BC    KAMLOOPS A   51423      1163781    71887  YKA    50.7 -120.  345. Etc/… hour      2013  2018
    ## # ... with 1 more variable: distance <dbl>

### Weather

Once you have your `station_id`(s) you can download weather
data:

``` r
kam <- weather_dl(station_ids = 51423, start = "2018-02-01", end = "2018-04-15")
kam
```

    ## # A tibble: 1,776 x 35
    ##    station_name station_id station_operator prov    lat   lon  elev climate_id WMO_id TC_id
    ##  * <chr>             <dbl> <chr>            <fct> <dbl> <dbl> <dbl> <chr>      <chr>  <chr>
    ##  1 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA  
    ##  2 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA  
    ##  3 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA  
    ##  4 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA  
    ##  5 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA  
    ##  6 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA  
    ##  7 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA  
    ##  8 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA  
    ##  9 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA  
    ## 10 KAMLOOPS A        51423 NAV Canada       BC     50.7 -120.  345. 1163781    71887  YKA  
    ## # ... with 1,766 more rows, and 25 more variables

You can also download data from multiple stations at
once:

``` r
kam_pg <- weather_dl(station_ids = c(48248, 51423), start = "2018-02-01", end = "2018-04-15")
```

And plot it:

``` r
library(ggplot2)

ggplot(data = kam_pg, aes(x = time, y = temp, group = station_name, colour = station_name)) +
  theme_minimal() + 
  geom_line()
```

![](tools/readme/kam_plt-1.png)<!-- -->

## Citation

``` r
citation("weathercan")
```

    ## 
    ## To cite 'weathercan' in publications, please use:
    ## 
    ##   LaZerte, Stefanie E and Sam Albers (2018). weathercan: Download and format weather data
    ##   from Environment and Climate Change Canada. The Journal of Open Source Software
    ##   3(22):571. doi:10.21105/joss.00571.
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
    ##     url = {http://joss.theoj.org/papers/10.21105/joss.00571},
    ##   }

## License

The data and the code in this repository are licensed under multiple
licences. All code is licensed
[GPL-3](https://www.gnu.org/licenses/gpl-3.0.en.html). All weather data
is licensed under the ([Open Government License -
Canada](http://open.canada.ca/en/open-government-licence-canada)).

## Similar packages

1)  [`rclimateca`](https://cran.rstudio.com/web/packages/rclimateca/index.html)

`weathercan` and `rclimateca` were developed at roughly the same time
and as a result, both present up-to-date methods for accessing and
downloading data from ECCC. The largest differences between the two
packages are: a) `weathercan` includes functions for interpolating
weather data and directly integrating it into other data sources. b)
`weathercan` actively seeks to apply tidy data principles in R and
integrates well with the tidyverse including using tibbles and nested
listcols. c) `rclimateca` contains arguments for specifying short
vs. long data formats. d) `rclimateca` has the option of formatting
data in the MUData format using the
[`mudata2`](https://cran.r-project.org/web/packages/mudata2/index.html)
package by the same author.

2)  [`CHCN`](https://cran.rstudio.com/web/packages/CHCN/index.html)

`CHCN` is an older package last updated in 2012. Unfortunately, ECCC
updated their services within the last couple of years which caused a
great many of the previous web scrapers to fail. `CHCN` relies on one of
these [older
web-scrapers](https://classic.scraperwiki.com/scrapers/can-weather-stations/)
and so is currently broken.

## Contributions

We welcome any and all contributions\! To make the process as painless
as possible for all involved, please see our [guide to
contributing](CONTRIBUTING.md)

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its
terms.

[![ropensci\_footer](http://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
