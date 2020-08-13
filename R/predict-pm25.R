## Predict daily PM25 concentration from other covariates
source(here::here("R", "packages.R"))
source(here("R", "readAirPollution.R"))
source(here("R", "readFireCounts.R "))
source(here("R", "readFireCounts.R"))
source(here("R", "readAirPollutionBackground.R"))
source(here("R", "readTemperature.R"))

air_pollution <- readAirPollution(here("data", "air-pollution.xlsx"))
fire_counts <- readFireCounts(here("data", "simplified.csv"))


df <- fire_counts %>%
  left_join(air_pollution, by = "date") %>%
  mutate(week_day = weekdays(date))

lm()
df %>%
  mutate(week_day = weekdays(date))

weekdays(df$date)
