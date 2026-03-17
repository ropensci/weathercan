
# weathercan <img src="https://github.com/ropensci/weathercan/raw/main/inst/assets/weathercan_logo.png" align = "right" width = 110/>

[![:name status
badge](https://ropensci.r-universe.dev/badges/:name)](https://ropensci.r-universe.dev)
[![weathercan status
badge](https://ropensci.r-universe.dev/badges/weathercan)](https://ropensci.r-universe.dev)
[![R-CMD-check](https://github.com/ropensci/weathercan/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/weathercan/actions)
[![codecov](https://codecov.io/gh/ropensci/weathercan/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ropensci/weathercan)

[![](https://badges.ropensci.org/160_status.svg)](https://github.com/ropensci/software-review/issues/160)
[![DOI](https://zenodo.org/badge/60650396.svg)](https://zenodo.org/badge/latestdoi/60650396)
[![DOI](http://joss.theoj.org/papers/10.21105/joss.00571/status.svg)](https://doi.org/10.21105/joss.00571)

<!-- [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/weathercan)](https://cran.r-project.org/package=weathercan) [![CRAN Downloads](http://cranlogs.r-pkg.org/badges/grand-total/weathercan)](https://CRAN.R-project.org/package=weathercan) -->

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
install.packages("weathercan", 
                 repos = c("https://ropensci.r-universe.dev", 
                           "https://cloud.r-project.org"))
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

    ## # A tibble: 6 × 17
    ##   prov  station_name        station_id climate_id WMO_id TC_id   lat   lon  elev tz        interval start   end normals normals_1991_2020 normals_1981_2010
    ##   <chr> <chr>                    <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <chr>    <dbl> <dbl> <lgl>   <lgl>             <lgl>            
    ## 1 AB    DAYSLAND                  1795 301AR54        NA <NA>   52.9 -112.  689. Etc/GMT+7 day       1908  1922 FALSE   FALSE             FALSE            
    ## 2 AB    DAYSLAND                  1795 301AR54        NA <NA>   52.9 -112.  689. Etc/GMT+7 hour        NA    NA FALSE   FALSE             FALSE            
    ## 3 AB    DAYSLAND                  1795 301AR54        NA <NA>   52.9 -112.  689. Etc/GMT+7 month     1908  1922 FALSE   FALSE             FALSE            
    ## 4 AB    EDMONTON CORONATION       1796 301BK03        NA <NA>   53.6 -114.  671. Etc/GMT+7 day       1978  1979 FALSE   FALSE             FALSE            
    ## 5 AB    EDMONTON CORONATION       1796 301BK03        NA <NA>   53.6 -114.  671. Etc/GMT+7 hour        NA    NA FALSE   FALSE             FALSE            
    ## 6 AB    EDMONTON CORONATION       1796 301BK03        NA <NA>   53.6 -114.  671. Etc/GMT+7 month     1978  1979 FALSE   FALSE             FALSE            
    ## # ℹ 1 more variable: normals_1971_2000 <lgl>

``` r
glimpse(stations())
```

    ## Rows: 26,445
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
    ## $ interval          <chr> "day", "hour", "month", "day", "hour", "month", "day", "hour", "month", "day", "hour", "month", "day", "hour", "month", "day", "hour…
    ## $ start             <dbl> 1908, NA, 1908, 1978, NA, 1978, 1987, NA, 1987, 1987, NA, 1987, 1980, NA, 1980, 1980, NA, 1980, 1986, NA, 1986, 1987, NA, 1987, 1986…
    ## $ end               <dbl> 1922, NA, 1922, 1979, NA, 1979, 1990, NA, 1990, 1998, NA, 1998, 2009, NA, 2007, 1981, NA, 1981, 2019, NA, 2007, 1991, NA, 1991, 1995…
    ## $ normals           <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRU…
    ## $ normals_1991_2020 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
    ## $ normals_1981_2010 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRU…
    ## $ normals_1971_2000 <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…

You can look through this data frame directly, or you can use the
`stations_search` function:

``` r
stations_search("Kamloops", interval = "hour")
```

    ## # A tibble: 3 × 17
    ##   prov  station_name station_id climate_id WMO_id TC_id   lat   lon  elev tz        interval start   end normals normals_1991_2020 normals_1981_2010
    ##   <chr> <chr>             <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <chr>    <dbl> <dbl> <lgl>   <lgl>             <lgl>            
    ## 1 BC    KAMLOOPS A         1275 1163780     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      1953  2013 TRUE    TRUE              TRUE             
    ## 2 BC    KAMLOOPS A        51423 1163781     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      2013  2025 TRUE    TRUE              FALSE            
    ## 3 BC    KAMLOOPS AUT      42203 1163842     71741 ZKA    50.7 -120.  345  Etc/GMT+8 hour      2006  2025 TRUE    TRUE              FALSE            
    ## # ℹ 1 more variable: normals_1971_2000 <lgl>

Time frame must be one of “hour”, “day”, or “month”.

You can also search by proximity:

``` r
stations_search(coords = c(50.667492, -120.329049), dist = 20, interval = "hour")
```

    ## # A tibble: 3 × 18
    ##   prov  station_name station_id climate_id WMO_id TC_id   lat   lon  elev tz        interval start   end normals normals_1991_2020 normals_1981_2010
    ##   <chr> <chr>             <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <chr>    <dbl> <dbl> <lgl>   <lgl>             <lgl>            
    ## 1 BC    KAMLOOPS A         1275 1163780     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      1953  2013 TRUE    TRUE              TRUE             
    ## 2 BC    KAMLOOPS AUT      42203 1163842     71741 ZKA    50.7 -120.  345  Etc/GMT+8 hour      2006  2025 TRUE    TRUE              FALSE            
    ## 3 BC    KAMLOOPS A        51423 1163781     71887 YKA    50.7 -120.  345. Etc/GMT+8 hour      2013  2025 TRUE    TRUE              FALSE            
    ## # ℹ 2 more variables: normals_1971_2000 <lgl>, distance <dbl>

You can update this list of stations with

``` r
stations_dl()
```

    ## According to Environment Canada, Modified Date: 2025-07-01 23:30 UTC

    ## Environment Canada Disclaimers:
    ## "Station Inventory Disclaimer: Please note that this inventory list is a snapshot of stations on our website as of the modified date, and may be subject to change without notice."
    ## "Station ID Disclaimer: Station IDs are an internal index numbering system and may be subject to change without notice."

    ## Stations data saved...
    ## Use `stations()` to access most recent version and `stations_meta()` to see when this was last updated

And check when it was last updated with

``` r
stations_meta()
```

    ## $ECCC_modified
    ## [1] "2025-07-01 23:30:00 UTC"
    ## 
    ## $weathercan_modified
    ## [1] "2025-07-25"

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

    ## # A tibble: 1,776 × 38
    ##    station_name station_id station_operator prov    lat   lon  elev climate_id WMO_id TC_id date       time                year  month day   hour  qual  weather
    ##    <chr>             <dbl> <lgl>            <chr> <dbl> <dbl> <dbl> <chr>      <chr>  <chr> <date>     <dttm>              <chr> <chr> <chr> <chr> <chr> <chr>  
    ##  1 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 00:00:00 2018  02    01    00:00 <NA>  <NA>   
    ##  2 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 01:00:00 2018  02    01    01:00 <NA>  Snow   
    ##  3 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 02:00:00 2018  02    01    02:00 <NA>  <NA>   
    ##  4 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 03:00:00 2018  02    01    03:00 <NA>  <NA>   
    ##  5 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 04:00:00 2018  02    01    04:00 <NA>  Cloudy 
    ##  6 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 05:00:00 2018  02    01    05:00 <NA>  <NA>   
    ##  7 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 06:00:00 2018  02    01    06:00 <NA>  <NA>   
    ##  8 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 07:00:00 2018  02    01    07:00 <NA>  Cloudy 
    ##  9 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 08:00:00 2018  02    01    08:00 <NA>  <NA>   
    ## 10 KAMLOOPS A        51423 NA               BC     50.7 -120.  345. 1163781    71887  YKA   2018-02-01 2018-02-01 09:00:00 2018  02    01    09:00 <NA>  <NA>   
    ## # ℹ 1,766 more rows

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

    ## # A tibble: 1 × 14
    ##   prov  station_name                station_id climate_id WMO_id TC_id   lat   lon  elev tz        normals normals_1991_2020 normals_1981_2010 normals_1971_2000
    ##   <chr> <chr>                            <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr>     <lgl>   <lgl>             <lgl>             <lgl>            
    ## 1 MB    WINNIPEG RICHARDSON INT'L A       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/GMT+6 TRUE    TRUE              TRUE              TRUE

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

- Browse [`weathercan` use cases](https://ropensci.org/usecases/) on
  rOpenSci.org
- Checkout the [`weathercan` Shiny
  App](https://nickrongkp.shinyapps.io/WeatherCan/) by Nick Rong
  (@nickyrong) and Nathan Smith (@WraySmith)
- R package [`RavenR`](https://github.com/rchlumsk/RavenR/tree/master/R)
  has functions for converting ECCC data downloaded by `weathercan` to
  the .rvt format for Raven.
- R package [`meteoland`](https://github.com/emf-creaf/meteoland) has
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

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://ropensci.org/code-of-conduct/). By participating in
this project you agree to abide by its terms.

## Contributions

We welcome any and all contributions! To make the process as painless as
possible for all involved, please see our [guide to
contributing](CONTRIBUTING.md)

## Contributors








<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

All contributions to this project are gratefully acknowledged using the [`allcontributors` package](https://github.com/ropensci/allcontributors) following the [all-contributors](https://allcontributors.org) specification. Contributions of any kind are welcome!

### Code

<table>

<tr>
<td align="center">
<a href="https://github.com/steffilazerte">
<img src="https://avatars.githubusercontent.com/u/14676081?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=steffilazerte">steffilazerte</a>
</td>
<td align="center">
<a href="https://github.com/boshek">
<img src="https://avatars.githubusercontent.com/u/18472598?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=boshek">boshek</a>
</td>
<td align="center">
<a href="https://github.com/mustberuss">
<img src="https://avatars.githubusercontent.com/u/14958432?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=mustberuss">mustberuss</a>
</td>
<td align="center">
<a href="https://github.com/JauntyJJS">
<img src="https://avatars.githubusercontent.com/u/9066508?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=JauntyJJS">JauntyJJS</a>
</td>
<td align="center">
<a href="https://github.com/maelle">
<img src="https://avatars.githubusercontent.com/u/8360597?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=maelle">maelle</a>
</td>
<td align="center">
<a href="https://github.com/nicholas512">
<img src="https://avatars.githubusercontent.com/u/15223327?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=nicholas512">nicholas512</a>
</td>
<td align="center">
<a href="https://github.com/mciechanumich">
<img src="https://avatars.githubusercontent.com/u/110423309?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=mciechanumich">mciechanumich</a>
</td>
</tr>


<tr>
<td align="center">
<a href="https://github.com/jeroen">
<img src="https://avatars.githubusercontent.com/u/216319?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=jeroen">jeroen</a>
</td>
<td align="center">
<a href="https://github.com/joshpersi">
<img src="https://avatars.githubusercontent.com/u/38633218?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=joshpersi">joshpersi</a>
</td>
<td align="center">
<a href="https://github.com/RichardLitt">
<img src="https://avatars.githubusercontent.com/u/910753?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=RichardLitt">RichardLitt</a>
</td>
<td align="center">
<a href="https://github.com/shandiya">
<img src="https://avatars.githubusercontent.com/u/25561324?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=shandiya">shandiya</a>
</td>
<td align="center">
<a href="https://github.com/mahjabinoyshi">
<img src="https://avatars.githubusercontent.com/u/197597579?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=mahjabinoyshi">mahjabinoyshi</a>
</td>
<td align="center">
<a href="https://github.com/everettsp">
<img src="https://avatars.githubusercontent.com/u/24480376?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=everettsp">everettsp</a>
</td>
<td align="center">
<a href="https://github.com/kellijohnson-NOAA">
<img src="https://avatars.githubusercontent.com/u/4108564?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/commits?author=kellijohnson-NOAA">kellijohnson-NOAA</a>
</td>
</tr>

</table>


### Issue Authors

<table>

<tr>
<td align="center">
<a href="https://github.com/paleolimbot">
<img src="https://avatars.githubusercontent.com/u/10995762?u=e59fac54d0c9e857e0740e63579a7a10df3acf24&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Apaleolimbot">paleolimbot</a>
</td>
<td align="center">
<a href="https://github.com/joethorley">
<img src="https://avatars.githubusercontent.com/u/613671?u=36846e1d63ac2709c1f9cfe69f5e0a740f90ec3b&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Ajoethorley">joethorley</a>
</td>
<td align="center">
<a href="https://github.com/pbulsink">
<img src="https://avatars.githubusercontent.com/u/5419974?u=a8ef3c2ac1c7db26335c1883b438d4857fc4dd08&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Apbulsink">pbulsink</a>
</td>
<td align="center">
<a href="https://github.com/durraniu">
<img src="https://avatars.githubusercontent.com/u/7092652?u=39e2ddc26666c054fec46b0a43e8f3b3e51ff57a&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Adurraniu">durraniu</a>
</td>
<td align="center">
<a href="https://github.com/stefaniebutland">
<img src="https://avatars.githubusercontent.com/u/11927811?u=ea2b36cbdc6c1d4b5cd9231b397c03998d730626&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Astefaniebutland">stefaniebutland</a>
</td>
<td align="center">
<a href="https://github.com/adamhsparks">
<img src="https://avatars.githubusercontent.com/u/3195906?u=5d16842aa4ede1ddaa8911e126cc57b76ff22255&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Aadamhsparks">adamhsparks</a>
</td>
<td align="center">
<a href="https://github.com/nadrojordan">
<img src="https://avatars.githubusercontent.com/u/45609791?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Anadrojordan">nadrojordan</a>
</td>
</tr>


<tr>
<td align="center">
<a href="https://github.com/macsmith26">
<img src="https://avatars.githubusercontent.com/u/8423170?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Amacsmith26">macsmith26</a>
</td>
<td align="center">
<a href="https://github.com/essicolo">
<img src="https://avatars.githubusercontent.com/u/5118227?u=96e19b82af1f2cfcfbfd1a108ce2434b279f8079&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Aessicolo">essicolo</a>
</td>
<td align="center">
<a href="https://github.com/sckott">
<img src="https://avatars.githubusercontent.com/u/577668?u=c54eb1ce08ff22365e094559a109a12437bdca40&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Asckott">sckott</a>
</td>
<td align="center">
<a href="https://github.com/AreliaTW">
<img src="https://avatars.githubusercontent.com/u/9757190?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3AAreliaTW">AreliaTW</a>
</td>
<td align="center">
<a href="https://github.com/WatershedFlow">
<img src="https://avatars.githubusercontent.com/u/54557989?u=9f928dbad590dee9cee8b3bbd412ead410aeb7f8&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3AWatershedFlow">WatershedFlow</a>
</td>
<td align="center">
<a href="https://github.com/cgquick">
<img src="https://avatars.githubusercontent.com/u/41929199?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Acgquick">cgquick</a>
</td>
<td align="center">
<a href="https://github.com/emhodg">
<img src="https://avatars.githubusercontent.com/u/39999885?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Aemhodg">emhodg</a>
</td>
</tr>


<tr>
<td align="center">
<a href="https://github.com/klwilson23">
<img src="https://avatars.githubusercontent.com/u/17127598?u=5f4b8f7dc6a51ccc903c1bbda5eda94cf935d2f2&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Aklwilson23">klwilson23</a>
</td>
<td align="center">
<a href="https://github.com/jjvenky">
<img src="https://avatars.githubusercontent.com/u/5414862?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Ajjvenky">jjvenky</a>
</td>
<td align="center">
<a href="https://github.com/greenLauren">
<img src="https://avatars.githubusercontent.com/u/38663672?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3AgreenLauren">greenLauren</a>
</td>
<td align="center">
<a href="https://github.com/tspeidel">
<img src="https://avatars.githubusercontent.com/u/6731198?u=df8c5eb153bc062517dd937b4f59674ddec38b04&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Atspeidel">tspeidel</a>
</td>
<td align="center">
<a href="https://github.com/datacarvel">
<img src="https://avatars.githubusercontent.com/u/13441528?u=aebdf93bc1759b5c82752dbdeafb180021e8f315&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Adatacarvel">datacarvel</a>
</td>
<td align="center">
<a href="https://github.com/AmeerDotHydro">
<img src="https://avatars.githubusercontent.com/u/35280932?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3AAmeerDotHydro">AmeerDotHydro</a>
</td>
<td align="center">
<a href="https://github.com/tspeidel-ey">
<img src="https://avatars.githubusercontent.com/u/66435255?u=44d99c50f4be8d0b9c38b0e55338507d47158a70&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Atspeidel-ey">tspeidel-ey</a>
</td>
</tr>


<tr>
<td align="center">
<a href="https://github.com/Carina8899">
<img src="https://avatars.githubusercontent.com/u/62023172?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3ACarina8899">Carina8899</a>
</td>
<td align="center">
<a href="https://github.com/amcilraithRRC">
<img src="https://avatars.githubusercontent.com/u/72586000?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3AamcilraithRRC">amcilraithRRC</a>
</td>
<td align="center">
<a href="https://github.com/AnneDaySRK">
<img src="https://avatars.githubusercontent.com/u/76066790?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3AAnneDaySRK">AnneDaySRK</a>
</td>
<td align="center">
<a href="https://github.com/a2grotto">
<img src="https://avatars.githubusercontent.com/u/57048454?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Aa2grotto">a2grotto</a>
</td>
<td align="center">
<a href="https://github.com/FraserHemis">
<img src="https://avatars.githubusercontent.com/u/77513170?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3AFraserHemis">FraserHemis</a>
</td>
<td align="center">
<a href="https://github.com/rajibshibly">
<img src="https://avatars.githubusercontent.com/u/39829190?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Arajibshibly">rajibshibly</a>
</td>
<td align="center">
<a href="https://github.com/mjdzr">
<img src="https://avatars.githubusercontent.com/u/58193630?u=7a713c8a36c3339ec89b312cca1b976dd3bb8c8e&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Amjdzr">mjdzr</a>
</td>
</tr>


<tr>
<td align="center">
<a href="https://github.com/juliasunga">
<img src="https://avatars.githubusercontent.com/u/78092195?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Ajuliasunga">juliasunga</a>
</td>
<td align="center">
<a href="https://github.com/KevCaz">
<img src="https://avatars.githubusercontent.com/u/1583534?u=51c94bcad641cfffb79f57e263b794dcb9413621&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3AKevCaz">KevCaz</a>
</td>
<td align="center">
<a href="https://github.com/ecwiebe">
<img src="https://avatars.githubusercontent.com/u/13489492?u=8d05f05e9bb79cdaec1aa5a5e033f22759526f6e&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Aecwiebe">ecwiebe</a>
</td>
<td align="center">
<a href="https://github.com/carlos-arnillas">
<img src="https://avatars.githubusercontent.com/u/26018349?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Acarlos-arnillas">carlos-arnillas</a>
</td>
<td align="center">
<a href="https://github.com/gilberto-sassi">
<img src="https://avatars.githubusercontent.com/u/47753866?u=be2874420e4d6c3d6690a62e1ecf8dec8a6bae26&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Agilberto-sassi">gilberto-sassi</a>
</td>
<td align="center">
<a href="https://github.com/busmansholiday">
<img src="https://avatars.githubusercontent.com/u/108430289?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Abusmansholiday">busmansholiday</a>
</td>
<td align="center">
<a href="https://github.com/gdelaplante">
<img src="https://avatars.githubusercontent.com/u/91148465?u=5ea48bdcf7c6f467924e89069d3c4697bb6342dc&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Agdelaplante">gdelaplante</a>
</td>
</tr>


<tr>
<td align="center">
<a href="https://github.com/JBauerPower">
<img src="https://avatars.githubusercontent.com/u/147277460?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3AJBauerPower">JBauerPower</a>
</td>
<td align="center">
<a href="https://github.com/x22925580-commits">
<img src="https://avatars.githubusercontent.com/u/242810550?u=4d778bfc33f734c22bbc53428ed06a998e7319b0&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Ax22925580-commits">x22925580-commits</a>
</td>
<td align="center">
<a href="https://github.com/zacharybelisle">
<img src="https://avatars.githubusercontent.com/u/205228980?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Azacharybelisle">zacharybelisle</a>
</td>
<td align="center">
<a href="https://github.com/ryanthrendyle-work">
<img src="https://avatars.githubusercontent.com/u/254770210?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+author%3Aryanthrendyle-work">ryanthrendyle-work</a>
</td>
</tr>

</table>


### Issue Contributors

<table>

<tr>
<td align="center">
<a href="https://github.com/ebourlon">
<img src="https://avatars.githubusercontent.com/u/26873630?u=3fe18d9da8d8064052ea0dc5ad11bbe9ea7b20fb&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3Aebourlon">ebourlon</a>
</td>
<td align="center">
<a href="https://github.com/clairervh">
<img src="https://avatars.githubusercontent.com/u/2093182?u=dea38aba64f8a9f9a2dc9a85f3a6f30550aa7d0b&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3Aclairervh">clairervh</a>
</td>
<td align="center">
<a href="https://github.com/rajeshroy402">
<img src="https://avatars.githubusercontent.com/u/40631866?u=a0340377b75b6f8038d009d2474131014a4ed0f6&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3Arajeshroy402">rajeshroy402</a>
</td>
<td align="center">
<a href="https://github.com/urbaingeo4455">
<img src="https://avatars.githubusercontent.com/u/57878964?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3Aurbaingeo4455">urbaingeo4455</a>
</td>
<td align="center">
<a href="https://github.com/CamMakoJ">
<img src="https://avatars.githubusercontent.com/u/16771660?u=67e4378f2c60ee6900bac76d3c6840492c75da84&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3ACamMakoJ">CamMakoJ</a>
</td>
<td align="center">
<a href="https://github.com/salix-d">
<img src="https://avatars.githubusercontent.com/u/31168746?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3Asalix-d">salix-d</a>
</td>
<td align="center">
<a href="https://github.com/wgieni">
<img src="https://avatars.githubusercontent.com/u/38118614?u=7a28ed517ee2ce279a06617ee858132ae8bbb72a&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3Awgieni">wgieni</a>
</td>
</tr>


<tr>
<td align="center">
<a href="https://github.com/tanmaydimriGSOC">
<img src="https://avatars.githubusercontent.com/u/105608756?v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3AtanmaydimriGSOC">tanmaydimriGSOC</a>
</td>
<td align="center">
<a href="https://github.com/farhanreynaldo">
<img src="https://avatars.githubusercontent.com/u/8732795?u=85782e91537627f642b48a59c52a5df1ff18343c&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3Afarhanreynaldo">farhanreynaldo</a>
</td>
<td align="center">
<a href="https://github.com/EmmaGRiley">
<img src="https://avatars.githubusercontent.com/u/132517733?u=c2e80b5e8bd790206e726098d803632d0234db54&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3AEmmaGRiley">EmmaGRiley</a>
</td>
<td align="center">
<a href="https://github.com/egdevoie">
<img src="https://avatars.githubusercontent.com/u/52979477?u=5b3ff7314872530433984e6c7fdd765927a91152&v=4" width="100px;" alt=""/>
</a><br>
<a href="https://github.com/ropensci/weathercan/issues?q=is%3Aissue+commenter%3Aegdevoie">egdevoie</a>
</td>
</tr>

</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->








[![ropensci_footer](http://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
