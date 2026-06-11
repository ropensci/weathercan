# Flags and codes

## What are flags/codes

The data output of the
[`weather_dl()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md)
function include corresponding `_flag` columns for each data column.
These columns are used by ECCC to add notes regarding measurements.

Similarly, the data output of the
[`normals_dl()`](https://docs.ropensci.org/weathercan/reference/normals_dl.md)
function include corresponding `_code` columns. These columns are used
by ECCC to add notes regarding the amount of data used to calculate the
normals.

In the
[`weather_dl()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md)
function if `format = TRUE` (the default), data corresponding to flags
`M`, `NA`, and `[empty]` are all replaced with `NA` (if they are not
already `NA`).

### Flags - Weather Data

The flags index can be accessed through the built in data frame: `flags`

| code | meaning |
|:---|:---|
| A | Accumulated |
| B | More than one occurrence and estimated |
| C | Precipitation occurred, amount uncertain |
| D | Data subject to further quality control procedure |
| E | Estimated |
| F | Accumulated and estimated |
| L | Precipitation may or may not have occurred |
| M | Missing |
| N | Temperature missing but known to be \> 0 |
| S | More than one occurrence |
| T | Trace |
| Y | Temperature missing but known to be \< 0 |
| \[empty\] | Indicates an unobserved value |
| ^ | The value displayed is based on incomplete data |
| † | Data that is not subject to review by the National Climate Archives |
| NA | Not Available |

### Codes

In the `normals_dl`() function, codes are associated with each variable:

    ## As of weathercan v1.0.0 the default normals are 1991-2020. Note that these normals are in a different format from previous
    ## years. See ?normals_dl for more details or use `normals_years = '1981-2010'` to revert to the previous set of normals. This
    ## message is shown once per session
    ## 
    ## 
    ## The most current normals available for download by weathercan are '1991-2020'
    ## Using composite locations: BRANDON

    ## # A tibble: 26 × 35
    ##    period daily_average_c daily_average_c_code daily_maximum_c daily_maximum_c_code daily_minimum_c daily_minimum_c_code
    ##    <chr>            <dbl> <chr>                          <dbl> <chr>                          <dbl> <chr>               
    ##  1 Jan              -16.7 A                              -11.4 A                              -21.9 A                   
    ##  2 Feb              -14.1 A                               -8.5 A                              -19.7 A                   
    ##  3 Mar               -7   A                               -1.6 A                              -12.5 A                   
    ##  4 Apr                3.1 A                                9.6 A                               -3.3 A                   
    ##  5 May               10.3 A                               17.4 A                                3.2 A                   
    ##  6 Jun               16.2 A                               22.6 A                                9.7 A                   
    ##  7 Jul               18.4 A                               24.9 A                               11.8 A                   
    ##  8 Aug               17.7 A                               25.1 A                               10.2 A                   
    ##  9 Sep               12.2 A                               19.5 A                                4.9 A                   
    ## 10 Oct                4   A                               10.1 A                               -2.2 A                   
    ## # ℹ 16 more rows
    ## # ℹ 28 more variables: maximum_daily_mean_c <dbl>, maximum_daily_mean_c_code <lgl>, maximum_daily_mean_c_date <date>,
    ## #   maximum_daily_mean_c_date_code <lgl>, minimum_daily_mean_c <dbl>, minimum_daily_mean_c_code <lgl>,
    ## #   minimum_daily_mean_c_date <date>, minimum_daily_mean_c_date_code <lgl>, minimum_daily_maximum_c <dbl>,
    ## #   minimum_daily_maximum_c_code <lgl>, minimum_daily_maximum_c_date <date>, minimum_daily_maximum_c_date_code <lgl>,
    ## #   maximum_daily_minimum_c <dbl>, maximum_daily_minimum_c_code <lgl>, maximum_daily_minimum_c_date <date>,
    ## #   maximum_daily_minimum_c_date_code <lgl>, extreme_daily_rainfall_mm <dbl>, extreme_daily_rainfall_mm_code <lgl>, …

