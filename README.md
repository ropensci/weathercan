README
================
Steffi LaZerte

[![Build Status](https://travis-ci.org/steffilazerte/weathercan.svg?branch=v0.2.2)](https://travis-ci.org/steffilazerte/weathercan) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/steffilazerte/weathercan?branch=v0.2.2&svg=true)](https://ci.appveyor.com/project/steffilazerte/weathercan)

weathercan
==========

This package is makes it easier to search for and download multiple months/years of historical weather data from Environment and Climate Change Canada (ECCC) website.

Bear in mind that these downloads can be fairly large and performing multiple, downloads may use up ECCC's bandwidth unecessarily. Try to stick to what you need.

Installation
------------

Use the `devtools` package to directly install R packages from github:

``` r
install.packages("devtools") # If not already installed
devtools::install_github("steffilazerte/weathercan") 
```

General usage
-------------

To download data, you first need to know the `station_id` associated with the station you're interested in.

### Stations

`weathercan` includes a data frame called `stations` which includes a list of stations and their details (including `station_id`.

``` r
head(stations)
```

    ## # A tibble: 6 x 12
    ##     prov           station_name station_id climate_id WMO_id  TC_id   lat
    ##   <fctr>                  <chr>     <fctr>     <fctr> <fctr> <fctr> <dbl>
    ## 1     BC            ACTIVE PASS         14    1010066     NA     NA 48.87
    ## 2     BC            ALBERT HEAD         15    1010235     NA     NA 48.40
    ## 3     BC BAMBERTON OCEAN CEMENT         16    1010595     NA     NA 48.58
    ## 4     BC             BEAR CREEK         17    1010720     NA     NA 48.50
    ## 5     BC            BEAVER LAKE         18    1010774     NA     NA 48.50
    ## 6     BC             BECHER BAY         19    1010780     NA     NA 48.33
    ## # ... with 5 more variables: lon <dbl>, elev <dbl>, interval <chr>,
    ## #   start <int>, end <int>

``` r
glimpse(stations)
```

    ## Observations: 26,211
    ## Variables: 12
    ## $ prov         <fctr> BC, BC, BC, BC, BC, BC, BC, BC, BC, BC, BC, BC, ...
    ## $ station_name <chr> "ACTIVE PASS", "ALBERT HEAD", "BAMBERTON OCEAN CE...
    ## $ station_id   <fctr> 14, 15, 16, 17, 18, 19, 20, 21, 22, 25, 24, 23, ...
    ## $ climate_id   <fctr> 1010066, 1010235, 1010595, 1010720, 1010774, 101...
    ## $ WMO_id       <fctr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
    ## $ TC_id        <fctr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
    ## $ lat          <dbl> 48.87, 48.40, 48.58, 48.50, 48.50, 48.33, 48.60, ...
    ## $ lon          <dbl> -123.28, -123.48, -123.52, -124.00, -123.35, -123...
    ## $ elev         <dbl> 4.0, 17.0, 85.3, 350.5, 61.0, 12.2, 38.0, 30.5, 9...
    ## $ interval     <chr> "hour", "hour", "hour", "hour", "hour", "hour", "...
    ## $ start        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
    ## $ end          <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...

You can look through this data frame directly, or you can use the `stations_search` function:

``` r
stations_search("Kamloops", interval = "hour")
```

    ## # A tibble: 3 x 12
    ##     prov station_name station_id climate_id WMO_id  TC_id   lat     lon
    ##   <fctr>        <chr>     <fctr>     <fctr> <fctr> <fctr> <dbl>   <dbl>
    ## 1     BC   KAMLOOPS A       1275    1163780  71887    YKA  50.7 -120.44
    ## 2     BC   KAMLOOPS A      51423    1163781  71887    YKA  50.7 -120.45
    ## 3     BC KAMLOOPS AUT      42203    1163842  71741    ZKA  50.7 -120.44
    ## # ... with 4 more variables: elev <dbl>, interval <chr>, start <int>,
    ## #   end <int>

Time frame must be one of "hour", "day", or "month".

You can also search by proximity:

``` r
stations_search(coords = c(50.667492, -120.329049), dist = 20, interval = "hour")
```

    ## # A tibble: 3 x 13
    ##     prov station_name station_id climate_id WMO_id  TC_id   lat     lon
    ##   <fctr>        <chr>     <fctr>     <fctr> <fctr> <fctr> <dbl>   <dbl>
    ## 1     BC   KAMLOOPS A       1275    1163780  71887    YKA  50.7 -120.44
    ## 2     BC KAMLOOPS AUT      42203    1163842  71741    ZKA  50.7 -120.44
    ## 3     BC   KAMLOOPS A      51423    1163781  71887    YKA  50.7 -120.45
    ## # ... with 5 more variables: elev <dbl>, interval <chr>, start <int>,
    ## #   end <int>, distance <dbl>

### Weather

Once you have your `station_id`(s) you can download weather data:

``` r
kam <- weather(station_ids = 51423, start = "2016-01-01", end = "2016-02-15")
kam
```

    ## # A tibble: 1,104 x 35
    ##    station_name station_id   prov   lat     lon       date
    ##  *        <chr>      <dbl> <fctr> <dbl>   <dbl>     <date>
    ##  1   KAMLOOPS A      51423     BC  50.7 -120.45 2016-01-01
    ##  2   KAMLOOPS A      51423     BC  50.7 -120.45 2016-01-01
    ##  3   KAMLOOPS A      51423     BC  50.7 -120.45 2016-01-01
    ##  4   KAMLOOPS A      51423     BC  50.7 -120.45 2016-01-01
    ##  5   KAMLOOPS A      51423     BC  50.7 -120.45 2016-01-01
    ##  6   KAMLOOPS A      51423     BC  50.7 -120.45 2016-01-01
    ##  7   KAMLOOPS A      51423     BC  50.7 -120.45 2016-01-01
    ##  8   KAMLOOPS A      51423     BC  50.7 -120.45 2016-01-01
    ##  9   KAMLOOPS A      51423     BC  50.7 -120.45 2016-01-01
    ## 10   KAMLOOPS A      51423     BC  50.7 -120.45 2016-01-01
    ## # ... with 1,094 more rows, and 29 more variables: time <dttm>,
    ## #   year <chr>, month <chr>, day <chr>, hour <chr>, qual <chr>,
    ## #   weather <chr>, hmdx <dbl>, hmdx_flag <chr>, pressure <dbl>,
    ## #   pressure_flag <chr>, rel_hum <dbl>, rel_hum_flag <chr>, temp <dbl>,
    ## #   temp_dew <dbl>, temp_dew_flag <chr>, temp_flag <chr>, visib <dbl>,
    ## #   visib_flag <chr>, wind_chill <dbl>, wind_chill_flag <chr>,
    ## #   wind_dir <dbl>, wind_dir_flag <chr>, wind_spd <dbl>,
    ## #   wind_spd_flag <chr>, elev <dbl>, climat_id <chr>, WMO_id <chr>,
    ## #   TC_id <chr>

You can also download data from multiple stations at once:

``` r
kam_pg <- weather(station_ids = c(48248, 51423), start = "2016-01-01", end = "2016-02-15")
kam_pg
```

    ## # A tibble: 2,208 x 35
    ##                  station_name station_id   prov   lat     lon       date
    ##  *                      <chr>      <dbl> <fctr> <dbl>   <dbl>     <date>
    ##  1 PRINCE GEORGE AIRPORT AUTO      48248     BC 53.89 -122.67 2016-01-01
    ##  2 PRINCE GEORGE AIRPORT AUTO      48248     BC 53.89 -122.67 2016-01-01
    ##  3 PRINCE GEORGE AIRPORT AUTO      48248     BC 53.89 -122.67 2016-01-01
    ##  4 PRINCE GEORGE AIRPORT AUTO      48248     BC 53.89 -122.67 2016-01-01
    ##  5 PRINCE GEORGE AIRPORT AUTO      48248     BC 53.89 -122.67 2016-01-01
    ##  6 PRINCE GEORGE AIRPORT AUTO      48248     BC 53.89 -122.67 2016-01-01
    ##  7 PRINCE GEORGE AIRPORT AUTO      48248     BC 53.89 -122.67 2016-01-01
    ##  8 PRINCE GEORGE AIRPORT AUTO      48248     BC 53.89 -122.67 2016-01-01
    ##  9 PRINCE GEORGE AIRPORT AUTO      48248     BC 53.89 -122.67 2016-01-01
    ## 10 PRINCE GEORGE AIRPORT AUTO      48248     BC 53.89 -122.67 2016-01-01
    ## # ... with 2,198 more rows, and 29 more variables: time <dttm>,
    ## #   year <chr>, month <chr>, day <chr>, hour <chr>, qual <chr>,
    ## #   weather <chr>, hmdx <dbl>, hmdx_flag <chr>, pressure <dbl>,
    ## #   pressure_flag <chr>, rel_hum <dbl>, rel_hum_flag <chr>, temp <dbl>,
    ## #   temp_dew <dbl>, temp_dew_flag <chr>, temp_flag <chr>, visib <dbl>,
    ## #   visib_flag <chr>, wind_chill <dbl>, wind_chill_flag <chr>,
    ## #   wind_dir <dbl>, wind_dir_flag <chr>, wind_spd <dbl>,
    ## #   wind_spd_flag <chr>, elev <dbl>, climat_id <chr>, WMO_id <chr>,
    ## #   TC_id <chr>

And plot it:

``` r
library(ggplot2)

ggplot(data = kam_pg, aes(x = time, y = temp, group = station_name, colour = station_name)) +
  theme(legend.position = "top") +
  geom_line() +
  theme_minimal()
```

![](README_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-8-1.png)

License
=======

The data and the code in this repository are licensed under multiple licences. All code is licensed [GPL-3](https://www.gnu.org/licenses/gpl-3.0.en.html). All data is licensed under the ([Open Government License - Canada](http://open.canada.ca/en/open-government-licence-canada)).
