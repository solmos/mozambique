## Merge all data sets
mergeData <- function(air.pollution, background, fire, aod, temperature) {
  df <- air.pollution %>%
    left_join(background, by = "date") %>%
    mutate(
      week_day = weekdays(date),
      month = month(date),
      season = ifelse(month %in% 5:10, "dry", "wet"),
      weekend = ifelse(week_day %in% c("Saturday", "Sunday"), TRUE, FALSE)
    ) %>%
    left_join(fire %>% select(date, n), by = "date") %>%
    rename(fires = n)
}

mergeData()
