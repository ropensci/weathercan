# Climate Normals

## Downloading Climate Normals

Climate Normals and Averages describe the average climate conditions
specific to a particular location. These can be downloaded from
Environment and Climate Change Canada using the
[`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
function.

First we’ll load the `weathercan` package for downloading the data and
the `tidyr` package for unnesting the data (see below).

``` r

library(weathercan)
library(tidyr)
library(dplyr)
library(naniar) # For exploring missing values
```

### Downloading current normals (1991-2020)

To download climate normals, we’ll first find the stations we’re
interested in using the
[`stations_search()`](https://docs.ropensci.org/weathercan/reference/stations_search.md)
function. We’ll use the `normals_years = "current"` argument to filter
to only stations with the most recent available climate normals,
`1991-2020`.

``` r

stations_search("Winnipeg", normals_years = "current")
```

    ## The most current normals available for download by weathercan are '1991-2020'

    ## # A tibble: 10 × 17
    ##    prov  station_name  station_id climate_id WMO_id TC_id   lat   lon  elev tz    interval
    ##    <chr> <chr>              <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr> <chr>   
    ##  1 MB    WINNIPEG A CS      27174 502S001     71849 XWG    49.9 -97.2  239. Etc/… day     
    ##  2 MB    WINNIPEG A CS      27174 502S001     71849 XWG    49.9 -97.2  239. Etc/… hour    
    ##  3 MB    WINNIPEG A CS      27174 502S001     71849 XWG    49.9 -97.2  239. Etc/… month   
    ##  4 MB    WINNIPEG INT…      51097 5023227        NA YWG    49.9 -97.2  239. Etc/… day     
    ##  5 MB    WINNIPEG INT…      51097 5023227        NA YWG    49.9 -97.2  239. Etc/… hour    
    ##  6 MB    WINNIPEG RIC…      47407 5023226     71852 YWG    49.9 -97.2  239. Etc/… day     
    ##  7 MB    WINNIPEG RIC…      47407 5023226     71852 YWG    49.9 -97.2  239. Etc/… hour    
    ##  8 MB    WINNIPEG RIC…       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/… day     
    ##  9 MB    WINNIPEG RIC…       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/… hour    
    ## 10 MB    WINNIPEG RIC…       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/… month

Let’s look at the climate normals from one of these stations in
Winnipeg, MB. Note that unlike the
[`weather_dl()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md)
function, the
[`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
function requires `climate_id`, not `station_id`.

In contrast to previous climate normals the most recent normals are
provided as a single download from ECCC which is stored in a local data
cache, and then referenced by
[`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md).