For example, here, the code indicates that these temperature variables
meet the WMO ‘3 and 5 rule’ (no more than 3 consecutive and no more than
5 total missing for either temperature or precipitation).

Older climate normals are in a different format, but the codes are the
same

    ## # A tibble: 13 × 23
    ##    period temp_daily_average temp_daily_average_code temp_daily_max temp_daily_max_code temp_daily_min temp_daily_min_code
    ##    <fct>               <dbl> <chr>                            <dbl> <chr>                        <dbl> <chr>              
    ##  1 Jan                 -16.6 A                                -11.1 A                            -21.9 A                  
    ##  2 Feb                 -13.6 A                                 -8.1 A                            -19   A                  
    ##  3 Mar                  -6.2 A                                 -1   A                            -11.4 A                  
    ##  4 Apr                   4   A                                 10.5 A                             -2.6 A                  
    ##  5 May                  10.6 A                                 17.8 A                              3.4 A                  
    ##  6 Jun                  15.9 A                                 22.4 A                              9.3 A                  
    ##  7 Jul                  18.5 A                                 25.2 A                             11.7 A                  
    ##  8 Aug                  17.7 A                                 24.9 A                             10.4 A                  
    ##  9 Sep                  11.8 A                                 18.9 A                              4.7 A                  
    ## 10 Oct                   4.1 A                                 10.4 A                             -2.2 A                  
    ## 11 Nov                  -5.6 A                                 -0.5 A                            -10.6 A                  
    ## 12 Dec                 -14   A                                 -9   A                            -19   A                  
    ## 13 Year                  2.2 A                                  8.4 A                             -3.9 A                  
    ## # ℹ 16 more variables: rain_extreme_daily <dbl>, rain_extreme_daily_code <chr>, rain_extreme_daily_date <date>,
    ## #   rain_extreme_daily_date_code <chr>, snow_extreme_daily <dbl>, snow_extreme_daily_code <chr>,
    ## #   snow_extreme_daily_date <date>, snow_extreme_daily_date_code <chr>, precip_extreme_daily <dbl>,
    ## #   precip_extreme_daily_code <chr>, precip_extreme_daily_date <date>, precip_extreme_daily_date_code <chr>,
    ## #   sun_extreme_daily <dbl>, sun_extreme_daily_code <chr>, sun_extreme_daily_date <date>, sun_extreme_daily_date_code <chr>

### Codes - Climate Normals

The codes index for climate normals can be accessed through the built-in
data frame: `codes`

