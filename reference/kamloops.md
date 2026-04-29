# Hourly weather data for Kamloops

Downloaded with
[`weather()`](https://docs.ropensci.org/weathercan/reference/weather_dl.md).
Terms are more thoroughly defined here
<https://climate.weather.gc.ca/glossary_e.html>

## Usage

``` r
kamloops
```

## Format

An example dataset of hourly weather data for Kamloops:

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

- time:

  Time

- year:

  Year

- month:

  Month

- day:

  Day

- hour:

  Hour

- qual:

  Data quality

- weather:

  The state of the atmosphere at a specific time.

- hmdx:

  Humidex

- hmdx_flag:

  Humidex data flag

- pressure:

  Pressure (kPa)

- pressure_flag:

  Pressure data flag

- rel_hum:

  Relative humidity

- rel_hum_flag:

  Relative humidity data flag

- temp:

  Temperature

- temp_dew:

  Dew Point Temperature

- temp_dew_flag:

  Dew Point Temperature flag

- visib:

  Visibility (km)

- visib_flag:

  Visibility data flag

- wind_chill:

  Wind Chill

- wind_chill_flag:

  Wind Chill flag

- wind_dir:

  Wind Direction (10's of degrees)

- wind_dir_flag:

  wind Direction Flag

- wind_spd:

  Wind speed km/hr

- wind_spd_flag:

  Wind speed flag

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