If you haven’t already created a cache folder, weathercan will prompt
you to do so. Otherwise
[`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
will load, format and filter the cached data to the climate ids
specified.

``` r

n <- normals_dl(climate_ids = "5023222")
```

    ## The most current normals available for download by weathercan are '1991-2020'

    ## Using composite locations: WINNIPEG RICHARDSON (AIRPORT)

``` r

n
```

    ## # A tibble: 325 × 314
    ##    location_name            prov  composite_stations period_of_record element_group period
    ##    <chr>                    <chr> <chr>              <chr>            <chr>         <chr> 
    ##  1 WINNIPEG RICHARDSON (AI… MB    WINNIPEG A CS (50… Normal           Temperature   Jan   
    ##  2 WINNIPEG RICHARDSON (AI… MB    WINNIPEG A CS (50… Normal           Temperature   Feb   
    ##  3 WINNIPEG RICHARDSON (AI… MB    WINNIPEG A CS (50… Normal           Temperature   Mar   
    ##  4 WINNIPEG RICHARDSON (AI… MB    WINNIPEG A CS (50… Normal           Temperature   Apr   
    ##  5 WINNIPEG RICHARDSON (AI… MB    WINNIPEG A CS (50… Normal           Temperature   May   
    ##  6 WINNIPEG RICHARDSON (AI… MB    WINNIPEG A CS (50… Normal           Temperature   Jun   
    ##  7 WINNIPEG RICHARDSON (AI… MB    WINNIPEG A CS (50… Normal           Temperature   Jul   
    ##  8 WINNIPEG RICHARDSON (AI… MB    WINNIPEG A CS (50… Normal           Temperature   Aug   
    ##  9 WINNIPEG RICHARDSON (AI… MB    WINNIPEG A CS (50… Normal           Temperature   Sep   
    ## 10 WINNIPEG RICHARDSON (AI… MB    WINNIPEG A CS (50… Normal           Temperature   Oct   
    ## # ℹ 315 more rows

The more recent climate normals actually reflect composite stations.
Stations included are stored in the `composite_stations` column.

``` r

n$composite_stations[1]
```

    ## [1] "WINNIPEG A CS (502S001); WINNIPEG INTL A (5023227); WINNIPEG RICHARDSON AWOS (5023226); WINNIPEG RICHARDSON INT'L A (5023222)"

So we can see that these climate normals are actually composed of
several different stations mostly from the Airport.

Once you have used
[`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
and have downloaded and cached the normals data, you can also access the
original, cached, data from ECCC.

``` r

library(readr)
normals_file() # Location of the cached data (if you've downloaded it!)
```

    ## [1] "~/.local/share/weathercan/1991-2020_Canadian_Climate_Normals_CANADA_Data.csv"

``` r

n_orig <- read_csv(normals_file())
```

    ## Rows: 69068 Columns: 19
    ## ── Column specification ──────────────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (19): LOCATION_NAME, PROVINCE_OR_TERRITORY, PERIOD_OF_RECORD, ELEMENT_GROUP, NORMA...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r

n_orig
```

    ## # A tibble: 69,068 × 19
    ##    LOCATION_NAME PROVINCE_OR_TERRITORY PERIOD_OF_RECORD ELEMENT_GROUP NORMALS_ELEMENT     
    ##    <chr>         <chr>                 <chr>            <chr>         <chr>               
    ##  1 BANFF         AB                    Normal           Temperature   Daily Average (°C)  
    ##  2 BANFF         AB                    Normal           Temperature   StdDev Mean Monthly…
    ##  3 BANFF         AB                    Normal           Temperature   Daily Maximum (°C)  
    ##  4 BANFF         AB                    Normal           Temperature   Daily Minimum (°C)  
    ##  5 BANFF         AB                    Normal           Temperature   Maximum Daily Mean …
    ##  6 BANFF         AB                    Normal           Temperature   Maximum Daily Mean …
    ##  7 BANFF         AB                    Normal           Temperature   Minimum Daily Mean …
    ##  8 BANFF         AB                    Normal           Temperature   Minimum Daily Mean …
    ##  9 BANFF         AB                    Normal           Temperature   Extreme Maximum (°C)
    ## 10 BANFF         AB                    Normal           Temperature   Extreme Maximum (°C…
    ## # ℹ 69,058 more rows

### Downloading previous normals (1981-2010 and 1971-2000)

Similar to current normals, we first find the stations and then download
the normals. The main difference is specifying that we want older
normals, and then dealing with the different format these normals come
in.

``` r

stations_search("Winnipeg", normals_years = "1981-2010")
```

    ## # A tibble: 3 × 17
    ##   prov  station_name   station_id climate_id WMO_id TC_id   lat   lon  elev tz    interval
    ##   <chr> <chr>               <dbl> <chr>       <dbl> <chr> <dbl> <dbl> <dbl> <chr> <chr>   
    ## 1 MB    WINNIPEG RICH…       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/… day     
    ## 2 MB    WINNIPEG RICH…       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/… hour    
    ## 3 MB    WINNIPEG RICH…       3698 5023222     71852 YWG    49.9 -97.2  239. Etc/… month

``` r

n <- normals_dl(climate_ids = "5023222", normals_years = "1981-2010")
n
```

    ## # A tibble: 1 × 7
    ##   prov  station_name                climate_id normals_years meets_wmo normals  frost   
    ##   <chr> <chr>                       <chr>      <chr>         <lgl>     <list>   <list>  
    ## 1 MB    WINNIPEG RICHARDSON INT'L A 5023222    1981-2010     TRUE      <tibble> <tibble>

In older climate normals, there are two different data formats (one for
weather measurements and one for first/last frost dates). Therefore, the
data are nested as two different datasets. We can see that the Airport
(Richardson Int’l) has 197 average weather measurements/codes as well as
first/last frost dates.

Note that these older normals do not use composite stations.

We can also see that this station has data quality sufficient to meet
the WMO standards for temperature and precipitation (i.e. both these
measurements have code \>= A). See the [ECCC calculations
document](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1981_2010_Calculation_Information.pdf)
for more details.

To extract either data set we can use the
[`unnest()`](https://tidyr.tidyverse.org/reference/unnest.html) function
from the `tidyr` package.

``` r

normals <- unnest(n, normals)
frost <- unnest(n, frost)
```

Note that this extracts the measurements for all three stations (in the
case of the `normals` data frame), but not all measurements are
available for each station

``` r

normals
```

    ## # A tibble: 13 × 203
    ##    prov  station_name         climate_id normals_years meets_wmo period temp_daily_average
    ##    <chr> <chr>                <chr>      <chr>         <lgl>     <fct>               <dbl>
    ##  1 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Jan                 -16.4
    ##  2 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Feb                 -13.2
    ##  3 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Mar                  -5.8
    ##  4 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Apr                   4.4
    ##  5 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      May                  11.6
    ##  6 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Jun                  17  
    ##  7 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Jul                  19.7
    ##  8 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Aug                  18.8
    ##  9 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Sep                  12.7
    ## 10 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Oct                   5  
    ## 11 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Nov                  -4.9
    ## 12 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Dec                 -13.2
    ## 13 MB    WINNIPEG RICHARDSON… 5023222    1981-2010     TRUE      Year                  3

Let’s take a look at the frost data.

``` r

frost
```

    ## # A tibble: 7 × 14
    ##   prov  station_name                climate_id normals_years meets_wmo normals  frost_code
    ##   <chr> <chr>                       <chr>      <chr>         <lgl>     <list>   <chr>     
    ## 1 MB    WINNIPEG RICHARDSON INT'L A 5023222    1981-2010     TRUE      <tibble> A         
    ## 2 MB    WINNIPEG RICHARDSON INT'L A 5023222    1981-2010     TRUE      <tibble> A         
    ## 3 MB    WINNIPEG RICHARDSON INT'L A 5023222    1981-2010     TRUE      <tibble> A         
    ## 4 MB    WINNIPEG RICHARDSON INT'L A 5023222    1981-2010     TRUE      <tibble> A         
    ## 5 MB    WINNIPEG RICHARDSON INT'L A 5023222    1981-2010     TRUE      <tibble> A         
    ## 6 MB    WINNIPEG RICHARDSON INT'L A 5023222    1981-2010     TRUE      <tibble> A         
    ## 7 MB    WINNIPEG RICHARDSON INT'L A 5023222    1981-2010     TRUE      <tibble> A

## Finding stations with specific measurements

The included data frame, `normals_measurements` contains a list of
stations with their corresponding measurements. Be aware that this data
might be out of date!

``` r

normals_measurements
```

    ## # A tibble: 376,959 × 6
    ##    prov  station_name climate_id                normals   measurement_type measurement    
    ##    <chr> <chr>        <chr>                     <chr>     <chr>            <chr>          
    ##  1 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      daily_average_c
    ##  2 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      stddev_mean_mo…
    ##  3 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      daily_maximum_c
    ##  4 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      daily_minimum_c
    ##  5 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      maximum_daily_…
    ##  6 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      maximum_daily_…
    ##  7 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      minimum_daily_…
    ##  8 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      minimum_daily_…
    ##  9 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      extreme_maximu…
    ## 10 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      extreme_maximu…
    ## # ℹ 376,949 more rows

Because the new climate normals are so different from previous years,
they include different `measurements` which are organized by
`measurement_type`. In older normals years, `measurement_type` is `NA`.

For example, if you wanted all `climate_id`s for stations that have data
on temperature for 1991-2020 normals:

``` r

library(stringr) # text pattern matching

# Have a quick look
normals_measurements |>
  filter(str_detect(measurement_type, "Temp"), normals == "1991-2020")
```

    ## # A tibble: 21,528 × 6
    ##    prov  station_name climate_id                normals   measurement_type measurement    
    ##    <chr> <chr>        <chr>                     <chr>     <chr>            <chr>          
    ##  1 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      daily_average_c
    ##  2 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      stddev_mean_mo…
    ##  3 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      daily_maximum_c
    ##  4 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      daily_minimum_c
    ##  5 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      maximum_daily_…
    ##  6 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      maximum_daily_…
    ##  7 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      minimum_daily_…
    ##  8 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      minimum_daily_…
    ##  9 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      extreme_maximu…
    ## 10 AB    BANFF        3050520, 3050521, 3050519 1991-2020 Temperature      extreme_maximu…
    ## # ℹ 21,518 more rows

``` r

ids <- normals_measurements |>
  filter(str_detect(measurement_type, "Temp"), normals == "1991-2020") |>
  pull(climate_id) |>
  unique()
```

Alternatively, if you wanted all `climate_id`s for stations that have
data on soil temperature for 1981-2010 normals (which is no longer
available in the 1991-2020 normals):

``` r

# Have a quick look
normals_measurements |>
  filter(stringr::str_detect(measurement, "soil"), normals == "1981-2010")
```

    ## # A tibble: 314 × 6
    ##    prov  station_name    climate_id normals   measurement_type measurement          
    ##    <chr> <chr>           <chr>      <chr>     <chr>            <chr>                
    ##  1 AB    BEAVERLODGE CDA 3070560    1981-2010 <NA>             soil_temp_am_5       
    ##  2 AB    BEAVERLODGE CDA 3070560    1981-2010 <NA>             soil_temp_am_5_code  
    ##  3 AB    BEAVERLODGE CDA 3070560    1981-2010 <NA>             soil_temp_am_10      
    ##  4 AB    BEAVERLODGE CDA 3070560    1981-2010 <NA>             soil_temp_am_10_code 
    ##  5 AB    BEAVERLODGE CDA 3070560    1981-2010 <NA>             soil_temp_am_20      
    ##  6 AB    BEAVERLODGE CDA 3070560    1981-2010 <NA>             soil_temp_am_20_code 
    ##  7 AB    BEAVERLODGE CDA 3070560    1981-2010 <NA>             soil_temp_am_50      
    ##  8 AB    BEAVERLODGE CDA 3070560    1981-2010 <NA>             soil_temp_am_50_code 
    ##  9 AB    BEAVERLODGE CDA 3070560    1981-2010 <NA>             soil_temp_am_100     
    ## 10 AB    BEAVERLODGE CDA 3070560    1981-2010 <NA>             soil_temp_am_100_code
    ## # ℹ 304 more rows

``` r

ids <- normals_measurements |>
  filter(stringr::str_detect(measurement, "soil"), normals == "1981-2010") |>
  pull(climate_id) |>
  unique()
```

## Understanding Climate Normals

The measurements contained in the climate normals are very specific. To
better understand how they are calculated please explore the following
resources:

- ECCC Climate Normals Calculations
  ([1991-2020](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1991_2020_Calculation_Information.pdf)
  \|
  ([1981-2010](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1981_2010_Calculation_Information.pdf)
  \|
  [1971-2000](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1971_2000_Calculation_Information.pdf))
  - [`weathercan` Climate Normals
    Codes](https://docs.ropensci.org/weathercan/articles/flags.md)
- [ECCC Climate Normals Technical
  Documentation](https://www.canada.ca/en/environment-climate-change/services/climate-change/canadian-centre-climate-services/display-download/technical-documentation-climate-normals.html)
  - [`weathercan` Climate Normals Terms and
    Units](https://docs.ropensci.org/weathercan/articles/glossary_normals.md)
