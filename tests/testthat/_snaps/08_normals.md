# normals_dl() downloads normals/frost dates as tibble - single

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["prov", "station_name", "climate_id", "normals_years", "meets_wmo", "normals", "frost"]
        },
        "row.names": {
          "type": "integer",
          "attributes": {},
          "value": [1]
        },
        "class": {
          "type": "character",
          "attributes": {},
          "value": ["tbl_df", "tbl", "data.frame"]
        }
      },
      "value": [
        {
          "type": "character",
          "attributes": {},
          "value": ["MB"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["BRANDON A"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["5010480"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["1981-2010"]
        },
        {
          "type": "logical",
          "attributes": {},
          "value": [true]
        },
        {
          "type": "list",
          "attributes": {},
          "value": [
            {
              "type": "list",
              "attributes": {
                "names": {
                  "type": "character",
                  "attributes": {},
                  "value": ["period", "temp_daily_average", "temp_daily_average_code", "temp_sd", "temp_sd_code", "temp_daily_max", "temp_daily_max_code", "temp_daily_min", "temp_daily_min_code", "temp_extreme_max", "temp_extreme_max_code", "temp_extreme_max_date", "temp_extreme_max_date_code", "temp_extreme_min", "temp_extreme_min_code", "temp_extreme_min_date", "temp_extreme_min_date_code", "rain", "rain_code", "snow", "snow_code", "precip", "precip_code", "snow_mean_depth", "snow_mean_depth_code", "snow_median_depth", "snow_median_depth_code", "snow_depth_month_end", "snow_depth_month_end_code", "rain_extreme_daily", "rain_extreme_daily_code", "rain_extreme_daily_date", "rain_extreme_daily_date_code", "snow_extreme_daily", "snow_extreme_daily_code", "snow_extreme_daily_date", "snow_extreme_daily_date_code", "precip_extreme_daily", "precip_extreme_daily_code", "precip_extreme_daily_date", "precip_extreme_daily_date_code", "snow_extreme_depth", "snow_extreme_depth_code", "snow_extreme_depth_date", "snow_extreme_depth_date_code", "temp_max_days_<=0", "temp_max_days_<=0_code", "temp_max_days_>0", "temp_max_days_>0_code", "temp_max_days_>10", "temp_max_days_>10_code", "temp_max_days_>20", "temp_max_days_>20_code", "temp_max_days_>30", "temp_max_days_>30_code", "temp_max_days_>35", "temp_max_days_>35_code", "temp_min_days_>0", "temp_min_days_>0_code", "temp_min_days_<=2", "temp_min_days_<=2_code", "temp_min_days_<=0", "temp_min_days_<=0_code", "temp_min_days_<-2", "temp_min_days_<-2_code", "temp_min_days_<-10", "temp_min_days_<-10_code", "temp_min_days_<-20", "temp_min_days_<-20_code", "temp_min_days_<-30", "temp_min_days_<-30_code", "rain_days_>=0.2", "rain_days_>=0.2_code", "rain_days_>=5", "rain_days_>=5_code", "rain_days_>=10", "rain_days_>=10_code", "rain_days_>=25", "rain_days_>=25_code", "snow_days_>=0.2", "snow_days_>=0.2_code", "snow_days_>=5", "snow_days_>=5_code", "snow_days_>=10", "snow_days_>=10_code", "snow_days_>=25", "snow_days_>=25_code", "precip_days_>=0.2", "precip_days_>=0.2_code", "precip_days_>=5", "precip_days_>=5_code", "precip_days_>=10", "precip_days_>=10_code", "precip_days_>=25", "precip_days_>=25_code", "snow_depth_days_>=1", "snow_depth_days_>=1_code", "snow_depth_days_>=5", "snow_depth_days_>=5_code", "snow_depth_days_>=10", "snow_depth_days_>=10_code", "snow_depth_days_>=20", "snow_depth_days_>=20_code", "wind_speed", "wind_speed_code", "wind_dir", "wind_dir_code", "wind_max_speed", "wind_max_speed_code", "wind_max_speed_date", "wind_max_speed_date_code", "wind_max_speed_dir", "wind_max_speed_dir_code", "wind_max_gust", "wind_max_gust_code", "wind_max_gust_date", "wind_max_gust_date_code", "wind_max_gust_dir", "wind_max_gust_dir_code", "wind_days_>=52", "wind_days_>=52_code", "wind_days_>=63", "wind_days_>=63_code", "dd_above_24", "dd_above_24_code", "dd_above_18", "dd_above_18_code", "dd_above_15", "dd_above_15_code", "dd_above_10", "dd_above_10_code", "dd_above_5", "dd_above_5_code", "dd_above_0", "dd_above_0_code", "dd_below_0", "dd_below_0_code", "dd_below_5", "dd_below_5_code", "dd_below_10", "dd_below_10_code", "dd_below_15", "dd_below_15_code", "dd_below_18", "dd_below_18_code", "sun_hours", "sun_hours_code", "sun_measurable_days", "sun_measurable_days_code", "sun_perc_daylight_hours", "sun_perc_daylight_hours_code", "sun_extreme_daily", "sun_extreme_daily_code", "sun_extreme_daily_date", "sun_extreme_daily_date_code", "hmdx_extreme", "hmdx_extreme_code", "hmdx_extreme_date", "hmdx_extreme_date_code", "hmdx_days_>=30", "hmdx_days_>=30_code", "hmdx_days_>=35", "hmdx_days_>=35_code", "hmdx_days_>=40", "hmdx_days_>=40_code", "wind_chill_extreme", "wind_chill_extreme_code", "wind_chill_extreme_date", "wind_chill_extreme_date_code", "wind_chill_days_<-20", "wind_chill_days_<-20_code", "wind_chill_days_<-30", "wind_chill_days_<-30_code", "wind_chill_days_<-40", "wind_chill_days_<-40_code", "humidity_mean_pressure", "humidity_mean_pressure_code", "humidity_mean_0600LST", "humidity_mean_0600LST_code", "humidity_mean_1500LST", "humidity_mean_1500LST_code", "pressure_stn_mean", "pressure_stn_mean_code", "pressure_sea_mean", "pressure_sea_mean_code", "visibility_<1", "visibility_<1_code", "visibility_1_9", "visibility_1_9_code", "visibility_>9", "visibility_>9_code", "cloud_0_2", "cloud_0_2_code", "cloud_3_7", "cloud_3_7_code", "cloud_8_10", "cloud_8_10_code"]
                },
                "row.names": {
                  "type": "integer",
                  "attributes": {},
                  "value": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
                },
                "class": {
                  "type": "character",
                  "attributes": {},
                  "value": ["tbl_df", "tbl", "data.frame"]
                }
              },
              "value": [
                {
                  "type": "integer",
                  "attributes": {
                    "levels": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Year"]
                    },
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["factor"]
                    }
                  },
                  "value": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [-16.6, -13.6, -6.2, 4, 10.6, 15.9, 18.5, 17.7, 11.8, 4.1, -5.6, -14, 2.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [4.2, 4, 3.2, 2.4, 1.8, 1.8, 1.4, 1.8, 1.6, 1.8, 3.6, 4.2, 1.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [-11.1, -8.1, -1, 10.5, 17.8, 22.4, 25.2, 24.9, 18.9, 10.4, -0.5, -9, 8.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [-21.9, -19, -11.4, -2.6, 3.4, 9.3, 11.7, 10.4, 4.7, -2.2, -10.6, -19, -3.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [6.7, 13.4, 19.4, 35.1, 37.5, 37.7, 37.8, 38.5, 36.7, 30.9, 20.6, 10, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [-9478, 6631, -9052, 3763, 3794, 3450, -10392, 6792, 2440, 8309, -1521, -31, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [-45.6, -41.7, -41.7, -26.5, -12.3, -3.9, 2, -2.6, -8.3, -24.4, -35, -40.4, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [-1455, -2864, -2863, 3382, 12552, -202, 4933, 4621, -9957, 7973, 3245, 5104, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.3, 1.4, 7.4, 17, 55.5, 80.7, 73.4, 65.9, 43.7, 24.6, 4.1, 1, 374.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [22.8, 15.1, 18.9, 8.9, 3.8, 0, 0, 0, 0.2, 6, 17.2, 24.9, 117.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [17.8, 13.5, 24.6, 25.8, 59.1, 80.7, 73.4, 65.9, 43.7, 30.3, 18.7, 20.9, 474.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [21, 24, 15, 1, 0, 0, 0, 0, 0, 0, 4, 13, 7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [21, 24, 15, 0, 0, 0, 0, 0, 0, 0, 3, 13, 6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [25, 22, 6, 0, 0, 0, 0, 0, 0, 2, 8, 19, 7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [2, 15.4, 26.8, 37.1, 86.4, 80, 81.5, 80, 48, 28.4, 25.2, 13.8, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [13163, 14284, 14325, 1942, -2066, -6057, 1300, 5693, -10346, 5401, 11262, 4718, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [32, 31, 30.5, 23.2, 19.8, 0, 0, 0, 4.2, 34.3, 17.8, 19.6, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [-9840, -309, -5027, 5230, 12549, -10076, -10411, -10380, 5019, -3736, -4064, 14958, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [32, 35.3, 30.5, 37.1, 86.4, 80, 81.5, 80, 48, 34.3, 25.2, 18, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [-9840, -309, -5027, 1942, -2066, -6057, 1300, 5693, -10346, -3736, 11262, -9869, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [68, 89, 89, 53, 25, 0, 0, 0, 8, 23, 35, 50, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [12445, -307, -306, 1552, 12551, -2771, -2741, -2710, 5737, 7972, 9464, 13513, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [28, 23.4, 15.4, 2.5, 0.07, 0, 0, 0, 0, 2, 15, 27, 113.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [3, 4.8, 15.6, 27.5, 30.9, 30, 31, 31, 30, 29, 15, 4, 251.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0.03, 1.4, 15.9, 27.2, 29.9, 31, 31, 27.7, 15.8, 2.3, 0, 182.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 3.3, 11.5, 20.2, 27.7, 25.7, 12.3, 2.3, 0, 0, 103]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 0.9, 1.4, 3.3, 4.5, 0.71, 0.03, 0, 0, 10.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 0.03, 0.21, 0.07, 0.52, 0, 0, 0, 0, 0.83]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.04, 0.03, 1.2, 8.4, 23.3, 29.8, 31, 30.9, 25.4, 10.2, 0.59, 0, 160.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [31, 28.2, 30.9, 25.3, 12.3, 1.2, 0.03, 0.52, 8.7, 25.3, 29.9, 31, 224.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [31, 28.2, 29.8, 21.6, 7.7, 0.18, 0, 0.1, 4.6, 20.8, 29.4, 31, 204.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [30.9, 27.4, 27.4, 15.2, 4.4, 0.04, 0, 0.03, 1.8, 15.3, 27.6, 30.8, 181]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [27.9, 22.6, 15.7, 2.4, 0.13, 0, 0, 0, 0, 2.2, 13.6, 25.4, 109.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [17.2, 13.2, 5, 0.1, 0, 0, 0, 0, 0, 0.1, 3.2, 14, 52.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [6.5, 3.7, 0.7, 0, 0, 0, 0, 0, 0, 0, 0, 3.5, 14.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.59, 0.83, 2.8, 4.4, 10.1, 14, 11.3, 10.3, 8.5, 6.3, 1.9, 0.82, 72]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0.07, 0.43, 0.97, 3.3, 5, 3.9, 3.3, 2.5, 1.6, 0.2, 0.04, 21.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0.03, 0.2, 0.53, 1.8, 2.6, 2.3, 2.2, 1.5, 0.73, 0.07, 0.04, 12.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0.03, 0.03, 0.23, 0.53, 0.53, 0.5, 0.2, 0.1, 0.03, 0, 2.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [11.7, 8.9, 7.1, 3.3, 1.1, 0, 0, 0, 0.13, 2.3, 7.2, 10.4, 52.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [1, 0.6, 1.2, 0.6, 0.2, 0, 0, 0, 0, 0.47, 0.9, 1.5, 6.5]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.24, 0.17, 0.47, 0.23, 0.1, 0, 0, 0, 0, 0.07, 0.3, 0.43, 2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [11.1, 8.7, 8.6, 6.8, 10.9, 14, 11.3, 10.3, 8.6, 7.9, 8.1, 10.2, 116.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.72, 0.57, 1.6, 1.5, 3.6, 5, 3.9, 3.3, 2.5, 2.1, 0.97, 1.1, 26.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.1, 0.17, 0.67, 0.8, 2, 2.6, 2.3, 2.2, 1.5, 0.87, 0.3, 0.39, 13.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0.03, 0.07, 0.23, 0.53, 0.53, 0.5, 0.2, 0.13, 0.03, 0, 2.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [30.6, 27.2, 25.9, 5.3, 0.7, 0, 0, 0, 0.03, 1.8, 14.2, 27.4, 133]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [27.1, 25.5, 22, 2.9, 0.3, 0, 0, 0, 0.03, 0.86, 7.7, 22, 108.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [24.8, 24.1, 16.5, 1.5, 0.2, 0, 0, 0, 0, 0.14, 4.3, 15.7, 87.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [16.8, 15.9, 10, 0.52, 0.07, 0, 0, 0, 0, 0.07, 0.93, 9.8, 54.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [15.3, 15, 15.1, 15.9, 16.8, 14.9, 12.3, 13.2, 14.7, 15.4, 14.8, 15, 14.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["W", "W", "W", "NE", "NE", "W", "W", "W", "W", "W", "W", "W", "W"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [78, 84, 76, 80, 80, 95, 77, 72, 70, 72, 83, 70, 95]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [5854, -1776, -2117, 97, -2436, 11839, -1990, -3783, 5000, -1159, 3230, 3283, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["W", "W", "W", "W", "W", "NW", "N", "S", "W", "NW", "W", "NE", "NW"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [117, 121, 95, 115, 109, 130, 139, 119, 111, 107, 115, 98, 139]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [5854, -1776, 12487, 5230, 7811, 5637, 4205, 6430, 8651, 6482, 3229, 10950, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["NW", "W", "W", "N", "W", "W", "W", "S", "NW", "NW", "W", "NW", "W"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [1, 0.5, 0.6, 1, 1.6, 0.9, 0.7, 0.8, 0.8, 1.3, 0.7, 0.6, 10.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.2, 0.1, 0.1, 0.1, 0.4, 0.2, 0.3, 0.3, 0.3, 0.4, 0.1, 0.2, 2.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 0.2, 0.7, 1.5, 2.2, 0.1, 0, 0, 0, 4.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 5, 19.8, 47, 42.5, 5.6, 0, 0, 0, 119.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0.9, 16.5, 57.6, 114, 99.7, 20.1, 0.4, 0, 0, 309.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 11.2, 73.8, 176, 262.5, 237.4, 84.3, 8.1, 0, 0, 853.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 1.4, 53.7, 185, 323.2, 417.5, 391.7, 206.2, 50.1, 2, 0, 1630.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.2, 1.6, 16.3, 146.1, 330.3, 473.2, 572.5, 546.7, 352.1, 148.9, 18.2, 0.4, 2606.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [508.1, 383, 208.5, 27.6, 1, 0, 0, 0, 0, 22.4, 176.6, 432, 1759.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [662.9, 522.5, 348.6, 85.2, 10.7, 0, 0, 0, 4.1, 78.7, 310.4, 586.6, 2609.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [817.9, 663.5, 502.2, 192.8, 54.5, 2.9, 0, 0.6, 32.2, 191.6, 458.4, 741.6, 3658.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [972.9, 804.6, 657.2, 332.4, 152.3, 34.5, 6.5, 17.9, 118.1, 339, 608.4, 896.6, 4940.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [1065.9, 889.2, 750.2, 421.5, 233.7, 86.6, 32.5, 53.8, 193.6, 431.6, 698.4, 989.6, 5846.5]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [99.3, 131.3, 180.2, 234.6, 272.7, 271.9, 306.6, 300, 210.6, 163.5, 96.3, 91.6, 2358.5]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [22.6, 22.7, 26.4, 27.2, 28.9, 28.4, 29.9, 30.6, 27.7, 26.9, 21.4, 21.8, 314.5]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [37.2, 46.2, 49, 56.9, 57.2, 55.7, 62.3, 66.9, 55.5, 48.9, 35.3, 36.1, 50.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [8.8, 10.5, 11.7, 14.1, 15.3, 15.9, 15.8, 14.7, 12.9, 10.7, 9.5, 8, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [9526, 9554, 10316, 9612, 11107, 9650, 7500, 8251, 10106, 11233, 6148, 7639, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [5.6, 13, 18.3, 34.4, 39.7, 43.7, 47.3, 46.2, 39, 32.5, 20.1, 9.4, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [1119, 6631, 1180, 3763, 6725, 9674, 2036, 11538, 2440, -2281, 3227, -31, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 1.2, 4.9, 11.4, 10.4, 2, 0, 0, 0, 29.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 0.1, 1.4, 4.1, 3, 0.3, 0, 0, 0, 9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 0, 0.2, 0.6, 0.5, 0, 0, 0, 0, 1.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [-57.4, -56.5, -52.8, -35.6, -16.7, -7.7, 0, -6.7, -11.5, -29.4, -47.4, -57.2, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [9514, 9527, -2863, 1917, 12551, -2040, -4202, 4621, 2457, 7973, 3245, 5104, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [24.8, 19.1, 11.2, 0.8, 0, 0, 0, 0, 0, 0.7, 8.2, 21.6, 86.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [15.7, 11.2, 3.3, 0.1, 0, 0, 0, 0, 0, 0, 2.4, 11.6, 44.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [7, 3.5, 0.7, 0, 0, 0, 0, 0, 0, 0, 0.3, 3.9, 15.5]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.2, 0.2, 0.4, 0.5, 0.8, 1.3, 1.6, 1.4, 1, 0.6, 0.4, 0.2, 0.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [76.8, 78.6, 83.3, 80.8, 80, 86.5, 90.7, 90.7, 88.3, 86, 84.4, 79.7, 83.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [73.7, 73, 69.7, 48.3, 46.2, 52.6, 54.6, 50.4, 50.2, 56.1, 69.1, 74.6, 59.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [96.8, 96.8, 96.8, 96.6, 96.5, 96.4, 96.5, 96.6, 96.6, 96.6, 96.6, 96.7, 96.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [102, 102.1, 101.9, 101.7, 101.4, 101.3, 101.4, 101.5, 101.5, 101.6, 101.7, 101.9, 101.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [12.4, 19.5, 20.4, 7, 3.6, 3.2, 5.7, 5.9, 5.5, 7.8, 17.7, 20.2, 128.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [84.4, 68.7, 73, 29.9, 27.9, 19.3, 12.7, 17.8, 18, 34.4, 58.9, 88, 533]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [647.2, 589.3, 650.6, 683.1, 712.5, 697.5, 725.6, 720.3, 696.5, 701.9, 643.4, 635.7, 8103.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [224.5, 200.5, 212.5, 215.7, 182.3, 163.4, 220, 258.8, 230.6, 224.2, 188.3, 209, 2529.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [131, 128.3, 151.8, 178.9, 195.4, 214.8, 246.4, 216.6, 180.7, 154.4, 130.2, 131.8, 2060.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [388.4, 348.8, 379.8, 325.4, 366.4, 341.9, 277.6, 268.6, 308.7, 365.5, 401.6, 403.2, 4175.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                }
              ]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {},
          "value": [
            {
              "type": "list",
              "attributes": {
                "names": {
                  "type": "character",
                  "attributes": {},
                  "value": ["frost_code", "date_first_fall_frost", "date_last_spring_frost", "length_frost_free", "prob", "prob_first_fall_temp_below_0_on_date", "prob_length_frost_free", "prob_last_spring_temp_below_0_on_date"]
                },
                "row.names": {
                  "type": "integer",
                  "attributes": {},
                  "value": [1, 2, 3, 4, 5, 6, 7]
                },
                "class": {
                  "type": "character",
                  "attributes": {},
                  "value": ["tbl_df", "tbl", "data.frame"]
                }
              },
              "value": [
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["C", "C", "C", "C", "C", "C", "C"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [257, 257, 257, 257, 257, 257, 257]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [137, 137, 137, 137, 137, 137, 137]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [119, 119, 119, 119, 119, 119, 119]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["10%", "25%", "33%", "50%", "66%", "75%", "90%"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [241, 252, 254, 257, 261, 262, 267]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [94, 99, 104, 111, 124, 126, 141]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [158, 151, 147, 142, 137, 132, 125]
                }
              ]
            }
          ]
        }
      ]
    }

---

    {
      "type": "list",
      "attributes": {
        "names": {
          "type": "character",
          "attributes": {},
          "value": ["prov", "station_name", "climate_id", "normals_years", "meets_wmo", "normals", "frost"]
        },
        "row.names": {
          "type": "integer",
          "attributes": {},
          "value": [1]
        },
        "class": {
          "type": "character",
          "attributes": {},
          "value": ["tbl_df", "tbl", "data.frame"]
        }
      },
      "value": [
        {
          "type": "character",
          "attributes": {},
          "value": ["MB"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["BRANDON A"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["5010480"]
        },
        {
          "type": "character",
          "attributes": {},
          "value": ["1971-2000"]
        },
        {
          "type": "logical",
          "attributes": {},
          "value": [true]
        },
        {
          "type": "list",
          "attributes": {},
          "value": [
            {
              "type": "list",
              "attributes": {
                "names": {
                  "type": "character",
                  "attributes": {},
                  "value": ["period", "temp_daily_average", "temp_daily_average_code", "temp_sd", "temp_sd_code", "temp_daily_max", "temp_daily_max_code", "temp_daily_min", "temp_daily_min_code", "temp_extreme_max", "temp_extreme_max_code", "temp_extreme_max_date", "temp_extreme_max_date_code", "temp_extreme_min", "temp_extreme_min_code", "temp_extreme_min_date", "temp_extreme_min_date_code", "rain", "rain_code", "snow", "snow_code", "precip", "precip_code", "snow_mean_depth", "snow_mean_depth_code", "snow_median_depth", "snow_median_depth_code", "snow_depth_month_end", "snow_depth_month_end_code", "rain_extreme_daily", "rain_extreme_daily_code", "rain_extreme_daily_date", "rain_extreme_daily_date_code", "snow_extreme_daily", "snow_extreme_daily_code", "snow_extreme_daily_date", "snow_extreme_daily_date_code", "precip_extreme_daily", "precip_extreme_daily_code", "precip_extreme_daily_date", "precip_extreme_daily_date_code", "snow_extreme_depth", "snow_extreme_depth_code", "snow_extreme_depth_date", "snow_extreme_depth_date_code", "temp_max_days_<=0", "temp_max_days_<=0_code", "temp_max_days_>0", "temp_max_days_>0_code", "temp_max_days_>10", "temp_max_days_>10_code", "temp_max_days_>20", "temp_max_days_>20_code", "temp_max_days_>30", "temp_max_days_>30_code", "temp_max_days_>35", "temp_max_days_>35_code", "temp_min_days_>0", "temp_min_days_>0_code", "temp_min_days_<=2", "temp_min_days_<=2_code", "temp_min_days_<=0", "temp_min_days_<=0_code", "temp_min_days_<-2", "temp_min_days_<-2_code", "temp_min_days_<-10", "temp_min_days_<-10_code", "temp_min_days_<-20", "temp_min_days_<-20_code", "temp_min_days_<-30", "temp_min_days_<-30_code", "rain_days_>=0.2", "rain_days_>=0.2_code", "rain_days_>=5", "rain_days_>=5_code", "rain_days_>=10", "rain_days_>=10_code", "rain_days_>=25", "rain_days_>=25_code", "snow_days_>=0.2", "snow_days_>=0.2_code", "snow_days_>=5", "snow_days_>=5_code", "snow_days_>=10", "snow_days_>=10_code", "snow_days_>=25", "snow_days_>=25_code", "precip_days_>=0.2", "precip_days_>=0.2_code", "precip_days_>=5", "precip_days_>=5_code", "precip_days_>=10", "precip_days_>=10_code", "precip_days_>=25", "precip_days_>=25_code", "snow_depth_days_>=1", "snow_depth_days_>=1_code", "snow_depth_days_>=5", "snow_depth_days_>=5_code", "snow_depth_days_>=10", "snow_depth_days_>=10_code", "snow_depth_days_>=20", "snow_depth_days_>=20_code", "wind_speed", "wind_speed_code", "wind_dir", "wind_dir_code", "wind_max_speed", "wind_max_speed_code", "wind_max_speed_date", "wind_max_speed_date_code", "wind_max_gust", "wind_max_gust_code", "wind_max_gust_date", "wind_max_gust_date_code", "wind_max_gust_dir", "wind_max_gust_dir_code", "wind_days_>=52", "wind_days_>=52_code", "wind_days_>=63", "wind_days_>=63_code", "dd_above_24", "dd_above_24_code", "dd_above_18", "dd_above_18_code", "dd_above_15", "dd_above_15_code", "dd_above_10", "dd_above_10_code", "dd_above_5", "dd_above_5_code", "dd_above_0", "dd_above_0_code", "dd_below_0", "dd_below_0_code", "dd_below_5", "dd_below_5_code", "dd_below_10", "dd_below_10_code", "dd_below_15", "dd_below_15_code", "dd_below_18", "dd_below_18_code", "sun_extreme_daily", "sun_extreme_daily_code", "sun_extreme_daily_date", "sun_extreme_daily_date_code", "hmdx_extreme", "hmdx_extreme_code", "hmdx_extreme_date", "hmdx_extreme_date_code", "hmdx_days_>=30", "hmdx_days_>=30_code", "hmdx_days_>=35", "hmdx_days_>=35_code", "hmdx_days_>=40", "hmdx_days_>=40_code", "wind_chill_extreme", "wind_chill_extreme_code", "wind_chill_extreme_date", "wind_chill_extreme_date_code", "wind_chill_days_<-20", "wind_chill_days_<-20_code", "wind_chill_days_<-30", "wind_chill_days_<-30_code", "wind_chill_days_<-40", "wind_chill_days_<-40_code", "humidity_mean_pressure", "humidity_mean_pressure_code", "humidity_mean_0600LST", "humidity_mean_0600LST_code", "humidity_mean_1500LST", "humidity_mean_1500LST_code", "pressure_stn_mean", "pressure_stn_mean_code", "pressure_sea_mean", "pressure_sea_mean_code", "visibility_<1", "visibility_<1_code", "visibility_1_9", "visibility_1_9_code", "visibility_>9", "visibility_>9_code", "cloud_0_2", "cloud_0_2_code", "cloud_3_7", "cloud_3_7_code", "cloud_8_10", "cloud_8_10_code"]
                },
                "row.names": {
                  "type": "integer",
                  "attributes": {},
                  "value": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
                },
                "class": {
                  "type": "character",
                  "attributes": {},
                  "value": ["tbl_df", "tbl", "data.frame"]
                }
              },
              "value": [
                {
                  "type": "integer",
                  "attributes": {
                    "levels": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Year"]
                    },
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["factor"]
                    }
                  },
                  "value": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [-18, -13.8, -6.4, 3.5, 11.4, 16.1, 18.4, 17.5, 11.4, 4.4, -6.1, -14.9, 1.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [4.2, 4.3, 3.7, 2.7, 2.1, 1.7, 1.5, 1.8, 1.4, 1.6, 3.5, 4.2, 1.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [-12.6, -8.2, -1.1, 9.8, 18.6, 22.8, 25.2, 24.8, 18.3, 10.8, -1.1, -9.7, 8.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [-23.5, -19.3, -11.8, -2.9, 4.1, 9.3, 11.4, 10.1, 4.4, -2.1, -11.1, -20, -4.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [8.6, 13.4, 19.4, 35.1, 37.5, 37.7, 37.8, 38.5, 36.7, 30.9, 20.6, 10, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [11343, 6631, -9052, 3763, 3794, 3450, -10392, 6792, 2440, 8309, -1521, -31, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [-45.6, -41.7, -41.7, -26.5, -11, -3.9, 2, -2.6, -8.3, -24.4, -35, -40.4, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [-1455, -2864, -2863, 3382, 4882, -202, 4933, 4621, -9957, 7973, 3245, 5104, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.2, 0.7, 5.1, 20.1, 50.1, 74.4, 75.8, 69.2, 49.9, 22.2, 4.2, 1.2, 373.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [22.1, 15.6, 18.1, 10.7, 2.7, 0, 0, 0, 0.3, 5.8, 15.9, 21, 112]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [18, 14.1, 22.2, 31, 52.7, 74.4, 75.8, 69.2, 50.1, 27.7, 17.7, 19.2, 472]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [18, 20, 13, 2, 0, 0, 0, 0, 0, 0, 4, 11, 6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [18, 20, 13, 1, 0, 0, 0, 0, 0, 0, 4, 10, 6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [22, 19, 6, 0, 0, 0, 0, 0, 0, 2, 7, 15, 6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.9, 7.6, 21.1, 37.1, 86.4, 80, 81.5, 80, 48, 28.4, 25.2, 13.8, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [9140, 11012, -9048, 1942, -2066, -6057, 1300, 5693, -10346, 5401, 11262, 4718, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [32, 31, 30.5, 23.2, 19, 0, 0, 0, 4.2, 34.3, 17.8, 18.6, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [-9840, -309, -5027, 5230, 10352, -10076, -10411, -10380, 5019, -3736, -4064, 8016, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [32, 35.3, 30.5, 37.1, 86.4, 80, 81.5, 80, 48, 34.3, 25.2, 18, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [-9840, -309, -5027, 1942, -2066, -6057, 1300, 5693, -10346, -3736, 11262, -9869, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [48, 89, 89, 53, 11, 0, 0, 0, 8, 23, 35, 48, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [1491, -307, -306, 1552, 10353, -2771, -2741, -2710, 5737, 7972, 9464, 9469, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [28.7, 23.1, 15.4, 2.7, 0.07, 0, 0, 0, 0, 2, 16.3, 27.2, 115.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [2.3, 5.1, 15.6, 27.3, 30.9, 30, 31, 31, 30, 29, 13.8, 3.8, 249.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0.03, 1.5, 14.2, 27.4, 29.9, 31, 31, 27.2, 16.8, 2, 0, 181]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 3, 13, 21, 28, 25.8, 11.1, 2.8, 0.04, 0, 104.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0.1, 1.5, 1.8, 3.4, 4.3, 0.82, 0.04, 0, 0, 11.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0.03, 0.1, 0.21, 0.1, 0.38, 0.11, 0, 0, 0, 0.93]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.03, 0.03, 0.97, 8.1, 24.4, 29.8, 31, 30.9, 24.8, 11.1, 0.5, 0, 161.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [31, 28.2, 30.8, 25.8, 10.8, 1.2, 0.03, 0.69, 9.2, 24.8, 29.8, 31, 223.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [31, 28.2, 30, 21.9, 6.6, 0.21, 0, 0.1, 5.2, 19.9, 29.5, 31, 203.5]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [31, 27.5, 27.4, 15.2, 3.4, 0.04, 0, 0.03, 2.1, 14.6, 27.9, 30.8, 180.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [28.9, 23, 15.8, 2.8, 0.07, 0, 0, 0, 0, 2.3, 14.3, 26.2, 113.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [19.8, 13.6, 5.6, 0.38, 0, 0, 0, 0, 0, 0.11, 3.7, 15.4, 58.5]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [7.7, 3.5, 0.8, 0, 0, 0, 0, 0, 0, 0, 0.14, 4.1, 16.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.4, 0.7, 2.4, 4.5, 9.5, 12.6, 11.5, 9.9, 8.9, 6, 2.1, 0.76, 69.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0.03, 0.33, 1.1, 3.2, 4.7, 4.1, 3.3, 2.8, 1.3, 0.21, 0.07, 21.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0.1, 0.67, 1.5, 2.6, 2.3, 2.2, 1.8, 0.59, 0.07, 0.03, 11.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0.1, 0.23, 0.4, 0.53, 0.6, 0.23, 0.1, 0.03, 0, 2.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [11.7, 8.4, 7.3, 3.7, 0.87, 0, 0, 0, 0.23, 2.1, 7.3, 9.8, 51.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [1, 0.77, 1.2, 0.77, 0.13, 0, 0, 0, 0, 0.41, 0.97, 1.2, 6.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.2, 0.2, 0.3, 0.2, 0.03, 0, 0, 0, 0, 0.03, 0.17, 0.21, 1.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [11.5, 8.4, 8.7, 7.2, 10, 12.6, 11.5, 9.9, 9, 7.5, 8.1, 9.8, 114.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.73, 0.6, 1.6, 1.9, 3.5, 4.7, 4.1, 3.3, 2.9, 1.8, 1.1, 1, 27.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.1, 0.17, 0.4, 0.9, 1.6, 2.6, 2.3, 2.2, 1.8, 0.69, 0.24, 0.21, 13.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0.13, 0.23, 0.4, 0.53, 0.6, 0.23, 0.14, 0.03, 0, 2.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [30.6, 27.1, 23.9, 6, 0.47, 0, 0, 0, 0.03, 1.6, 14.7, 27.1, 131.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [27.2, 25, 19.7, 3.9, 0.13, 0, 0, 0, 0.03, 0.89, 8.7, 20.8, 106.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [23.6, 23.3, 14.4, 2.5, 0.03, 0, 0, 0, 0, 0.14, 4.8, 13.7, 82.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [13.8, 13.8, 8.3, 1.5, 0, 0, 0, 0, 0, 0.07, 0.9, 6.5, 44.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [15.6, 15.2, 15.5, 16.5, 16.8, 15.3, 12.8, 13.1, 15.1, 15.6, 14.9, 15.5, 15.2]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["W", "W", "W", "NE", "E", "NW", "NW", "NW", "W", "NW", "W", "W", "W"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [78, 84, 76, 80, 80, 95, 77, 72, 70, 72, 83, 70, 95]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [5854, -1776, -2117, 97, -2436, 11839, -1990, -3783, 5000, -1159, 3230, 3283, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [117, 121, 91, 115, 109, 130, 139, 119, 111, 107, 115, 98, 139]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [5854, -1776, 2644, 5230, 7811, 5637, 4205, 6430, 8651, 6482, 3229, 10950, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["NW", "W", "NE", "N", "W", "W", "W", "S", "NW", "NW", "W", "NW", "W"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.9, 0.4, 0.6, 1.1, 1.4, 1, 0.7, 0.7, 0.9, 1.2, 0.9, 0.7, 10.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.2, 0, 0.2, 0.2, 0.3, 0.3, 0.3, 0.3, 0.3, 0.4, 0.3, 0.2, 3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 0.5, 0.7, 1.2, 1.6, 0.1, 0, 0, 0, 4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0.2, 8.6, 21.7, 44.6, 39.1, 4.3, 0, 0, 0, 118.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 1.4, 23.9, 60.9, 111.1, 94.6, 15.9, 0.2, 0, 0, 307.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 11.1, 89.5, 181.5, 259.5, 231, 75, 8.2, 0.1, 0, 855.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 1.5, 48.7, 205.2, 329, 414.5, 385.3, 193.2, 54.3, 2.1, 0, 1633.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.1, 1.6, 16.8, 137.4, 352.6, 479, 569.5, 540.3, 338.4, 157.4, 16.3, 0.4, 2609.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [556, 389.2, 216, 32.6, 0.5, 0, 0, 0, 0.1, 21.8, 191.8, 459.5, 1867.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [710.9, 528.8, 355.7, 93.9, 8.2, 0, 0, 0, 4.9, 73.6, 327.6, 614.1, 2717.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [865.9, 670, 509.2, 206.3, 47.4, 2.6, 0, 0.7, 36.7, 182.5, 475.6, 769.1, 3766]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [1020.9, 811.2, 664.2, 346.6, 136.9, 32, 6.6, 19.3, 127.6, 329.6, 625.5, 924.1, 5044.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [1113.9, 895.9, 757.2, 435.5, 214.5, 82.8, 33.1, 56.8, 206.1, 422.4, 715.5, 1017.1, 5950.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [8.8, 10.5, 11.7, 14.1, 15.3, 15.9, 15.8, 14.7, 12.9, 10.7, 9.5, 8, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D", "D"]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [9526, 9554, 10316, 9612, 11107, 9650, 7500, 8251, 10106, 11233, 6148, 7639, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [5.6, 13, 18.3, 34.4, 39.7, 43.7, 47.3, 46.2, 39, 32.5, 20.1, 9.4, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [1119, 6631, 1180, 3763, 6725, 9674, 2036, 11538, 2440, -2281, 3227, -31, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0.1, 2, 5.3, 10.4, 9.8, 1.3, 0, 0, 0, 28.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 0.3, 1.3, 3.6, 2.8, 0.3, 0, 0, 0, 8.3]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0, 0, 0, 0, 0, 0.1, 0.6, 0.3, 0, 0, 0, 0, 1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [-57.4, -56.5, -52.8, -35.6, -16.2, -7.7, -0.6, -6.7, -11.5, -29.4, -47.4, -57.2, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {
                    "class": {
                      "type": "character",
                      "attributes": {},
                      "value": ["Date"]
                    }
                  },
                  "value": [9514, 9527, -2863, 1917, -975, -2040, -913, 4621, 2457, 7973, 3245, 5104, "NA"]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": [null, null, null, null, null, null, null, null, null, null, null, null, null]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [26.3, 19.5, 11.5, 1.1, 0, 0, 0, 0, 0, 0.7, 9.3, 22.3, 90.8]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [18, 11.7, 4, 0.3, 0, 0, 0, 0, 0, 0, 2.6, 13.2, 49.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [8.3, 3.4, 0.8, 0, 0, 0, 0, 0, 0, 0, 0.5, 5.1, 18.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [0.2, 0.2, 0.4, 0.5, 0.8, 1.2, 1.5, 1.4, 1, 0.6, 0.4, 0.2, 0.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [74.3, 77.8, 81.9, 79.9, 78.9, 84.7, 89.9, 89.6, 87.3, 84.2, 83.1, 78.4, 82.5]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [71.6, 72.5, 68, 49.8, 44.8, 50.7, 53.1, 49.6, 50.8, 54.4, 68.9, 73.2, 58.9]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [96.8, 96.8, 96.7, 96.7, 96.5, 96.4, 96.5, 96.6, 96.6, 96.6, 96.6, 96.7, 96.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [102, 102, 101.8, 101.7, 101.4, 101.2, 101.4, 101.5, 101.5, 101.6, 101.8, 101.9, 101.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A", "A"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [12.4, 20.4, 19.5, 6.6, 2.3, 2.4, 3.6, 4.4, 3.5, 6.6, 14.6, 21, 117.4]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [94.2, 75.3, 76.4, 40.2, 27.3, 17.8, 14.2, 19, 24.3, 33.5, 63.6, 93.4, 579.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [637.5, 582.6, 648.1, 673.2, 714.4, 699.8, 726.2, 720.6, 692.2, 703.8, 641.9, 629.6, 8069.7]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [239.5, 198.6, 222.5, 225, 194.9, 177.6, 234.5, 246.6, 223.2, 227, 180.9, 223.3, 2593.5]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [138.3, 130.3, 149.8, 174, 207.9, 230.3, 251.3, 234.7, 178.3, 164.3, 132.4, 132.9, 2124.6]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                },
                {
                  "type": "double",
                  "attributes": {},
                  "value": [366.2, 349.3, 371.7, 321, 341.3, 312.1, 258.2, 262.7, 318.5, 352.8, 406.6, 387.8, 4048.1]
                },
                {
                  "type": "character",
                  "attributes": {},
                  "value": ["B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B", "B"]
                }
              ]
            }
          ]
        },
        {
          "type": "list",
          "attributes": {},
          "value": [
            {
              "type": "list",
              "attributes": {
                "names": {
                  "type": "character",
                  "attributes": {},
                  "value": []
                },
                "row.names": {
                  "type": "integer",
                  "attributes": {},
                  "value": []
                },
                "class": {
                  "type": "character",
                  "attributes": {},
                  "value": ["tbl_df", "tbl", "data.frame"]
                }
              },
              "value": []
            }
          ]
        }
      ]
    }

