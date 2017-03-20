README
================
Steffi LaZerte

    ## Loading tidyverse: ggplot2
    ## Loading tidyverse: tibble
    ## Loading tidyverse: tidyr
    ## Loading tidyverse: readr
    ## Loading tidyverse: purrr
    ## Loading tidyverse: dplyr

    ## Conflicts with tidy packages ----------------------------------------------

    ## filter(): dplyr, stats
    ## lag():    dplyr, stats

[![Build Status](https://travis-ci.org/steffilazerte/envirocan.svg?branch=master)](https://travis-ci.org/steffilazerte/envirocan) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/steffilazerte/envirocan?branch=master&svg=true)](https://ci.appveyor.com/project/steffilazerte/envirocan)

envirocan
=========

This package is makes it easier to search for and download multiple months/years of historical weather data from Environment Canada website.

Bear in mind that these downloads can be fairly large and performing multiple, downloads may use up Environment Canada's bandwidth unecessarily. Try to stick to what you need.

Installation
------------

Use the `devtools` package to directly install R packages from github:

``` r
install.packages("devtools") # If not already installed
devtools::install_github("steffilazerte/envirocan", ref = "v0.2.2") 
## For most recent release; Otherwise omit "ref = " to download most recent version
## Also making use of the tidyverse for data manipulations
library(tidyverse)
```

Basic usage:
------------

To download data, you first need to know the `station_id` associated with the station you're interested in.

### Stations

`envirocan` includes a data frame called `stations` which includes a list of stations and their details (including `station_id`.

``` r
head(stations)
```

    ##   prov           station_name station_id climate_id WMO_id TC_id   lat
    ## 1   BC            ACTIVE PASS         14    1010066   <NA>  <NA> 48.87
    ## 2   BC            ALBERT HEAD         15    1010235   <NA>  <NA> 48.40
    ## 3   BC BAMBERTON OCEAN CEMENT         16    1010595   <NA>  <NA> 48.58
    ## 4   BC             BEAR CREEK         17    1010720   <NA>  <NA> 48.50
    ## 5   BC            BEAVER LAKE         18    1010774   <NA>  <NA> 48.50
    ## 6   BC             BECHER BAY         19    1010780   <NA>  <NA> 48.33
    ##       lon  elev interval start end
    ## 1 -123.28   4.0     hour    NA  NA
    ## 2 -123.48  17.0     hour    NA  NA
    ## 3 -123.52  85.3     hour    NA  NA
    ## 4 -124.00 350.5     hour    NA  NA
    ## 5 -123.35  61.0     hour    NA  NA
    ## 6 -123.63  12.2     hour    NA  NA

You can look through this data frame directly, or you can use the `stations_search` function:

``` r
stations_search("Kamloops", interval = "hour")
```

    ##   prov station_name station_id climate_id WMO_id TC_id  lat     lon  elev
    ## 1   BC   KAMLOOPS A       1275    1163780  71887   YKA 50.7 -120.44 345.3
    ## 2   BC   KAMLOOPS A      51423    1163781  71887   YKA 50.7 -120.45 345.3
    ## 3   BC KAMLOOPS AUT      42203    1163842  71741   ZKA 50.7 -120.44 345.0
    ##   interval start  end
    ## 1     hour  1953 2013
    ## 2     hour  2013 2017
    ## 3     hour  2006 2017

Time frame must be one of "hour", "day", or "month".

You can also search by proximity:

``` r
stations_search(coords = c(50.667492, -120.329049), dist = 20, interval = "hour")
```

    ##   prov station_name station_id climate_id WMO_id TC_id  lat     lon  elev
    ## 1   BC   KAMLOOPS A       1275    1163780  71887   YKA 50.7 -120.44 345.3
    ## 2   BC KAMLOOPS AUT      42203    1163842  71741   ZKA 50.7 -120.44 345.0
    ## 3   BC   KAMLOOPS A      51423    1163781  71887   YKA 50.7 -120.45 345.3
    ##   interval start  end distance
    ## 1     hour  1953 2013 8.635022
    ## 2     hour  2006 2017 8.635022
    ## 3     hour  2013 2017 9.281516

We can also perform more complex searches using `tidyverse` tools and use the resulting vector:

``` r
BCstations <- stations %>%
  filter(prov %in% c("BC")) %>%
  filter(interval == "hour") %>%
  filter(lat > 49 & lat < 49.5) %>%
  filter(lon > -119 & lon < -116) %>%
  filter(start<=2002) %>%
  filter(end>=2016)

## weather() accepts numbers so we can create a vector to input into weather:
stn_vector <- BCstations$station_id 
```

### Weather

Once you have your `station_id`(s) you can download weather data:

``` r
kam <- weather(station_ids = 51423, start = "2016-01-01", end = "2016-02-15")
                    
head(kam)
```

    ##   station_name station_id prov  lat     lon       date                time
    ## 1   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 00:00:00
    ## 2   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 01:00:00
    ## 3   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 02:00:00
    ## 4   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 03:00:00
    ## 5   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 04:00:00
    ## 6   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 05:00:00
    ##   year month day  hour qual       weather hmdx hmdx_flag pressure
    ## 1 2016    01  01 00:00              <NA>   NA              99.95
    ## 2 2016    01  01 01:00     Mostly Cloudy   NA              99.93
    ## 3 2016    01  01 02:00              <NA>   NA              99.92
    ## 4 2016    01  01 03:00              <NA>   NA              99.90
    ## 5 2016    01  01 04:00            Cloudy   NA              99.86
    ## 6 2016    01  01 05:00              <NA>   NA              99.82
    ##   pressure_flag rel_hum rel_hum_flag temp temp_dew temp_dew_flag temp_flag
    ## 1                    74              -9.1    -12.9                        
    ## 2                    76              -9.6    -13.1                        
    ## 3                    74              -9.9    -13.7                        
    ## 4                    73              -9.5    -13.5                        
    ## 5                    70              -9.4    -13.9                        
    ## 6                    71              -9.8    -14.1                        
    ##   visib visib_flag wind_chill wind_chill_flag wind_dir wind_dir_flag
    ## 1  64.4                   -17                       13              
    ## 2  64.4                   -17                       11              
    ## 3  64.4                   -18                       11              
    ## 4  64.4                   -17                       11              
    ## 5  64.4                   -17                       11              
    ## 6  64.4                   -17                       10              
    ##   wind_spd wind_spd_flag  elev climat_id WMO_id TC_id
    ## 1       19               345.3   1163781  71887   YKA
    ## 2       20               345.3   1163781  71887   YKA
    ## 3       20               345.3   1163781  71887   YKA
    ## 4       18               345.3   1163781  71887   YKA
    ## 5       18               345.3   1163781  71887   YKA
    ## 6       16               345.3   1163781  71887   YKA

You can also download data from multiple stations at once:

``` r
kam.pg <- weather(station_ids = c(48248, 51423), start = "2016-01-01", end = "2016-02-15")
                    
head(kam.pg)
```

    ##                 station_name station_id prov   lat     lon       date
    ## 1 PRINCE GEORGE AIRPORT AUTO      48248   BC 53.89 -122.67 2016-01-01
    ## 2 PRINCE GEORGE AIRPORT AUTO      48248   BC 53.89 -122.67 2016-01-01
    ## 3 PRINCE GEORGE AIRPORT AUTO      48248   BC 53.89 -122.67 2016-01-01
    ## 4 PRINCE GEORGE AIRPORT AUTO      48248   BC 53.89 -122.67 2016-01-01
    ## 5 PRINCE GEORGE AIRPORT AUTO      48248   BC 53.89 -122.67 2016-01-01
    ## 6 PRINCE GEORGE AIRPORT AUTO      48248   BC 53.89 -122.67 2016-01-01
    ##                  time year month day  hour qual weather hmdx hmdx_flag
    ## 1 2016-01-01 00:00:00 2016    01  01 00:00         <NA>   NA          
    ## 2 2016-01-01 01:00:00 2016    01  01 01:00         <NA>   NA          
    ## 3 2016-01-01 02:00:00 2016    01  01 02:00         <NA>   NA          
    ## 4 2016-01-01 03:00:00 2016    01  01 03:00         <NA>   NA          
    ## 5 2016-01-01 04:00:00 2016    01  01 04:00         <NA>   NA          
    ## 6 2016-01-01 05:00:00 2016    01  01 05:00         <NA>   NA          
    ##   pressure pressure_flag rel_hum rel_hum_flag  temp temp_dew temp_dew_flag
    ## 1    95.26                    79              -21.2    -23.9              
    ## 2    95.23                    81              -21.4    -23.8              
    ## 3    95.22                    79              -22.8    -25.5              
    ## 4    95.22                    79              -23.1    -25.8              
    ## 5    95.17                    79              -22.9    -25.6              
    ## 6    95.14                    78              -24.2    -26.9              
    ##   temp_flag visib visib_flag wind_chill wind_chill_flag wind_dir
    ## 1              NA                   -24                       35
    ## 2              NA                   -23                        3
    ## 3              NA                   -25                       33
    ## 4              NA                   -24                        0
    ## 5              NA                   -24                       32
    ## 6              NA                   -27                       34
    ##   wind_dir_flag wind_spd wind_spd_flag elev climat_id WMO_id TC_id
    ## 1                      3                680   1096453  71302   VXS
    ## 2                      2                680   1096453  71302   VXS
    ## 3                      2                680   1096453  71302   VXS
    ## 4                      1                680   1096453  71302   VXS
    ## 5                      1                680   1096453  71302   VXS
    ## 6                      3                680   1096453  71302   VXS

And plot it:

``` r
library(ggplot2)

ggplot(data = kam.pg, aes(x = time, y = temp, group = station_name, colour = station_name)) +
  theme(legend.position = "top") +
  geom_line()
```

![](README_files/figure-markdown_github/unnamed-chunk-8-1.png)

Or you can use the vector created above:

``` r
stn_vec_df <- weather(station_ids = stn_vector, start = "2016-01-01", end = "2016-02-15")

head(stn_vec_df)
```

    ##   station_name station_id prov   lat     lon       date
    ## 1    NELSON CS       6839   BC 49.49 -117.31 2016-01-01
    ## 2    NELSON CS       6839   BC 49.49 -117.31 2016-01-01
    ## 3    NELSON CS       6839   BC 49.49 -117.31 2016-01-01
    ## 4    NELSON CS       6839   BC 49.49 -117.31 2016-01-01
    ## 5    NELSON CS       6839   BC 49.49 -117.31 2016-01-01
    ## 6    NELSON CS       6839   BC 49.49 -117.31 2016-01-01
    ##                  time year month day  hour qual weather hmdx hmdx_flag
    ## 1 2016-01-01 00:00:00 2016    01  01 00:00         <NA>   NA          
    ## 2 2016-01-01 01:00:00 2016    01  01 01:00         <NA>   NA          
    ## 3 2016-01-01 02:00:00 2016    01  01 02:00         <NA>   NA          
    ## 4 2016-01-01 03:00:00 2016    01  01 03:00         <NA>   NA          
    ## 5 2016-01-01 04:00:00 2016    01  01 04:00         <NA>   NA          
    ## 6 2016-01-01 05:00:00 2016    01  01 05:00         <NA>   NA          
    ##   pressure pressure_flag rel_hum rel_hum_flag temp temp_dew temp_dew_flag
    ## 1    97.62                    69              -6.2    -10.9              
    ## 2    97.60                    68              -6.2    -11.1              
    ## 3    97.58                    71              -6.3    -10.7              
    ## 4    97.58                    70              -6.0    -10.5              
    ## 5    97.53                    73              -6.3    -10.4              
    ## 6    97.48                    74              -6.4    -10.4              
    ##   temp_flag visib visib_flag wind_chill wind_chill_flag wind_dir
    ## 1              NA                    NA                       NA
    ## 2              NA                    NA                       NA
    ## 3              NA                    NA                       NA
    ## 4              NA                    NA                       NA
    ## 5              NA                    NA                       NA
    ## 6              NA                    NA                       NA
    ##   wind_dir_flag wind_spd wind_spd_flag  elev climat_id WMO_id TC_id
    ## 1                     NA             M 534.9   1145M29  71776   WNM
    ## 2                     NA             M 534.9   1145M29  71776   WNM
    ## 3                     NA             M 534.9   1145M29  71776   WNM
    ## 4                     NA             M 534.9   1145M29  71776   WNM
    ## 5                     NA             M 534.9   1145M29  71776   WNM
    ## 6                     NA             M 534.9   1145M29  71776   WNM

### Interpolate and add data

You can merge weather data with other data frames by linearly interprolating between points.

For example, using the included datasets:

``` r
head(kamloops)
```

    ##   station_name station_id prov  lat     lon       date                time
    ## 1   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 00:00:00
    ## 2   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 01:00:00
    ## 3   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 02:00:00
    ## 4   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 03:00:00
    ## 5   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 04:00:00
    ## 6   KAMLOOPS A      51423   BC 50.7 -120.45 2016-01-01 2016-01-01 05:00:00
    ##   year month day  hour
    ## 1 2016    01  01 00:00
    ## 2 2016    01  01 01:00
    ## 3 2016    01  01 02:00
    ## 4 2016    01  01 03:00
    ## 5 2016    01  01 04:00
    ## 6 2016    01  01 05:00
    ##                                                                          qual
    ## 1 Partner data that is not subject to review by the National Climate Archives
    ## 2 Partner data that is not subject to review by the National Climate Archives
    ## 3 Partner data that is not subject to review by the National Climate Archives
    ## 4 Partner data that is not subject to review by the National Climate Archives
    ## 5 Partner data that is not subject to review by the National Climate Archives
    ## 6 Partner data that is not subject to review by the National Climate Archives
    ##         weather hmdx hmdx_flag pressure pressure_flag rel_hum rel_hum_flag
    ## 1          <NA>   NA              99.95                    74             
    ## 2 Mostly Cloudy   NA              99.93                    76             
    ## 3          <NA>   NA              99.92                    74             
    ## 4          <NA>   NA              99.90                    73             
    ## 5        Cloudy   NA              99.86                    70             
    ## 6          <NA>   NA              99.82                    71             
    ##   temp temp_dew temp_dew_flag temp_flag visib visib_flag wind_chill
    ## 1 -9.1    -12.9                          64.4                   -17
    ## 2 -9.6    -13.1                          64.4                   -17
    ## 3 -9.9    -13.7                          64.4                   -18
    ## 4 -9.5    -13.5                          64.4                   -17
    ## 5 -9.4    -13.9                          64.4                   -17
    ## 6 -9.8    -14.1                          64.4                   -17
    ##   wind_chill_flag wind_dir wind_dir_flag wind_spd wind_spd_flag  elev
    ## 1                       13                     19               345.3
    ## 2                       11                     20               345.3
    ## 3                       11                     20               345.3
    ## 4                       11                     18               345.3
    ## 5                       11                     18               345.3
    ## 6                       10                     16               345.3
    ##   climat_id WMO_id TC_id
    ## 1   1163781  71887   YKA
    ## 2   1163781  71887   YKA
    ## 3   1163781  71887   YKA
    ## 4   1163781  71887   YKA
    ## 5   1163781  71887   YKA
    ## 6   1163781  71887   YKA

``` r
head(finches)
```

    ##      bird_id                time feeder_id     species       lon      lat
    ## 1 041868D861 2016-02-29 07:40:15      2200 House Finch -120.3612 50.66778
    ## 2 041868D861 2016-02-29 07:40:19      2200 House Finch -120.3612 50.66778
    ## 3 041868D861 2016-02-29 07:40:22      2200 House Finch -120.3612 50.66778
    ## 4 041868D861 2016-02-29 07:40:31      2200 House Finch -120.3612 50.66778
    ## 5 041868D861 2016-02-29 07:40:34      2200 House Finch -120.3612 50.66778
    ## 6 041868D861 2016-02-29 07:40:51      2200 House Finch -120.3612 50.66778

``` r
finches_temperature <- add_weather(data = finches, weather = kamloops, cols = "temp")
```

    ## temp is missing 4 out of 4368 data, interpolation may be less accurate as a result.

``` r
summary(finches_temperature)
```

    ##        bird_id          time                     feeder_id  
    ##  0620000513:7536   Min.   :2016-02-29 07:40:15   1500:6351  
    ##  041868D861:2593   1st Qu.:2016-03-05 10:43:39   2100:1037  
    ##  0620000514:1759   Median :2016-03-09 13:39:34   2200:2297  
    ##  06200004F8:1400   Mean   :2016-03-08 22:31:28   2300:3448  
    ##  041868BED6: 888   3rd Qu.:2016-03-12 14:57:16   2400:1434  
    ##  06200003BB: 719   Max.   :2016-03-15 17:52:39   2700:2028  
    ##  (Other)   :1700                                            
    ##    species               lon              lat             temp       
    ##  Length:16595       Min.   :-120.4   Min.   :50.67   Min.   :-1.763  
    ##  Class :character   1st Qu.:-120.4   1st Qu.:50.67   1st Qu.: 5.353  
    ##  Mode  :character   Median :-120.4   Median :50.67   Median : 9.076  
    ##                     Mean   :-120.4   Mean   :50.67   Mean   : 8.688  
    ##                     3rd Qu.:-120.4   3rd Qu.:50.67   3rd Qu.:11.963  
    ##                     Max.   :-120.4   Max.   :50.67   Max.   :16.353  
    ## 

``` r
head(finches_temperature)
```

    ##      bird_id                time feeder_id     species       lon      lat
    ## 1 041868D861 2016-02-29 07:40:15      2200 House Finch -120.3612 50.66778
    ## 2 041868D861 2016-02-29 07:40:19      2200 House Finch -120.3612 50.66778
    ## 3 041868D861 2016-02-29 07:40:22      2200 House Finch -120.3612 50.66778
    ## 4 041868D861 2016-02-29 07:40:31      2200 House Finch -120.3612 50.66778
    ## 5 041868D861 2016-02-29 07:40:34      2200 House Finch -120.3612 50.66778
    ## 6 041868D861 2016-02-29 07:40:51      2200 House Finch -120.3612 50.66778
    ##       temp
    ## 1 1.726667
    ## 2 1.724889
    ## 3 1.723556
    ## 4 1.719556
    ## 5 1.718222
    ## 6 1.710667

By default, gaps of 2 hours (or two days, with a daily scale) will be interpolated over, but longer gaps will be filled with NAs. You can adjust this behaviour with `na_gap`. Note that as environment canada data is downloaded on an hourly scale, it makes no sense to apply `na_gap` values of less than 1.

``` r
finches_temperature <- add_weather(data = finches, weather = kamloops, cols = "temp", na_gap = 1)
```

    ## temp is missing 4 out of 4368 data, interpolation may be less accurate as a result.

``` r
summary(finches_temperature)
```

    ##        bird_id          time                     feeder_id  
    ##  0620000513:7536   Min.   :2016-02-29 07:40:15   1500:6351  
    ##  041868D861:2593   1st Qu.:2016-03-05 10:43:39   2100:1037  
    ##  0620000514:1759   Median :2016-03-09 13:39:34   2200:2297  
    ##  06200004F8:1400   Mean   :2016-03-08 22:31:28   2300:3448  
    ##  041868BED6: 888   3rd Qu.:2016-03-12 14:57:16   2400:1434  
    ##  06200003BB: 719   Max.   :2016-03-15 17:52:39   2700:2028  
    ##  (Other)   :1700                                            
    ##    species               lon              lat             temp       
    ##  Length:16595       Min.   :-120.4   Min.   :50.67   Min.   :-1.763  
    ##  Class :character   1st Qu.:-120.4   1st Qu.:50.67   1st Qu.: 5.288  
    ##  Mode  :character   Median :-120.4   Median :50.67   Median : 9.078  
    ##                     Mean   :-120.4   Mean   :50.67   Mean   : 8.682  
    ##                     3rd Qu.:-120.4   3rd Qu.:50.67   3rd Qu.:11.972  
    ##                     Max.   :-120.4   Max.   :50.67   Max.   :16.353  
    ##                                                      NA's   :195

``` r
finches_temperature[is.na(finches_temperature$temp),][1:10,]
```

    ##         bird_id                time feeder_id     species       lon
    ## 7443 062000035D 2016-03-08 12:10:10      1500 House Finch -120.3658
    ## 7444 062000035D 2016-03-08 12:10:11      1500 House Finch -120.3658
    ## 7445 062000035D 2016-03-08 12:10:13      1500 House Finch -120.3658
    ## 7446 062000035D 2016-03-08 12:10:14      1500 House Finch -120.3658
    ## 7447 06200004F8 2016-03-08 12:12:26      1500 House Finch -120.3658
    ## 7448 06200004F8 2016-03-08 12:12:28      1500 House Finch -120.3658
    ## 7449 06200004F8 2016-03-08 12:12:29      1500 House Finch -120.3658
    ## 7450 06200004F8 2016-03-08 12:12:30      1500 House Finch -120.3658
    ## 7451 06200004F8 2016-03-08 12:12:32      1500 House Finch -120.3658
    ## 7452 06200004F8 2016-03-08 12:12:33      1500 House Finch -120.3658
    ##           lat temp
    ## 7443 50.67057   NA
    ## 7444 50.67057   NA
    ## 7445 50.67057   NA
    ## 7446 50.67057   NA
    ## 7447 50.67057   NA
    ## 7448 50.67057   NA
    ## 7449 50.67057   NA
    ## 7450 50.67057   NA
    ## 7451 50.67057   NA
    ## 7452 50.67057   NA

``` r
kamloops[is.na(kamloops$temp), c("time", "temp")]
```

    ##                     time temp
    ## 1004 2016-02-11 19:00:00   NA
    ## 1622 2016-03-08 13:00:00   NA
    ## 1682 2016-03-11 01:00:00   NA
    ## 2377 2016-04-09 00:00:00   NA
