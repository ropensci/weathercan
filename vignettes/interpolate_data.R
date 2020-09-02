## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(cache = FALSE)
old <- options(tibble.max_extra_cols = 0)

## ----pck, message = FALSE-----------------------------------------------------
library(weathercan)
library(ggplot2)
library(dplyr)

## -----------------------------------------------------------------------------
glimpse(kamloops)

## -----------------------------------------------------------------------------
glimpse(finches)

## ---- out.width = "100%", fig.width = 8, dpi = 200----------------------------
finches_temperature <- weather_interp(data = finches, weather = kamloops, cols = "temp")
summary(finches_temperature)
glimpse(finches_temperature)

ggplot(data = finches_temperature, aes(x = temp, fill = animal_id)) +
  theme_bw() +
  theme(legend.position = "none") + 
  geom_histogram(binwidth = 1) +
  labs(x = "Temperature (C)", y = "Activity Count", fill = "Finch ID")

## ---- out.width = "100%", fig.width = 8, dpi = 200----------------------------
finches_temperature <- finches_temperature %>%
  group_by(date) %>%
  summarize(n = length(time),
            temp = mean(temp))

ggplot(data = finches_temperature, aes(x = date, y = n)) +
  theme_bw() +
  theme(legend.position = "top") +
  geom_point(aes(shape = "Activity")) +
  geom_line(aes(y = temp * 100, colour = "Temperature")) +
  scale_colour_discrete(name = "") +
  scale_shape_discrete(name = "") +
  scale_y_continuous(name = "Activity", sec.axis = sec_axis(~. / 100, name = "Temperature (C)"))

## -----------------------------------------------------------------------------
finches_temperature <- weather_interp(data = finches, weather = kamloops, 
                                      cols = "temp", na_gap = 1)
summary(finches_temperature)

finches_temperature %>% 
  select(date, time, temp) %>%
  filter(is.na(temp))

kamloops %>%
  select(time, temp) %>%
  filter(is.na(temp))

## ---- out.width = "100%", fig.width = 8, dpi = 200----------------------------
finches_weather <- weather_interp(data = finches, weather = kamloops,
                                  cols = c("temp", "wind_spd"))
summary(finches_weather)
glimpse(finches_weather)


finches_weather <- finches_weather %>%
  group_by(date) %>%
  summarize(n = length(time),
            temp = mean(temp),
            wind_spd = mean(wind_spd))

ggplot(data = finches_weather, aes(x = date, y = n)) +
  theme_bw() +
  theme(legend.position = "top") +
  geom_bar(stat = "identity") +
  geom_line(aes(y = temp * 50, colour = "Temperature"), size = 2) +
  geom_line(aes(y = wind_spd * 50, colour = "Wind Speed"), size = 2) +
  scale_colour_discrete(name = "") +
  scale_y_continuous(name = "Activity Counts", sec.axis = sec_axis(~. / 50, name = "Temperature (C) / Wind Speed (km/h)"))

## ---- include = FALSE---------------------------------------------------------
# Reset options
options(old)