| location_name | period_of_record | Daily Average (°C) Code | StdDev Mean Monthly Temperature (°C) Code | Daily Maximum (°C) Code | Daily Minimum (°C) Code | Maximum Daily Mean (°C) Code | Maximum Daily Mean (°C) Date (yyyy/mm/dd) Code | Minimum Daily Mean (°C) Code | Minimum Daily Mean (°C) Date (yyyy/mm/dd) Code | Extreme Maximum (°C) Code | Extreme Maximum (°C) Date (yyyy/mm/dd) Code | Minimum Daily Maximum (°C) Code | Minimum Daily Maximum (°C) Date (yyyy/mm/dd) Code | Maximum Daily Minimum (°C) Code | Maximum Daily Minimum (°C) Date (yyyy/mm/dd) Code | Extreme Minimum (°C) Code | Extreme Minimum (°C) Date (yyyy/mm/dd) Code | Rainfall (mm) Code | Snowfall (cm) Code | Precipitation (mm) Code | Average Snow Depth (cm) Code | Median Snow Depth (cm) Code | Snow Depth at Month-end (cm) Code | Extreme Daily Rainfall (mm) Code | Extreme Daily Rainfall (mm) Date (yyyy/mm/dd) Code | Extreme Daily Snowfall (cm) Code | Extreme Daily Snowfall (cm) Date (yyyy/mm/dd) Code | Extreme Daily Precipitation (mm) Code | Extreme Daily Precipitation (mm) Date (yyyy/mm/dd) Code | Extreme Snow Depth (cm) Code | Extreme Snow Depth (cm) Date (yyyy/mm/dd) Code | Freezing Rain or Freezing Drizzle Code | Thunderstorms Code | Hail Code | Fog, Ice Fog, or Freezing Fog Code | Smoke or Haze Code | Days with Maximum Temperature \<= -30 °C Code | Days with Maximum Temperature \<= -20 °C Code | Days with Maximum Temperature \<= -10 °C Code | Days with Maximum Temperature \<= 0 °C Code | Days with Maximum Temperature \> 0 °C Code | Days with Maximum Temperature \> 10 °C Code | Days with Maximum Temperature \> 20 °C Code | Days with Maximum Temperature \> 30 °C Code | Days with Maximum Temperature \> 35 °C Code | Days with Maximum Temperature \> 40 °C Code | Days with Minimum Temperature \> 20 °C Code | Days with Minimum Temperature \> 10 °C Code | Days with Minimum Temperature \> 0 °C Code | Days with Minimum Temperature \<= 2 °C Code | Days with Minimum Temperature \<= 0 °C Code | Days with Minimum Temperature \< -2 °C Code | Days with Minimum Temperature \< -10 °C Code | Days with Minimum Temperature \< -20 °C Code | Days with Minimum Temperature \< -30 °C Code | Days with Minimum Temperature \< -40 °C Code | Days with Rainfall \>= 0.2 mm Code | Days with Rainfall \>= 5 mm Code | Days with Rainfall \>= 10 mm Code | Days with Rainfall \>= 25 mm Code | Days with Rainfall \>= 50 mm Code | Days with Rainfall \>= 100 mm Code | Days with Snowfall \>= 0.2 cm Code | Days with Snowfall \>= 5 cm Code | Days with Snowfall \>= 10 cm Code | Days with Snowfall \>= 25 cm Code | Days with Snowfall \>= 40 cm Code | Days with Precipitation \>= 0.2 mm Code | Days with Precipitation \>= 1 mm Code | Days with Precipitation \>= 5 mm Code | Days with Precipitation \>= 10 mm Code | Days with Precipitation \>= 25 mm Code | Days with Precipitation \>= 50 mm Code | Days with Precipitation \>= 100 mm Code | Days with Snow Depth \>= 1 cm Code | Days with Snow Depth \>= 5 cm Code | Days with Snow Depth \>= 10 cm Code | Days with Snow Depth \>= 20 cm Code | Days with Snow Depth \>= 30 cm Code | Days with Snow Depth \>= 50 cm Code | Days with Snow Depth \>= 100 cm Code | Wind Speed (km/h) Code | Most Frequent Wind Direction Code | Days with Winds \>= 52 km/h Code | Days with Winds \>= 63 km/h Code | Days with Gusts \>= 90 km/h Code | Extreme Wind Speed (km/h) Code | Extreme Wind Speed (km/h) Date (yyyy/mm/dd hh:mi) Code | Direction of Extreme Wind Speed Code | Direction of Extreme Wind Speed Date (yyyy/mm/dd hh:mi) Code | Extreme Gust Speed (km/h) Code | Extreme Gust Speed (km/h) Date (yyyy/mm/dd) Code | Direction of Extreme Gust Speed Code | Direction of Extreme Gust Speed Date (yyyy/mm/dd) Code | Degree Days Above 24 °C Code | Degree Days Above 18 °C Code | Degree Days Above 15 °C Code | Degree Days Above 10 °C Code | Degree Days Above 5 °C Code | Degree Days Above 0 °C Code | Degree Days Below 0 °C Code | Degree Days Below 5 °C Code | Degree Days Below 10 °C Code | Degree Days Below 15 °C Code | Degree Days Below 18 °C Code | Quintile 1 (Lower Bound) Code | Quintile 1 (Upper Bound) Code | Quintile 2 (Upper Bound) Code | Quintile 3 (Upper Bound) Code | Quintile 4 (Upper Bound) Code | Quintile 5 (Upper Bound) Code | Days with Humidex \>= 30 Code | Days with Humidex \>= 35 Code | Days with Humidex \>= 40 Code | Extreme Humidex Code | Extreme Humidex Date (yyyy/mm/dd) Code | Days with Wind Chill \< -20 Code | Days with Wind Chill \< -30 Code | Days with Wind Chill \< -40 Code | Days with Wind Chill \< -50 Code | Extreme Wind Chill Code | Extreme Wind Chill Date (yyyy/mm/dd) Code | Average Vapour Pressure (kPa) Code | Average Relative Humidity - 0600LST (%) Code | Average Relative Humidity - 1500LST (%) Code | Average Station Pressure (kPa) Code | Average Sea Level Pressure (kPa) Code | Visibility \< 1 km (hours with) Code | Visibility 1 to 9 km (hours with) Code | Visibility \> 9 km (hours with) Code | Cloud Amount 0 to 2 tenths (hours with) Code | Cloud Amount 3 to 7 tenths (hours with) Code | Cloud Amount 8 to 10 tenths (hours with) Code | Average Date of Last Spring Frost Code | Average Date of First Fall Frost Code | Average Length of Frost-Free Period Code | Probability of last temperature in spring \<= 0°C, on or after indicated date (10%) Code | Probability of last temperature in spring \<= 0°C, on or after indicated date (25%) Code | Probability of last temperature in spring \<= 0°C, on or after indicated date (33%) Code | Probability of last temperature in spring \<= 0°C, on or after indicated date (50%) Code | Probability of last temperature in spring \<= 0°C, on or after indicated date (66%) Code | Probability of last temperature in spring \<= 0°C, on or after indicated date (75%) Code | Probability of last temperature in spring \<= 0°C, on or after indicated date (90%) Code | Probability of first temperature in fall \<= 0°C, on or before indicated date (10%) Code | Probability of first temperature in fall \<= 0°C, on or before indicated date (25%) Code | Probability of first temperature in fall \<= 0°C, on or before indicated date (33%) Code | Probability of first temperature in fall \<= 0°C, on or before indicated date (50%) Code | Probability of first temperature in fall \<= 0°C, on or before indicated date (66%) Code | Probability of first temperature in fall \<= 0°C, on or before indicated date (75%) Code | Probability of first temperature in fall \<= 0°C, on or before indicated date (90%) Code | Probability of frost-free period equal to or less than indicated period (Days) (10%) Code | Probability of frost-free period equal to or less than indicated period (Days) (25%) Code | Probability of frost-free period equal to or less than indicated period (Days) (33%) Code | Probability of frost-free period equal to or less than indicated period (Days) (50%) Code | Probability of frost-free period equal to or less than indicated period (Days) (66%) Code | Probability of frost-free period equal to or less than indicated period (Days) (75%) Code | Probability of frost-free period equal to or less than indicated period (Days) (90%) Code | Average Date of Last Spring Snowfall Code | Average Date of First Fall Snowfall Code |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| BRANDON | Normal | A | A | A | A | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | C | C | C | C | C | C | NA | NA | NA | NA | NA | NA | NA | NA | A | A | A | A | A | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | C | A | A | C | C | D | NA | NA | NA | NA | NA | NA | NA | NA | C | C | C | C | C | C | C | C | C | C | C | NA | NA | NA | NA | NA | NA | A | A | A | NA | NA | A | A | A | A | NA | NA | A | A | A | A | A | A | A | A | D | D | D | D | D | D | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | A | A |
| BRANDON | Long-Term | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA |
