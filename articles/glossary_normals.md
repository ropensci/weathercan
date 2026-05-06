# Climate Normals: Terms and Units

This table shows details regarding original column (measurement) names
and units of all climate normals measurements. It further provides links
back to the ECCC glossary for more details.

See the ECCC documentation on climate normals for more details:

- [1991-2020](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1991_2020_Calculation_Information.pdf)
- [1981-2010](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1981_2010_Calculation_Information.pdf)
- [1971-2000](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1971_2000_Calculation_Information.pdf)

For details on weather measurements, see the
[glossary](https://docs.ropensci.org/weathercan/articles/glossary.md)
vignette.

## General descriptions

| ECCC | weathercan | description |
|:---|:---|:---|
| Temperature | temp | Temperature measurements are made from self-registering maximum and minimum thermometers set in a louvered, wooden shelter. The shelter is mounted on a stand so that the thermometers are approximately 1.5 m above ground, which is usually a level, grassy surface. |
| Rainfall, Snowfall, And Precipitation | precip | Rain, drizzle, freezing rain, freezing drizzle and hail are usually measured using the standard Canadian rain gauge, a cylindrical container 40 cm high and 11.3 cm in diameter. The precipitation is funneled into a plastic graduate which serves as the measuring device. |
| Snow Depth | snow_depth | Snow cover is the depth of accumulated snow on the ground, measured at several points which appear representative of the immediate area, and then averaged. |
| Number Of Days With Specified Parameters | days | These elements give the average number of days per month or year on which a specific meteorological event or parameter threshold occurs. In the case of rainfall and precipitation, 0.2 mm or more must occur before a “day with” is counted. The corresponding figure for snowfall is 0.2 cm. |
| Degree-Days | dd | Degree-days for a given day represent the number of Celsius degrees that the mean temperature is above or below a given base. For example, heating degree-days are the number of degrees below 18° C. If the temperature is equal to or greater than 18, then the number of heating degrees will be zero. Normals represent the average accumulation for a given month or year. |
| Soil Temperature | soil_temp | Soil temperature measurements provide the climatology of soil thermal characteristics such as the depth of frost penetration into the soil and the duration that the soil remains frozen. It is of interest to hydrologists because it affects surface runoff, infiltration and snowmelt and to agriculturalists because it affects seed germination. |
| Evaporation | evaporation | Evaporation refers to the calculated lake evaporation occurring from a small natural open water-body having negligible heat storage and very little heat transfer at its bottom and sides. It represents the water loss from ponds and small reservoirs but not from lakes that have large heat storage capacities. Lake evaporation is calculated using the observed daily values of pan evaporative water loss, the mean temperatures of the water in the pan and of the nearby air, and the total wind run over the pan. |
| Frost And Freezing-Free Period | frost | Freezing occurs whenever temperatures fall to 0 deg C or lower. Frost data normals are based on the occurrence of freezing temperatures as recorded from minimum thermometers. The “Freezing-free Period” is defined as the number of days between the last occurrence of frost in spring and first occurrence of frost in the fall for a given year. For the purposes of these calculations, “spring” is defined as days on or before July 15, “fall” is defined as days after July 15 and freezing or frost occurs on any day where the daily minimum temperature (Tmin) is observed to be less than or equal to 0 deg C. |
| Hourly Data | hours | Some climate elements are observed on an hourly rather than a daily basis. For these elements, the “3 and 5” rule for completeness is inapplicable given the comprehensive volume of data. Instead, to qualify for inclusion, hourly elements must have at least 90% of all available hours for a month complete where means or “days with” statistics are calculated. As with daily elements, where average totals are calculated, the record required 100% complete data. The monthly mean was then assigned an annual code following the completeness requirements. |
| Wind | wind | Most principal climatological stations are equipped with a standard type U2A anemometer, taking one-minute or (since 1985) two-minute mean speeds values at each observation. At other wind-measuring sites, values are usually obtained from autographic records of U2A or 45B anemometers. Averaging periods at these sites may vary from one minute to an hour. |
| Bright Sunshine | sun | Bright sunshine observations are made using the Campbell-Stokes sunshine recorder. It consists of a glass sphere that is 10 cm in diameter, mounted concentrically in a portion of a spherical bowl. The sun’s rays are focused by the glass sphere on a card held in position by a pair of grooves in the bowl. The focused rays scorch the card or burn a trace right through it. The card size used depends on the length of the day and is available in three classes corresponding to the time of the year equinox, summer or winter solstice. |
| Humidex | humidex | Humidex is an index to indicate how hot or humid the weather feels to the average person. It is derived by combining temperature and humidity values into one number to reflect the perceived temperature. For example, a humidex of 40 means that the sensation of heat when the temperature is 30 degrees and the air is humid feels more or less the same as when the temperature is 40 degrees and the air is dry. |
| Wind Chill | wind_chill | Wind chill is an index to indicate how cold the weather feels to the average person. It is derived by combining temperature and wind velocity values into one number to reflect the perceived temperature. For example, if the outside temperature is -10°C and the wind chill is -20, it means that your face will feel more or less as cold as it would on a calm day when the temperature is -20°C. |
| Humidity | humidity | Vapour pressure is the pressure exerted by the water present in an air parcel. This pressure is one of the partial pressures that make up the total pressure exerted by an air parcel. The vapour pressure increases as the amount of water vapour increases. |
| Pressure | pressure | Pressure is the weight of a column of air of unit cross-sectional area extending from the level of the observing station vertically to the outer limit of the atmosphere. The standard instrument for the measurement of atmospheric pressure is the mercury barometer, in which the air pressure is balanced against the weight of a column of mercury in a glass tube that contains a vacuum. |
| Solar Radiation | rad | Solar radiation is the measurement of radiant energy from the sun, on a horizontal surface. There are several standardized components of independent measurements. Each component is assigned a different identifying number referred to as Radiation Fields (RF). The standard metric unit of radiation measurement is the Mega Joule per square metre (MJ/m2). |
| Visibility (Km) | visibility | Visibility in kilometers (km) is the distance at which objects of suitable size can be seen and identified. Precipitation, fog, haze or other obstructions such as blowing snow or dust can reduce atmospheric visibility. |
| Cloud Amount | cloud | A cloud in the atmosphere is a visible collection of minute particle matter, such as water droplets and/or ice crystals, in the air. Condensation nuclei, such as smoke or dust particles, form a surface around which water vapour can condense and create clouds. |

## Original names and units

These represent the original ECCC measurement names with units and their
corresponding measurements in `weathercan`.

Note that because the format of normals from 1991-2020 differs from that
in previous years, we treat them separately.

## 1991-2020

### Temperature

| ECCC | weathercan |
|:---|:---|
| Daily Average (°C) | daily_average_c |
| StdDev Mean Monthly Temperature (°C) | stddev_mean_monthly_temperature_c |
| Daily Maximum (°C) | daily_maximum_c |
| Daily Minimum (°C) | daily_minimum_c |
| Maximum Daily Mean (°C) | maximum_daily_mean_c |
| Maximum Daily Mean (°C) Date (yyyy/mm/dd) | maximum_daily_mean_c_date |
| Minimum Daily Mean (°C) | minimum_daily_mean_c |
| Minimum Daily Mean (°C) Date (yyyy/mm/dd) | minimum_daily_mean_c_date |
| Extreme Maximum (°C) | extreme_maximum_c |
| Extreme Maximum (°C) Date (yyyy/mm/dd) | extreme_maximum_c_date |
| Minimum Daily Maximum (°C) | minimum_daily_maximum_c |
| Minimum Daily Maximum (°C) Date (yyyy/mm/dd) | minimum_daily_maximum_c_date |
| Maximum Daily Minimum (°C) | maximum_daily_minimum_c |
| Maximum Daily Minimum (°C) Date (yyyy/mm/dd) | maximum_daily_minimum_c_date |
| Extreme Minimum (°C) | extreme_minimum_c |
| Extreme Minimum (°C) Date (yyyy/mm/dd) | extreme_minimum_c_date |

### Precipitation

| ECCC | weathercan |
|:---|:---|
| Rainfall (mm) | rainfall_mm |
| Snowfall (cm) | snowfall_cm |
| Precipitation (mm) | precipitation_mm |
| Average Snow Depth (cm) | average_snow_depth_cm |
| Median Snow Depth (cm) | median_snow_depth_cm |
| Snow Depth at Month-end (cm) | snow_depth_at_month_end_cm |
| Extreme Daily Rainfall (mm) | extreme_daily_rainfall_mm |
| Extreme Daily Rainfall (mm) Date (yyyy/mm/dd) | extreme_daily_rainfall_mm_date |
| Extreme Daily Snowfall (cm) | extreme_daily_snowfall_cm |
| Extreme Daily Snowfall (cm) Date (yyyy/mm/dd) | extreme_daily_snowfall_cm_date |
| Extreme Daily Precipitation (mm) | extreme_daily_precipitation_mm |
| Extreme Daily Precipitation (mm) Date (yyyy/mm/dd) | extreme_daily_precipitation_mm_date |
| Extreme Snow Depth (cm) | extreme_snow_depth_cm |
| Extreme Snow Depth (cm) Date (yyyy/mm/dd) | extreme_snow_depth_cm_date |

### Days With Maximum Temperature

| ECCC | weathercan |
|:---|:---|
| Days with Maximum Temperature \<= -30 °C | days_with_maximum_temperature\_\<=\_30_c |
| Days with Maximum Temperature \<= -20 °C | days_with_maximum_temperature\_\<=\_20_c |
| Days with Maximum Temperature \<= -10 °C | days_with_maximum_temperature\_\<=\_10_c |
| Days with Maximum Temperature \<= 0 °C | days_with_maximum_temperature\_\<=\_0_c |
| Days with Maximum Temperature \> 0 °C | days_with_maximum_temperature\_\>\_0_c |
| Days with Maximum Temperature \> 10 °C | days_with_maximum_temperature\_\>\_10_c |
| Days with Maximum Temperature \> 20 °C | days_with_maximum_temperature\_\>\_20_c |
| Days with Maximum Temperature \> 30 °C | days_with_maximum_temperature\_\>\_30_c |
| Days with Maximum Temperature \> 35 °C | days_with_maximum_temperature\_\>\_35_c |
| Days with Maximum Temperature \> 40 °C | days_with_maximum_temperature\_\>\_40_c |

### Days With Minimum Temperature

| ECCC | weathercan |
|:---|:---|
| Days with Minimum Temperature \> 20 °C | days_with_minimum_temperature\_\>\_20_c |
| Days with Minimum Temperature \> 10 °C | days_with_minimum_temperature\_\>\_10_c |
| Days with Minimum Temperature \> 0 °C | days_with_minimum_temperature\_\>\_0_c |
| Days with Minimum Temperature \<= 2 °C | days_with_minimum_temperature\_\<=\_2_c |
| Days with Minimum Temperature \<= 0 °C | days_with_minimum_temperature\_\<=\_0_c |
| Days with Minimum Temperature \< -2 °C | days_with_minimum_temperature\_\<\_2_c |
| Days with Minimum Temperature \< -10 °C | days_with_minimum_temperature\_\<\_10_c |
| Days with Minimum Temperature \< -20 °C | days_with_minimum_temperature\_\<\_20_c |
| Days with Minimum Temperature \< -30 °C | days_with_minimum_temperature\_\<\_30_c |
| Days with Minimum Temperature \< -40 °C | days_with_minimum_temperature\_\<\_40_c |

### Days With Rainfall

| ECCC                          | weathercan                      |
|:------------------------------|:--------------------------------|
| Days with Rainfall \>= 0.2 mm | days_with_rainfall\_\>=\_02_mm  |
| Days with Rainfall \>= 5 mm   | days_with_rainfall\_\>=\_5_mm   |
| Days with Rainfall \>= 10 mm  | days_with_rainfall\_\>=\_10_mm  |
| Days with Rainfall \>= 25 mm  | days_with_rainfall\_\>=\_25_mm  |
| Days with Rainfall \>= 50 mm  | days_with_rainfall\_\>=\_50_mm  |
| Days with Rainfall \>= 100 mm | days_with_rainfall\_\>=\_100_mm |

### Days With Snowfall

| ECCC                          | weathercan                     |
|:------------------------------|:-------------------------------|
| Days with Snowfall \>= 0.2 cm | days_with_snowfall\_\>=\_02_cm |
| Days with Snowfall \>= 5 cm   | days_with_snowfall\_\>=\_5_cm  |
| Days with Snowfall \>= 10 cm  | days_with_snowfall\_\>=\_10_cm |
| Days with Snowfall \>= 25 cm  | days_with_snowfall\_\>=\_25_cm |
| Days with Snowfall \>= 40 cm  | days_with_snowfall\_\>=\_40_cm |

### Days With Precipitation

| ECCC                               | weathercan                           |
|:-----------------------------------|:-------------------------------------|
| Days with Precipitation \>= 0.2 mm | days_with_precipitation\_\>=\_02_mm  |
| Days with Precipitation \>= 1 mm   | days_with_precipitation\_\>=\_1_mm   |
| Days with Precipitation \>= 5 mm   | days_with_precipitation\_\>=\_5_mm   |
| Days with Precipitation \>= 10 mm  | days_with_precipitation\_\>=\_10_mm  |
| Days with Precipitation \>= 25 mm  | days_with_precipitation\_\>=\_25_mm  |
| Days with Precipitation \>= 50 mm  | days_with_precipitation\_\>=\_50_mm  |
| Days with Precipitation \>= 100 mm | days_with_precipitation\_\>=\_100_mm |

### Days With Snow Depth

| ECCC                            | weathercan                        |
|:--------------------------------|:----------------------------------|
| Days with Snow Depth \>= 1 cm   | days_with_snow_depth\_\>=\_1_cm   |
| Days with Snow Depth \>= 5 cm   | days_with_snow_depth\_\>=\_5_cm   |
| Days with Snow Depth \>= 10 cm  | days_with_snow_depth\_\>=\_10_cm  |
| Days with Snow Depth \>= 20 cm  | days_with_snow_depth\_\>=\_20_cm  |
| Days with Snow Depth \>= 30 cm  | days_with_snow_depth\_\>=\_30_cm  |
| Days with Snow Depth \>= 50 cm  | days_with_snow_depth\_\>=\_50_cm  |
| Days with Snow Depth \>= 100 cm | days_with_snow_depth\_\>=\_100_cm |

### Wind

| ECCC | weathercan |
|:---|:---|
| Wind Speed (km/h) | wind_speed_kmh |
| Most Frequent Wind Direction | most_frequent_wind_direction |
| Days with Gusts \>= 90 km/h | days_with_gusts\_\>=\_90_kmh |
| Extreme Wind Speed (km/h) | extreme_wind_speed_kmh |
| Extreme Wind Speed (km/h) Date (yyyy/mm/dd hh:mi) | extreme_wind_speed_kmh_date_hhmi |
| Direction of Extreme Wind Speed | direction_of_extreme_wind_speed |
| Direction of Extreme Wind Speed Date (yyyy/mm/dd hh:mi) | direction_of_extreme_wind_speed_date_hhmi |
| Extreme Gust Speed (km/h) | extreme_gust_speed_kmh |
| Extreme Gust Speed (km/h) Date (yyyy/mm/dd) | extreme_gust_speed_kmh_date |
| Direction of Extreme Gust Speed | direction_of_extreme_gust_speed |
| Direction of Extreme Gust Speed Date (yyyy/mm/dd) | direction_of_extreme_gust_speed_date |
| Days with Winds \>= 52 km/h | days_with_winds\_\>=\_52_kmh |
| Days with Winds \>= 63 km/h | days_with_winds\_\>=\_63_kmh |

### Degree Days

| ECCC                    | weathercan             |
|:------------------------|:-----------------------|
| Degree Days Above 24 °C | degree_days_above_24_c |
| Degree Days Above 18 °C | degree_days_above_18_c |
| Degree Days Above 15 °C | degree_days_above_15_c |
| Degree Days Above 10 °C | degree_days_above_10_c |
| Degree Days Above 5 °C  | degree_days_above_5_c  |
| Degree Days Above 0 °C  | degree_days_above_0_c  |
| Degree Days Below 0 °C  | degree_days_below_0_c  |
| Degree Days Below 5 °C  | degree_days_below_5_c  |
| Degree Days Below 10 °C | degree_days_below_10_c |
| Degree Days Below 15 °C | degree_days_below_15_c |
| Degree Days Below 18 °C | degree_days_below_18_c |

### Quintiles

| ECCC                     | weathercan             |
|:-------------------------|:-----------------------|
| Quintile 1 (Lower Bound) | quintile_1_lower_bound |
| Quintile 1 (Upper Bound) | quintile_1_upper_bound |
| Quintile 2 (Upper Bound) | quintile_2_upper_bound |
| Quintile 3 (Upper Bound) | quintile_3_upper_bound |
| Quintile 4 (Upper Bound) | quintile_4_upper_bound |
| Quintile 5 (Upper Bound) | quintile_5_upper_bound |

### Humidex

| ECCC                              | weathercan                 |
|:----------------------------------|:---------------------------|
| Days with Humidex \>= 30          | days_with_humidex\_\>=\_30 |
| Days with Humidex \>= 35          | days_with_humidex\_\>=\_35 |
| Days with Humidex \>= 40          | days_with_humidex\_\>=\_40 |
| Extreme Humidex                   | extreme_humidex            |
| Extreme Humidex Date (yyyy/mm/dd) | extreme_humidex_date       |

### Wind Chill

| ECCC                                 | weathercan                   |
|:-------------------------------------|:-----------------------------|
| Days with Wind Chill \< -20          | days_with_wind_chill\_\<\_20 |
| Days with Wind Chill \< -30          | days_with_wind_chill\_\<\_30 |
| Days with Wind Chill \< -40          | days_with_wind_chill\_\<\_40 |
| Days with Wind Chill \< -50          | days_with_wind_chill\_\<\_50 |
| Extreme Wind Chill                   | extreme_wind_chill           |
| Extreme Wind Chill Date (yyyy/mm/dd) | extreme_wind_chill_date      |

### Humidity

| ECCC                                    | weathercan                        |
|:----------------------------------------|:----------------------------------|
| Average Vapour Pressure (kPa)           | average_vapour_pressure_kpa       |
| Average Relative Humidity - 0600LST (%) | average_relative_humidity_0600lst |
| Average Relative Humidity - 1500LST (%) | average_relative_humidity_1500lst |

### Pressure

| ECCC                             | weathercan                     |
|:---------------------------------|:-------------------------------|
| Average Station Pressure (kPa)   | average_station_pressure_kpa   |
| Average Sea Level Pressure (kPa) | average_sea_level_pressure_kpa |

### Frost-Free

| ECCC | weathercan |
|:---|:---|
| Average Date of Last Spring Frost | average_date_of_last_spring_frost |
| Average Date of First Fall Frost | average_date_of_first_fall_frost |
| Average Length of Frost-Free Period | average_length_of_frost_free_period |
| Probability of last temperature in spring \<= 0°C, on or after indicated date (10%) | probability_of_last_temperature_in_spring\_\<=\_0c_on_or_after_indicated_date_10 |
| Probability of last temperature in spring \<= 0°C, on or after indicated date (25%) | probability_of_last_temperature_in_spring\_\<=\_0c_on_or_after_indicated_date_25 |
| Probability of last temperature in spring \<= 0°C, on or after indicated date (33%) | probability_of_last_temperature_in_spring\_\<=\_0c_on_or_after_indicated_date_33 |
| Probability of last temperature in spring \<= 0°C, on or after indicated date (50%) | probability_of_last_temperature_in_spring\_\<=\_0c_on_or_after_indicated_date_50 |
| Probability of last temperature in spring \<= 0°C, on or after indicated date (66%) | probability_of_last_temperature_in_spring\_\<=\_0c_on_or_after_indicated_date_66 |
| Probability of last temperature in spring \<= 0°C, on or after indicated date (75%) | probability_of_last_temperature_in_spring\_\<=\_0c_on_or_after_indicated_date_75 |
| Probability of last temperature in spring \<= 0°C, on or after indicated date (90%) | probability_of_last_temperature_in_spring\_\<=\_0c_on_or_after_indicated_date_90 |
| Probability of first temperature in fall \<= 0°C, on or before indicated date (10%) | probability_of_first_temperature_in_fall\_\<=\_0c_on_or_before_indicated_date_10 |
| Probability of first temperature in fall \<= 0°C, on or before indicated date (25%) | probability_of_first_temperature_in_fall\_\<=\_0c_on_or_before_indicated_date_25 |
| Probability of first temperature in fall \<= 0°C, on or before indicated date (33%) | probability_of_first_temperature_in_fall\_\<=\_0c_on_or_before_indicated_date_33 |
| Probability of first temperature in fall \<= 0°C, on or before indicated date (50%) | probability_of_first_temperature_in_fall\_\<=\_0c_on_or_before_indicated_date_50 |
| Probability of first temperature in fall \<= 0°C, on or before indicated date (66%) | probability_of_first_temperature_in_fall\_\<=\_0c_on_or_before_indicated_date_66 |
| Probability of first temperature in fall \<= 0°C, on or before indicated date (75%) | probability_of_first_temperature_in_fall\_\<=\_0c_on_or_before_indicated_date_75 |
| Probability of first temperature in fall \<= 0°C, on or before indicated date (90%) | probability_of_first_temperature_in_fall\_\<=\_0c_on_or_before_indicated_date_90 |
| Probability of frost-free period equal to or less than indicated period (Days) (10%) | probability_of_frost_free_period_equal_to_or_less_than_indicated_period_days_10 |
| Probability of frost-free period equal to or less than indicated period (Days) (25%) | probability_of_frost_free_period_equal_to_or_less_than_indicated_period_days_25 |
| Probability of frost-free period equal to or less than indicated period (Days) (33%) | probability_of_frost_free_period_equal_to_or_less_than_indicated_period_days_33 |
| Probability of frost-free period equal to or less than indicated period (Days) (50%) | probability_of_frost_free_period_equal_to_or_less_than_indicated_period_days_50 |
| Probability of frost-free period equal to or less than indicated period (Days) (66%) | probability_of_frost_free_period_equal_to_or_less_than_indicated_period_days_66 |
| Probability of frost-free period equal to or less than indicated period (Days) (75%) | probability_of_frost_free_period_equal_to_or_less_than_indicated_period_days_75 |
| Probability of frost-free period equal to or less than indicated period (Days) (90%) | probability_of_frost_free_period_equal_to_or_less_than_indicated_period_days_90 |

### Days With …

| ECCC                              | weathercan                        |
|:----------------------------------|:----------------------------------|
| Freezing Rain or Freezing Drizzle | freezing_rain_or_freezing_drizzle |
| Thunderstorms                     | thunderstorms                     |
| Hail                              | hail                              |
| Fog, Ice Fog, or Freezing Fog     | fog_ice_fog_or_freezing_fog       |
| Smoke or Haze                     | smoke_or_haze                     |

### Visibility

| ECCC                              | weathercan                      |
|:----------------------------------|:--------------------------------|
| Visibility \< 1 km (hours with)   | visibility\_\<\_1_km_hours_with |
| Visibility 1 to 9 km (hours with) | visibility_1_to_9_km_hours_with |
| Visibility \> 9 km (hours with)   | visibility\_\>\_9_km_hours_with |

### Cloud Amount

| ECCC | weathercan |
|:---|:---|
| Cloud Amount 0 to 2 tenths (hours with) | cloud_amount_0_to_2_tenths_hours_with |
| Cloud Amount 3 to 7 tenths (hours with) | cloud_amount_3_to_7_tenths_hours_with |
| Cloud Amount 8 to 10 tenths (hours with) | cloud_amount_8_to_10_tenths_hours_with |

### Snow-Period

| ECCC                                 | weathercan                           |
|:-------------------------------------|:-------------------------------------|
| Average Date of Last Spring Snowfall | average_date_of_last_spring_snowfall |
| Average Date of First Fall Snowfall  | average_date_of_first_fall_snowfall  |

## 1981-2010 and 1971-2000

### Temperature

| ECCC                | weathercan            |
|:--------------------|:----------------------|
| Daily Average (C)   | temp_daily_average    |
| Standard Deviation  | temp_sd               |
| Daily Maximum (C)   | temp_daily_max        |
| Daily Minimum (C)   | temp_daily_min        |
| Extreme Maximum (C) | temp_extreme_max      |
| Date (YYYY/DD)      | temp_extreme_max_date |
| Extreme Minimum (C) | temp_extreme_min      |
| Date (YYYY/DD)      | temp_extreme_min_date |

### Precipitation

| ECCC                             | weathercan                |
|:---------------------------------|:--------------------------|
| Rainfall (mm)                    | rain                      |
| Snowfall (cm)                    | snow                      |
| Precipitation (mm)               | precip                    |
| Average Snow Depth (cm)          | snow_mean_depth           |
| Median Snow Depth (cm)           | snow_median_depth         |
| Snow Depth At Month-End (cm)     | snow_depth_month_end      |
| Extreme Daily Rainfall (mm)      | rain_extreme_daily        |
| Date (YYYY/DD)                   | rain_extreme_daily_date   |
| Extreme Daily Snowfall (cm)      | snow_extreme_daily        |
| Date (YYYY/DD)                   | snow_extreme_daily_date   |
| Extreme Daily Precipitation (mm) | precip_extreme_daily      |
| Date (YYYY/DD)                   | precip_extreme_daily_date |
| Extreme Snow Depth (cm)          | snow_extreme_depth        |
| Date (YYYY/DD)                   | snow_extreme_depth_date   |

### Days With Maximum Temperature

| ECCC    | weathercan          |
|:--------|:--------------------|
| \<= 0 C | temp_max_days\_\<=0 |
| \> 0 C  | temp_max_days\_\>0  |
| \> 10 C | temp_max_days\_\>10 |
| \> 20 C | temp_max_days\_\>20 |
| \> 30 C | temp_max_days\_\>30 |
| \> 35 C | temp_max_days\_\>35 |

### Days With Minimum Temperature

| ECCC      | weathercan           |
|:----------|:---------------------|
| \> 0 C    | temp_min_days\_\>0   |
| \<= 2 C   | temp_min_days\_\<=2  |
| \<= 0 C   | temp_min_days\_\<=0  |
| \< -2 C   | temp_min_days\_\<-2  |
| \< -10 C  | temp_min_days\_\<-10 |
| \< -20 C  | temp_min_days\_\<-20 |
| \< - 30 C | temp_min_days\_\<-30 |

### Days With Rainfall

| ECCC       | weathercan        |
|:-----------|:------------------|
| \>= 0.2 mm | rain_days\_\>=0.2 |
| \>= 5 mm   | rain_days\_\>=5   |
| \>= 10 mm  | rain_days\_\>=10  |
| \>= 25 mm  | rain_days\_\>=25  |

### Days With Snowfall

| ECCC       | weathercan        |
|:-----------|:------------------|
| \>= 0.2 cm | snow_days\_\>=0.2 |
| \>= 5 cm   | snow_days\_\>=5   |
| \>= 10 cm  | snow_days\_\>=10  |
| \>= 25 cm  | snow_days\_\>=25  |

### Days With Precipitation

| ECCC       | weathercan          |
|:-----------|:--------------------|
| \>= 0.2 mm | precip_days\_\>=0.2 |
| \>= 5 mm   | precip_days\_\>=5   |
| \>= 10 mm  | precip_days\_\>=10  |
| \>= 25 mm  | precip_days\_\>=25  |

### Days With Snow Depth

| ECCC      | weathercan             |
|:----------|:-----------------------|
| \>= 1 cm  | snow_depth_days\_\>=1  |
| \>= 5 cm  | snow_depth_days\_\>=5  |
| \>= 10 cm | snow_depth_days\_\>=10 |
| \>= 20 cm | snow_depth_days\_\>=20 |

### Wind

| ECCC                              | weathercan          |
|:----------------------------------|:--------------------|
| Speed (km/h)                      | wind_speed          |
| Most Frequent Direction           | wind_dir            |
| Maximum Hourly Speed (km/h)       | wind_max_speed      |
| Date (YYYY/DD)                    | wind_max_speed_date |
| Direction Of Maximum Hourly Speed | wind_max_speed_dir  |
| Maximum Gust Speed (km/h)         | wind_max_gust       |
| Date (YYYY/DD)                    | wind_max_gust_date  |
| Direction Of Maximum Gust         | wind_max_gust_dir   |
| Days With Winds \>= 52 km/h       | wind_days\_\>=52    |
| Days With Winds \>= 63 km/h       | wind_days\_\>=63    |

### Degree Days

| ECCC       | weathercan  |
|:-----------|:------------|
| Above 24 C | dd_above_24 |
| Above 18 C | dd_above_18 |
| Above 15 C | dd_above_15 |
| Above 10 C | dd_above_10 |
| Above 5 C  | dd_above_5  |
| Above 0 C  | dd_above_0  |
| Below 0 C  | dd_below_0  |
| Below 5 C  | dd_below_5  |
| Below 10 C | dd_below_10 |
| Below 15 C | dd_below_15 |
| Below 18 C | dd_below_18 |

### Soil Temperature

| ECCC                         | weathercan       |
|:-----------------------------|:-----------------|
| At 5 cm Depth (AM Obs) (C)   | soil_temp_am_5   |
| At 5 cm Depth (PM Obs) (C)   | soil_temp_pm_5   |
| At 10 cm Depth (AM Obs) (C)  | soil_temp_am_10  |
| At 10 cm Depth (PM Obs) (C)  | soil_temp_pm_10  |
| At 20 cm Depth (AM Obs) (C)  | soil_temp_am_20  |
| At 20 cm Depth (PM Obs) (C)  | soil_temp_pm_20  |
| At 50 cm Depth (AM Obs) (C)  | soil_temp_am_50  |
| At 50 cm Depth (PM Obs) (C)  | soil_temp_pm_50  |
| At 100 cm Depth (AM Obs) (C) | soil_temp_am_100 |
| At 100 cm Depth (PM Obs) (C) | soil_temp_pm_100 |
| At 150 cm Depth (AM Obs) (C) | soil_temp_am_150 |
| At 150 cm Depth (PM Obs) (C) | soil_temp_pm_150 |
| At 300 cm Depth (AM Obs) (C) | soil_temp_am_300 |
| At 300 cm Depth (PM Obs) (C) | soil_temp_pm_300 |

### Evaporation

| ECCC                  | weathercan       |
|:----------------------|:-----------------|
| Lake Evaporation (mm) | lake_evaporation |

### Bright Sunshine

| ECCC                         | weathercan              |
|:-----------------------------|:------------------------|
| Total Hours                  | sun_hours               |
| Days With Measurable         | sun_measurable_days     |
| % Of Possible Daylight Hours | sun_perc_daylight_hours |
| Extreme Daily                | sun_extreme_daily       |
| Date (YYYY/DD)               | sun_extreme_daily_date  |

### Humidex

| ECCC                     | weathercan        |
|:-------------------------|:------------------|
| Extreme Humidex          | hmdx_extreme      |
| Date (YYYY/DD)           | hmdx_extreme_date |
| Days With Humidex \>= 30 | hmdx_days\_\>=30  |
| Days With Humidex \>= 35 | hmdx_days\_\>=35  |
| Days With Humidex \>= 40 | hmdx_days\_\>=40  |

### Wind Chill

| ECCC                        | weathercan              |
|:----------------------------|:------------------------|
| Extreme Wind Chill (C)      | wind_chill_extreme      |
| Date (YYYY/DD)              | wind_chill_extreme_date |
| Days With Wind Chill \< -20 | wind_chill_days\_\<-20  |
| Days With Wind Chill \< -30 | wind_chill_days\_\<-30  |
| Days With Wind Chill \< -40 | wind_chill_days\_\<-40  |

### Humidity

| ECCC                                    | weathercan             |
|:----------------------------------------|:-----------------------|
| Average Vapour Pressure (kPa)           | humidity_mean_pressure |
| Average Relative Humidity - 0600LST (%) | humidity_mean_0600LST  |
| Average Relative Humidity - 1500LST (%) | humidity_mean_1500LST  |

### Pressure

| ECCC                             | weathercan        |
|:---------------------------------|:------------------|
| Average Station Pressure (kPa)   | pressure_stn_mean |
| Average Sea Level Pressure (kPa) | pressure_sea_mean |

### Radiation

| ECCC                            | weathercan                     |
|:--------------------------------|:-------------------------------|
| Global - RF1 (MJ/m2)            | rad_global_rf1                 |
| Extreme Global - RF1 (MJ/m2)    | rad_extreme_global_rf1         |
| Date (YYYY/DD)                  | rad_extreme_global_rf1_date    |
| Diffuse - RF2 (MJ/m2)           | rad_diffuse_rf2                |
| Extreme Diffuse - RF2 (MJ/m2)   | rad_extreme_diffuse_rf2        |
| Date (YYYY/DD)                  | rad_extreme_diffuse_rf2_date   |
| Reflected - RF3 (MJ/m2)         | rad_reflected_rf3              |
| Extreme Reflected - RF3 (MJ/m2) | rad_extreme_reflected_rf3      |
| Date (YYYY/DD)                  | rad_extreme_reflected_rf3_date |
| Net - RF4 (MJ/m2)               | rad_net_rf4                    |
| Extreme Net - RF4 (MJ/m2)       | rad_extreme_net_rf4            |
| Date (YYYY/DD)                  | rad_extreme_net_rf4_date       |

### Visibility (Hours With)

| ECCC      | weathercan      |
|:----------|:----------------|
| \< 1 Km   | visibility\_\<1 |
| 1 To 9 Km | visibility_1_9  |
| \> 9 Km   | visibility\_\>9 |

### Cloud Amount (Hours With)

| ECCC | weathercan |
|:---|:---|
| 0 To 2 Tenths | cloud_0_2 |
| 3 To 7 Tenths | cloud_3_7 |
| 8 To 10 Tenths | cloud_8_10 |
| Average Date Of Last Spring Frost | date_last_spring_frost |
| Average Date Of First Fall Frost | date_first_fall_frost |
| Average Length Of Frost-Free Period | length_frost_free |
| Probability Of Last Temperature In Spring Of 0 C Or Lower On Or After Indicated Dates | prob_last_spring_temp_below_0_on_date |
| Probability Of First Temperature In Fall Of 0 C Or Lower On Or Before Indicated Dates | prob_first_fall_temp_below_0_on_date |
| Probability Of Frost-Free Period Equal To Or Less Than Indicated Period (Days) | prob_length_frost_free |
