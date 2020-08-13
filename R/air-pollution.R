
source(here::here("R", "packages.R"))
source(here("R", "readAirPollution.R"))
source(here("R", "readAirPollutionBackground.R"))
source(here("R", "readFireCounts.R"))


airpollution <- readAirPollution(here("data", "air-pollution.xlsx"))
background <- readAirPollutionBackground(here("data", "PM25_hist_HPA.xlsx")) %>%
  rename(pm25_background = pm25)
fires <- readFireCounts(here("data", "simplified.csv"))

summary(airpollution)
summary(background)

df <- airpollution %>%
  left_join(background, by = "date") %>%
  mutate(
    week_day = weekdays(date),
    month = month(date),
    season = ifelse(month %in% 5:10, "dry", "wet"),
    weekend = ifelse(week_day %in% c("Saturday", "Sunday"), TRUE, FALSE)
  ) %>%
  left_join(fires %>% select(date, n), by = "date") %>%
  rename(fires = n)

df %>%
  pivot_longer(
    cols = starts_with("pm25"),
    names_to = "background",
    values_to = "pm25"
  ) %>%
  select(date, pm25, background, station) %>%
  distinct()


png(width = 680)
ggplot(df) +
  geom_line(aes(date, pm25, color = "#DD5C50")) +
  geom_line(aes(date, pm25_background, color = "grey37")) +
  facet_wrap(~station, nrow = 2) +
  labs(
    title = "Association between SUMA (red) and background stations (grey)")
dev.off()

df %>%
  drop_na() %>%
  group_by(station) %>%
  summarize(corr = cor(pm25, pm25_background))

## Check if there is difference in ap on the weekends
df %>%
  group_by(weekend) %>%
  summarize(
    pm25_avg = mean(pm25),
    pm25_station = mean(pm25_background, na.rm = TRUE)
  )

## Check pollution by week day
weekend_days <- c("Saturday", "Sunday")
df %>%
  mutate(weekend = ifelse(week_day %in% weekend_days, TRUE, FALSE))

m1 <- lm(pm25 ~ pm25_background + season + fires + weekend, data = df)
summary(m1)
