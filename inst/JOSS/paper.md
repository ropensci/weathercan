---
title: 'weathercan: Download and format weather data from Environment and Climate Change Canada'
tags:
  - R
  - data
  - weather
  - Canada
  - meteorology
authors:
  - name: Stefanie E. LaZerte
    orcid: 0000-0002-7690-8360
    affiliation: 1
  - name: Sam Albers
    orcid: 
    affiliation: 2
affiliations:
  - name: steffilazerte.ca
    index: 1
  - name: University of Northern British Columbia
    index: 2
date: 2017-11-24
bibliography: paper.bib
---

# Summary

Environment and Climate Change Canada maintains an online source of historical Canadian weather data in hourly, daily and monthly formats for various stations across Canada [@canada_historical_2011]. This data is freely available and can be accessed directly from their website. However, downloading data from multiple stations and across larger time periods can take significant time and effort. Further, these downloads require processing before they can be used for analysis. `weathercan` [@lazerte_weathercan_2018] is an R [@r_stats] package that automates and simplifies the downloading and formating of this data.

The first step in using `weathercan` is to identify the `station_id`(s) of the weather station(s) of interest. Stations can be searched for either by name (e.g., `stations_search("Brandon")`) or proximity to a given location (e.g., `stations_search(coords = c(49.84847, -99.95009))`). Searches can be conducted on all possible stations, or filtered to include only those recording weather at the desired time interval:

``` {.r}
library(weathercan)
stations_search("Brandon", interval = "hour")
```

    ## # A tibble: 3 x 12
    ##   prov   station_name station_id clima… WMO_id TC_id   lat    lon  elev inte… start   end
    ##   <fctr> <chr>        <fctr>     <fctr> <fctr> <fct> <dbl>  <dbl> <dbl> <chr> <int> <int>
    ## 1 MB     BRANDON A    3471       50104… 71140  YBR    49.9 -100.0   409 hour   1958  2012
    ## 2 MB     BRANDON A    50821      50104… 71140  YBR    49.9 -100.0   409 hour   2012  2018
    ## 3 MB     BRANDON RCS  49909      50104… 71136  PBO    49.9 -100.0   409 hour   2012  2018

Next, weather data can be downloaded for the specified stations (`station_ids`), time range (`start` through to `end`) and time interval (`interval`). Data downloaded from multiple stations and over several months are automatically combined into one data frame ready for analysis or plotting (Figure 1).

``` {.r}
w <- weather_dl(station_ids = c(50821, 51097), 
                start = "2017-01-01", end = "2017-09-01",
                interval = "hour")
names(w)
```

    ##  [1] "station_name"    "station_id"      "prov"            "lat"            
    ##  [5] "lon"             "elev"            "climate_id"      "WMO_id"         
    ##  [9] "TC_id"           "date"            "time"            "year"           
    ## [13] "month"           "day"             "hour"            "qual"           
    ## [17] "weather"         "hmdx"            "hmdx_flag"       "pressure"       
    ## [21] "pressure_flag"   "rel_hum"         "rel_hum_flag"    "temp"           
    ## [25] "temp_dew"        "temp_dew_flag"   "temp_flag"       "visib"          
    ## [29] "visib_flag"      "wind_chill"      "wind_chill_flag" "wind_dir"       
    ## [33] "wind_dir_flag"   "wind_spd"        "wind_spd_flag"

