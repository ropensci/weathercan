# Climate Normals: Terms and Units

This table shows details regarding original column (measurement) names
and units of all climate normals measurements. It further provides links
back to the ECCC glossary for more details.

See the ECCC website on climate normals for more details:
<https://www.canada.ca/en/environment-climate-change/services/climate-change/canadian-centre-climate-services/display-download/technical-documentation-climate-normals.html>

For details on weather measurements, see the `glossary` vignette.

### General descriptions

| ECCC_name                                | weathercan_name | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|:-----------------------------------------|:----------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Temperature                              | temp            | Temperature measurements are made from self-registering maximum and minimum thermometers set in a louvered, wooden shelter. The shelter is mounted on a stand so that the thermometers are approximately 1.5 m above ground, which is usually a level, grassy surface.                                                                                                                                                                                                                                                                                                                                                      |
| Rainfall, Snowfall, And Precipitation    | precip          | Rain, drizzle, freezing rain, freezing drizzle and hail are usually measured using the standard Canadian rain gauge, a cylindrical container 40 cm high and 11.3 cm in diameter. The precipitation is funneled into a plastic graduate which serves as the measuring device.                                                                                                                                                                                                                                                                                                                                                |
| Snow Depth                               | snow_depth      | Snow cover is the depth of accumulated snow on the ground, measured at several points which appear representative of the immediate area, and then averaged.                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Number Of Days With Specified Parameters | days            | These elements give the average number of days per month or year on which a specific meteorological event or parameter threshold occurs. In the case of rainfall and precipitation, 0.2 mm or more must occur before a “day with” is counted. The corresponding figure for snowfall is 0.2 cm.                                                                                                                                                                                                                                                                                                                              |
| Degree-Days                              | dd              | Degree-days for a given day represent the number of Celsius degrees that the mean temperature is above or below a given base. For example, heating degree-days are the number of degrees below 18° C. If the temperature is equal to or greater than 18, then the number of heating degrees will be zero. Normals represent the average accumulation for a given month or year.                                                                                                                                                                                                                                             |
| Soil Temperature                         | soil_temp       | Soil temperature measurements provide the climatology of soil thermal characteristics such as the depth of frost penetration into the soil and the duration that the soil remains frozen. It is of interest to hydrologists because it affects surface runoff, infiltration and snowmelt and to agriculturalists because it affects seed germination.                                                                                                                                                                                                                                                                       |
| Evaporation                              | evaporation     | Evaporation refers to the calculated lake evaporation occurring from a small natural open water-body having negligible heat storage and very little heat transfer at its bottom and sides. It represents the water loss from ponds and small reservoirs but not from lakes that have large heat storage capacities. Lake evaporation is calculated using the observed daily values of pan evaporative water loss, the mean temperatures of the water in the pan and of the nearby air, and the total wind run over the pan.                                                                                                 |
| Frost And Freezing-Free Period           | frost           | Freezing occurs whenever temperatures fall to 0 deg C or lower. Frost data normals are based on the occurrence of freezing temperatures as recorded from minimum thermometers. The “Freezing-free Period” is defined as the number of days between the last occurrence of frost in spring and first occurrence of frost in the fall for a given year. For the purposes of these calculations, “spring” is defined as days on or before July 15, “fall” is defined as days after July 15 and freezing or frost occurs on any day where the daily minimum temperature (Tmin) is observed to be less than or equal to 0 deg C. |
| Hourly Data                              | hours           | Some climate elements are observed on an hourly rather than a daily basis. For these elements, the “3 and 5” rule for completeness is inapplicable given the comprehensive volume of data. Instead, to qualify for inclusion, hourly elements must have at least 90% of all available hours for a month complete where means or “days with” statistics are calculated. As with daily elements, where average totals are calculated, the record required 100% complete data. The monthly mean was then assigned an annual code following the completeness requirements.                                                      |
| Wind                                     | wind            | Most principal climatological stations are equipped with a standard type U2A anemometer, taking one-minute or (since 1985) two-minute mean speeds values at each observation. At other wind-measuring sites, values are usually obtained from autographic records of U2A or 45B anemometers. Averaging periods at these sites may vary from one minute to an hour.                                                                                                                                                                                                                                                          |
| Bright Sunshine                          | sun             | Bright sunshine observations are made using the Campbell-Stokes sunshine recorder. It consists of a glass sphere that is 10 cm in diameter, mounted concentrically in a portion of a spherical bowl. The sun’s rays are focused by the glass sphere on a card held in position by a pair of grooves in the bowl. The focused rays scorch the card or burn a trace right through it. The card size used depends on the length of the day and is available in three classes corresponding to the time of the year equinox, summer or winter solstice.                                                                         |
| Humidex                                  | humidex         | Humidex is an index to indicate how hot or humid the weather feels to the average person. It is derived by combining temperature and humidity values into one number to reflect the perceived temperature. For example, a humidex of 40 means that the sensation of heat when the temperature is 30 degrees and the air is humid feels more or less the same as when the temperature is 40 degrees and the air is dry.                                                                                                                                                                                                      |
| Wind Chill                               | wind_chill      | Wind chill is an index to indicate how cold the weather feels to the average person. It is derived by combining temperature and wind velocity values into one number to reflect the perceived temperature. For example, if the outside temperature is -10°C and the wind chill is -20, it means that your face will feel more or less as cold as it would on a calm day when the temperature is -20°C.                                                                                                                                                                                                                      |
| Humidity                                 | humidity        | Vapour pressure is the pressure exerted by the water present in an air parcel. This pressure is one of the partial pressures that make up the total pressure exerted by an air parcel. The vapour pressure increases as the amount of water vapour increases.                                                                                                                                                                                                                                                                                                                                                               |
| Pressure                                 | pressure        | Pressure is the weight of a column of air of unit cross-sectional area extending from the level of the observing station vertically to the outer limit of the atmosphere. The standard instrument for the measurement of atmospheric pressure is the mercury barometer, in which the air pressure is balanced against the weight of a column of mercury in a glass tube that contains a vacuum.                                                                                                                                                                                                                             |
| Solar Radiation                          | rad             | Solar radiation is the measurement of radiant energy from the sun, on a horizontal surface. There are several standardized components of independent measurements. Each component is assigned a different identifying number referred to as Radiation Fields (RF). The standard metric unit of radiation measurement is the Mega Joule per square metre (MJ/m2).                                                                                                                                                                                                                                                            |
| Visibility (Km)                          | visibility      | Visibility in kilometers (km) is the distance at which objects of suitable size can be seen and identified. Precipitation, fog, haze or other obstructions such as blowing snow or dust can reduce atmospheric visibility.                                                                                                                                                                                                                                                                                                                                                                                                  |
| Cloud Amount                             | cloud           | A cloud in the atmosphere is a visible collection of minute particle matter, such as water droplets and/or ice crystals, in the air. Condensation nuclei, such as smoke or dust particles, form a surface around which water vapour can condense and create clouds.                                                                                                                                                                                                                                                                                                                                                         |

