# Weather: Terms and Units

This table shows details regarding original column (measurement) names
and units of all weather measurements. It further provides links back to
the ECCC glossary for more details.

For details on climate normals measurements, see the
`[glossary_normals](glossary_normals.html)` vignette.

| Interval | ECCC variable | weathercan variable | units | Reference |
|:---|:---|:---|:---|:---|
| hour | Date/Time (LST) | time | ISO date/time | NA |
| hour | Year | year | year | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#dataInt) |
| hour | Month | month | month | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#dataInt) |
| hour | Day | day | day | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#dataInt) |
| hour | Time (LST) | hour | hour | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#dataInt) |
| hour | Flag | qual | note | [ECCC glossary page](https://climate.weather.gc.ca/climate_data/data_quality_e.html) |
| hour | Temp (C) | temp | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#temp) |
| hour | Temp Flag | temp_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| hour | Dew Point Temp (C) | temp_dew | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#dewPnt) |
| hour | Dew Point Temp Flag | temp_dew_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| hour | Rel Hum (%) | rel_hum | % | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#r_humidity) |
| hour | Rel Hum Flag | rel_hum_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| hour | Precip. Amount (mm) | precip_amt | mm | NA |
| hour | Precip. Amount Flag | precip_amt_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| hour | Wind Dir (10s deg) | wind_dir | 10s deg | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#windDir) |
| hour | Wind Dir Flag | wind_dir_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| hour | Wind Spd (km/h) | wind_spd | km/h | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#windSpd) |
| hour | Wind Spd Flag | wind_spd_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| hour | Visibility (km) | visib | km | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#visibility) |
| hour | Visibility Flag | visib_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| hour | Stn Press (kPa) | pressure | kPa | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#stnPre) |
| hour | Stn Press Flag | pressure_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| hour | Hmdx | hmdx | index | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#humidex) |
| hour | Hmdx Flag | hmdx_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| hour | Wind Chill | wind_chill | index | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#windChill) |
| hour | Wind Chill Flag | wind_chill_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| hour | Weather | weather | note | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#weatherState) |
| day | Date/Time | date | ISO date | NA |
| day | Year | year | year | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#dataInt) |
| day | Month | month | month | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#dataInt) |
| day | Day | day | day | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#dataInt) |
| day | Data Quality | qual | note | [ECCC glossary page](https://climate.weather.gc.ca/climate_data/data_quality_e.html) |
| day | Max Temp (C) | max_temp | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#maxTemp) |
| day | Max Temp Flag | max_temp_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| day | Min Temp (C) | min_temp | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#minTemp) |
| day | Min Temp Flag | min_temp_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| day | Mean Temp (C) | mean_temp | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#meanTemp) |
| day | Mean Temp Flag | mean_temp_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| day | Heat Deg Days (C) | heat_deg_days | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#hdd) |
| day | Heat Deg Days Flag | heat_deg_days_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| day | Cool Deg Days (C) | cool_deg_days | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#cooling) |
| day | Cool Deg Days Flag | cool_deg_days_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| day | Total Rain (mm) | total_rain | mm | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#totalRain) |
| day | Total Rain Flag | total_rain_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| day | Total Snow (cm) | total_snow | cm | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#totalSnow) |
| day | Total Snow Flag | total_snow_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| day | Total Precip (mm) | total_precip | mm | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#totalPrec) |
| day | Total Precip Flag | total_precip_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| day | Snow on Grnd (cm) | snow_grnd | cm | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#s_onGround) |
| day | Snow on Grnd Flag | snow_grnd_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| day | Dir of Max Gust (10s deg) | dir_max_gust | 10s deg | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#d_maxGust) |
| day | Dir of Max Gust Flag | dir_max_gust_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| day | Spd of Max Gust (km/h) | spd_max_gust | km/h | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#s_maxGust) |
| day | Spd of Max Gust Flag | spd_max_gust_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Date/Time | date | ISO date | NA |
| month | Year | year | year | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#dataInt) |
| month | Month | month | month | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#dataInt) |
| month | Mean Max Temp (C) | mean_max_temp | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#meanMax) |
| month | Mean Max Temp Flag | mean_max_temp_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Mean Min Temp (C) | mean_min_temp | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#meanMin) |
| month | Mean Min Temp Flag | mean_min_temp_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Mean Temp (C) | mean_temp | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#meanTemp) |
| month | Mean Temp Flag | mean_temp_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Extr Max Temp (C) | extr_max_temp | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#extreme_maxtemp) |
| month | Extr Max Temp Flag | extr_max_temp_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Extr Min Temp (C) | extr_min_temp | C | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#extreme_mintemp) |
| month | Extr Min Temp Flag | extr_min_temp_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Total Rain (mm) | total_rain | mm | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#totalRain) |
| month | Total Rain Flag | total_rain_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Total Snow (cm) | total_snow | cm | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#totalSnow) |
| month | Total Snow Flag | total_snow_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Total Precip (mm) | total_precip | mm | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#totalPrec) |
| month | Total Precip Flag | total_precip_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Snow Grnd Last Day (cm) | snow_grnd_last_day | cm | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#s_lastDay) |
| month | Snow Grnd Last Day Flag | snow_grnd_last_day_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Dir of Max Gust (10’s deg) | dir_max_gust | 10’s deg | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#d_maxGust) |
| month | Dir of Max Gust Flag | dir_max_gust_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
| month | Spd of Max Gust (km/h) | spd_max_gust | km/h | [ECCC glossary page](https://climate.weather.gc.ca/glossary_e.html#s_maxGust) |
| month | Spd of Max Gust Flag | spd_max_gust_flag | note | [See the ‘flags’ vignette](https://docs.ropensci.org/weathercan/articles/flags.md) |
