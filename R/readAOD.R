## ## Read AOD data
## ## A csv was created from the .RData file

## load(here("data", "aod_timeseries.RData"), verbose = TRUE)
## write_csv(aod, here("data", "aod_2014-03-01_2015-04-30.csv"))

readAOD <- function() {
  file <- here("data", "aod_2014-03-01_2015-04-30.csv")
  df <- read_csv(file, col_types = list(tile = col_factor()))

  df
}