### Original names and units

These represent the original ECCC measurement names with units and their
corresponding measurements in `weathercan`.

#### Temperature

| ECCC_name           | weathercan_name       |
|:--------------------|:----------------------|
| Daily Average (C)   | temp_daily_average    |
| Standard Deviation  | temp_sd               |
| Daily Maximum (C)   | temp_daily_max        |
| Daily Minimum (C)   | temp_daily_min        |
| Extreme Maximum (C) | temp_extreme_max      |
| Date (YYYY/DD)      | temp_extreme_max_date |
| Extreme Minimum (C) | temp_extreme_min      |
| Date (YYYY/DD)      | temp_extreme_min_date |

#### Precipitation

| ECCC_name                        | weathercan_name           |
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

#### Days With Maximum Temperature

| ECCC_name | weathercan_name     |
|:----------|:--------------------|
| \<= 0 C   | temp_max_days\_\<=0 |
| \> 0 C    | temp_max_days\_\>0  |
| \> 10 C   | temp_max_days\_\>10 |
| \> 20 C   | temp_max_days\_\>20 |
| \> 30 C   | temp_max_days\_\>30 |
| \> 35 C   | temp_max_days\_\>35 |

#### Days With Minimum Temperature

| ECCC_name | weathercan_name      |
|:----------|:---------------------|
| \> 0 C    | temp_min_days\_\>0   |
| \<= 2 C   | temp_min_days\_\<=2  |
| \<= 0 C   | temp_min_days\_\<=0  |
| \< -2 C   | temp_min_days\_\<-2  |
| \< -10 C  | temp_min_days\_\<-10 |
| \< -20 C  | temp_min_days\_\<-20 |
| \< - 30 C | temp_min_days\_\<-30 |

#### Days With Rainfall

| ECCC_name  | weathercan_name   |
|:-----------|:------------------|
| \>= 0.2 mm | rain_days\_\>=0.2 |
| \>= 5 mm   | rain_days\_\>=5   |
| \>= 10 mm  | rain_days\_\>=10  |
| \>= 25 mm  | rain_days\_\>=25  |

#### Days With Snowfall

| ECCC_name  | weathercan_name   |
|:-----------|:------------------|
| \>= 0.2 cm | snow_days\_\>=0.2 |
| \>= 5 cm   | snow_days\_\>=5   |
| \>= 10 cm  | snow_days\_\>=10  |
| \>= 25 cm  | snow_days\_\>=25  |

#### Days With Precipitation

