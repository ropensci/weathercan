# data-raw/prepare_normals_1991_2020.R
# Add 1991–2020 normals flags to stations data

library(readr)
library(dplyr)
library(weathercan)

# 1. Read ECCC station inventory (update path as needed)
station_inventory <- read_csv(
  "C:/Users/oyshi/Downloads/Canadian_Climate_Normals_1991_2020_station_inventory.csv"
)

# 2. Clean normals inventory (no STN_ID in this file yet)
cleaned_normals <- station_inventory %>%
  select(
    COMPOSITE_STATION_NAME,
    STATION_NAME,
    NORMALS_CODE,
    CLIMATE_ID,
    WMO_IDENTIFIER,
    TC_IDENTIFIER,
    PROVINCE_OR_TERRITORY,
    LATITUDE,
    LONGITUDE,
    `ELEVATION(m)`
  ) %>%
  rename(
    composite_station = COMPOSITE_STATION_NAME,
    station_name      = STATION_NAME,
    normals_code      = NORMALS_CODE,
    climate_id        = CLIMATE_ID,
    wmo_id            = WMO_IDENTIFIER,
    tc_id             = TC_IDENTIFIER,
    prov_terr         = PROVINCE_OR_TERRITORY,
    lat               = LATITUDE,
    lon               = LONGITUDE,
    elev              = `ELEVATION(m)`
  ) %>%
  mutate(
    climate_id        = as.character(climate_id),
    normals_1991_2020 = !is.na(normals_code),
    has_normals       = !is.na(normals_code)
  )

# 3. Start from existing stations() output
current_stations <- weathercan::stations()

# 4. Make sure climate_id is character and keep one row per id
stations_unique <- current_stations %>%
  mutate(climate_id = as.character(climate_id)) %>%
  group_by(climate_id) %>%
  summarise(
    prov         = first(prov),
    station_name = first(station_name),
    station_id   = first(station_id),
    WMO_id       = first(WMO_id),
    TC_id        = first(TC_id),
    lat          = first(lat),
    lon          = first(lon),
    elev         = first(elev),
    tz           = first(tz),
    interval     = first(interval),
    start        = first(start),
    end          = first(end),
    .groups      = "drop"
  )

# 5. Join normals info onto stations
stations <- stations_unique %>%
  left_join(
    cleaned_normals %>%
      select(climate_id, normals_code, normals_1991_2020),
    by = "climate_id"
  ) %>%
  mutate(
    has_normals       = ifelse(is.na(normals_code), FALSE, TRUE),
    normals_1991_2020 = coalesce(normals_1991_2020, FALSE)
  )

# 6. Save updated stations dataset in package
usethis::use_data(stations, overwrite = TRUE)
