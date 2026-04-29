# Daily weather data for Kamloops

Downloaded with
[`weather()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md).
Terms are more thoroughly defined here
<https://climate.weather.gc.ca/glossary_e.html>

## Usage

``` r
kamloops_day
```

## Format

An example dataset of daily weather data for Kamloops:

- station_name:

  Station name

- station_id:

  Environment Canada's station ID number. Required for downloading
  station data.

- prov:

  Province

- lat:

  Latitude of station location in degree decimal format

- lon:

  Longitude of station location in degree decimal format

- date:

  Date

- year:

  Year

- month:

  Month

- day:

  Day

- cool_deg_days:

  Cool degree days

- cool_deg_days_flag:

  Cool degree days flag

- dir_max_gust:

  Direction of max wind gust

- dir_max_gust_flag:

  Direction of max wind gust flag

- heat_deg_days:

  Heat degree days

- heat_deg_days_flag:

  Heat degree days flag

- max_temp:

  Maximum temperature

- max_temp_flag:

  Maximum temperature flag

- mean_temp:

  Mean temperature

- mean_temp_flag:

  Mean temperature flag

- min_temp:

  Minimum temperature

- min_temp_flag:

  Minimum temperature flag

- snow_grnd:

  Snow on the ground (cm)

- snow_grnd_flag:

  Snow on the ground flag

- spd_max_gust:

  Speed of the max gust km/h

- spd_max_gust_flag:

  Speed of the max gust flag

- total_precip:

  Total precipitation (any form)

- total_precip_flag:

  Total precipitation flag

- total_rain:

  Total rain (any form)

- total_rain_flag:

  Total rain flag

- total_snow:

  Total snow (any form)

- total_snow_flag:

  Total snow flag

- elev:

  Elevation (m)

- climate_id:

  Climate identifier

- WMO_id:

  World Meteorological Organization Identifier

- TC_id:

  Transport Canada Identifier

## Source

<https://climate.weather.gc.ca/index_e.html>
