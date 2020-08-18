## Merge all data sets
mergeData <- function(airpollution, background, fire, aod, temperature) {
  aod_wide <- aod %>%
    pivot_wider(names_from = "tile", values_from = starts_with("aod"))

  df <- airpollution %>%
    left_join(background, by = "date", suffix = c("", "_background")) %>%
    mutate(
      week_day = weekdays(date),
      month = as.integer(month(date)),
      ## Dry season from May to October (included)
      season = factor(ifelse(month %in% 5:10, "dry", "wet")),
      weekend = ifelse(week_day %in% c("Saturday", "Sunday"), TRUE, FALSE)
    ) %>%
    left_join(fire %>% select(date, n), by = "date") %>%
    rename(fires = n) %>%
    ## Removing rows with no measurement in background station
    drop_na() %>%
    left_join(aod_wide, by = "date") %>%
    left_join(temperature %>% select(date, temp_max), by = "date") %>%
    mutate(
      station = case_when(
        station == "Ermelo site - Gert Sibande MP" ~ "ermelo",
        station == "Middelburg-Nkangala" ~ "middelburg",
        station == "Hendrina - Nkangala MP" ~ "hendrina")
    ) %>%
    pivot_wider(
      names_from = "station",
      names_prefix = "pm25_",
      values_from = "pm25_background") %>%
    select(date, pm25, ec, oc, everything())

  df
}


## loadd(air_pollution, air_pollution_background, fire, aod, temperature)
## df_merged <- mergeData(air_pollution, air_pollution_background, fire, aod, temperature)
## glimpse(df_merged)
## summary(df_merged)
## m1 <- lm(pm25 ~ pm25_middelburg + season + fires + aod_med_h20 + temp_max, df_merged)
## summary(m1)
## m2 <- lm(ec ~ pm25_middelburg + season + fires + aod_med_h20 + temp_max, df_merged)
## summary(m2)
## m3 <- lm(oc ~ pm25_middelburg + season + fires + aod_med_h20 + temp_max, df_merged)
## summary(m3)
