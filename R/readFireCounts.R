readFireCounts <- function(file) {
  fire_counts <- read_delim(file, delim = ";") %>%
    rename(date = "ACQ_DATE") %>%
    count(date) %>%
    as_tibble()
  dates_expanded <- seq(min(fire_counts$date), max(fire_counts$date), by = "days")
  fires_full <- tibble(date = dates_expanded) %>%
    left_join(fire_counts) %>%
    mutate(
      day = day(date),
      month = month(date, label = TRUE),
      year = year(date),
      year_fct = factor(year, levels = 2012:2019, labels = 2012:2019, ordered = TRUE),
      n = replace_na(n, 0)
    )
  fires_full
}

## readFireCounts(here("data", "simplified.csv"))
## file <- here("data", "simplified.csv")