``` {.r}
w
```

    ## # A tibble: 11,712 x 35
    ##    stati… stat… prov    lat    lon  elev clim… WMO_… TC_id date       time               
    ##  * <chr>  <dbl> <fct> <dbl>  <dbl> <dbl> <chr> <chr> <chr> <date>     <dttm>             
    ##  1 BRAND… 50821 MB     49.9 -100.0   409 5010… 71140 YBR   2017-01-01 2017-01-01 00:00:00
    ##  2 BRAND… 50821 MB     49.9 -100.0   409 5010… 71140 YBR   2017-01-01 2017-01-01 01:00:00
    ##  3 BRAND… 50821 MB     49.9 -100.0   409 5010… 71140 YBR   2017-01-01 2017-01-01 02:00:00
    ##  4 BRAND… 50821 MB     49.9 -100.0   409 5010… 71140 YBR   2017-01-01 2017-01-01 03:00:00
    ##  5 BRAND… 50821 MB     49.9 -100.0   409 5010… 71140 YBR   2017-01-01 2017-01-01 04:00:00
    ##  6 BRAND… 50821 MB     49.9 -100.0   409 5010… 71140 YBR   2017-01-01 2017-01-01 05:00:00
    ##  7 BRAND… 50821 MB     49.9 -100.0   409 5010… 71140 YBR   2017-01-01 2017-01-01 06:00:00
    ##  8 BRAND… 50821 MB     49.9 -100.0   409 5010… 71140 YBR   2017-01-01 2017-01-01 07:00:00
    ##  9 BRAND… 50821 MB     49.9 -100.0   409 5010… 71140 YBR   2017-01-01 2017-01-01 08:00:00
    ## 10 BRAND… 50821 MB     49.9 -100.0   409 5010… 71140 YBR   2017-01-01 2017-01-01 09:00:00
    ## # ... with 11,702 more rows, and 24 more variables

![](paper_files/figure-markdown/unnamed-chunk-4-1.png)
Figure 1. Data downloaded with `weathercan` is formated and ready for ploting.

Finally, weather data from a single station can be aligned and merged with existing datasets through linear interpolation. For example, we first download weather data from a single station in Winnipeg, Canada:

``` {.r}
winnipeg <- weather_dl(station_ids = 51097, 
                       start = "2017-01-01", end = "2017-09-30",
                       interval = "hour")
```

The temperature data is recorded on the hour:

``` {.r}
winnipeg %>%
  select(time, temp)
```

    ## # A tibble: 6,552 x 2
    ##    time                  temp
    ##  * <dttm>               <dbl>
    ##  1 2017-01-01 00:00:00 - 7.80
    ##  2 2017-01-01 01:00:00 -10.0 
    ##  3 2017-01-01 02:00:00 -10.8 
    ##  4 2017-01-01 03:00:00 -10.5 
    ##  5 2017-01-01 04:00:00 -10.9 
    ##  6 2017-01-01 05:00:00 -11.2 
    ##  7 2017-01-01 06:00:00 -10.5 
    ##  8 2017-01-01 07:00:00 -11.0 
    ##  9 2017-01-01 08:00:00 -11.4 
    ## 10 2017-01-01 09:00:00 -11.1 
    ## # ... with 6,542 more rows

Then we open a dummy dataset containing mock sediment data:

``` {.r}
sediment <- read.csv("sediment.csv") %>%
  mutate(time = as.POSIXct(time, tz = "America/Winnipeg"))
```

This data is recorded every half hour, but at 5 min 34 seconds after:

``` {.r}
head(sediment)
```

    ##                  time   amount
    ## 1 2017-01-01 00:05:34 168.3133
    ## 2 2017-01-01 00:35:34 156.9122
    ## 3 2017-01-01 01:05:34 175.6169
    ## 4 2017-01-01 01:35:34 184.5908
    ## 5 2017-01-01 02:05:34 163.2017
    ## 6 2017-01-01 02:35:34 169.2177

Finally, we use the `weather_interp()` function to interpolate the temperature data and add it to the sediment data set:

``` {.r}
sediment <- weather_interp(data = sediment, 
                           weather = winnipeg, 
                           cols = "temp")
```

    ## temp is missing 2 out of 6552 data, interpolation may be less accurate as a result.

``` {.r}
head(sediment)
```

    ## # A tibble: 6 x 3
    ##   time                amount   temp
    ##   <dttm>               <dbl>  <dbl>
    ## 1 2017-01-01 00:05:34    168 - 8.00
    ## 2 2017-01-01 00:35:34    157 - 9.10
    ## 3 2017-01-01 01:05:34    176 -10.1 
    ## 4 2017-01-01 01:35:34    185 -10.5 
    ## 5 2017-01-01 02:05:34    163 -10.8 
    ## 6 2017-01-01 02:35:34    169 -10.6

# Installation

`weathercan` is available from [GitHub](https://github.com/ropensci/weathercan) and can be installed in R using the `devtools` package:

``` {.r}
devtools::install_github("ropensci/weathercan")
```

# References