| ECCC_name  | weathercan_name     |
|:-----------|:--------------------|
| \>= 0.2 mm | precip_days\_\>=0.2 |
| \>= 5 mm   | precip_days\_\>=5   |
| \>= 10 mm  | precip_days\_\>=10  |
| \>= 25 mm  | precip_days\_\>=25  |

#### Days With Snow Depth

| ECCC_name | weathercan_name        |
|:----------|:-----------------------|
| \>= 1 cm  | snow_depth_days\_\>=1  |
| \>= 5 cm  | snow_depth_days\_\>=5  |
| \>= 10 cm | snow_depth_days\_\>=10 |
| \>= 20 cm | snow_depth_days\_\>=20 |

#### Wind

| ECCC_name                         | weathercan_name     |
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

#### Degree Days

| ECCC_name  | weathercan_name |
|:-----------|:----------------|
| Above 24 C | dd_above_24     |
| Above 18 C | dd_above_18     |
| Above 15 C | dd_above_15     |
| Above 10 C | dd_above_10     |
| Above 5 C  | dd_above_5      |
| Above 0 C  | dd_above_0      |
| Below 0 C  | dd_below_0      |
| Below 5 C  | dd_below_5      |
| Below 10 C | dd_below_10     |
| Below 15 C | dd_below_15     |
| Below 18 C | dd_below_18     |

#### Soil Temperature

| ECCC_name                    | weathercan_name  |
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

#### Evaporation

| ECCC_name             | weathercan_name  |
|:----------------------|:-----------------|
| Lake Evaporation (mm) | lake_evaporation |

#### Bright Sunshine

| ECCC_name                    | weathercan_name         |
|:-----------------------------|:------------------------|
| Total Hours                  | sun_hours               |
| Days With Measurable         | sun_measurable_days     |
| % Of Possible Daylight Hours | sun_perc_daylight_hours |
| Extreme Daily                | sun_extreme_daily       |
| Date (YYYY/DD)               | sun_extreme_daily_date  |

#### Humidex

| ECCC_name                | weathercan_name   |
|:-------------------------|:------------------|
| Extreme Humidex          | hmdx_extreme      |
| Date (YYYY/DD)           | hmdx_extreme_date |
| Days With Humidex \>= 30 | hmdx_days\_\>=30  |
| Days With Humidex \>= 35 | hmdx_days\_\>=35  |
| Days With Humidex \>= 40 | hmdx_days\_\>=40  |

#### Wind Chill

| ECCC_name                   | weathercan_name         |
|:----------------------------|:------------------------|
| Extreme Wind Chill (C)      | wind_chill_extreme      |
| Date (YYYY/DD)              | wind_chill_extreme_date |
| Days With Wind Chill \< -20 | wind_chill_days\_\<-20  |
| Days With Wind Chill \< -30 | wind_chill_days\_\<-30  |
| Days With Wind Chill \< -40 | wind_chill_days\_\<-40  |

#### Humidity

| ECCC_name                               | weathercan_name        |
|:----------------------------------------|:-----------------------|
| Average Vapour Pressure (kPa)           | humidity_mean_pressure |
| Average Relative Humidity - 0600LST (%) | humidity_mean_0600LST  |
| Average Relative Humidity - 1500LST (%) | humidity_mean_1500LST  |

#### Pressure

| ECCC_name                        | weathercan_name   |
|:---------------------------------|:------------------|
| Average Station Pressure (kPa)   | pressure_stn_mean |
| Average Sea Level Pressure (kPa) | pressure_sea_mean |

#### Radiation

| ECCC_name                       | weathercan_name                |
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

#### Visibility (Hours With)

| ECCC_name | weathercan_name |
|:----------|:----------------|
| \< 1 Km   | visibility\_\<1 |
| 1 To 9 Km | visibility_1_9  |
| \> 9 Km   | visibility\_\>9 |

#### Cloud Amount (Hours With)

| ECCC_name                                                                             | weathercan_name                       |
|:--------------------------------------------------------------------------------------|:--------------------------------------|
| 0 To 2 Tenths                                                                         | cloud_0_2                             |
| 3 To 7 Tenths                                                                         | cloud_3_7                             |
| 8 To 10 Tenths                                                                        | cloud_8_10                            |
| Average Date Of Last Spring Frost                                                     | date_last_spring_frost                |
| Average Date Of First Fall Frost                                                      | date_first_fall_frost                 |
| Average Length Of Frost-Free Period                                                   | length_frost_free                     |
| Probability Of Last Temperature In Spring Of 0 C Or Lower On Or After Indicated Dates | prob_last_spring_temp_below_0_on_date |
| Probability Of First Temperature In Fall Of 0 C Or Lower On Or Before Indicated Dates | prob_first_fall_temp_below_0_on_date  |
| Probability Of Frost-Free Period Equal To Or Less Than Indicated Period (Days)        | prob_length_frost_free                |
