## Air pollution
readAirPollution <- function(file) {
  air_pollution <- read_excel(
    file,
    sheet = "All",
    range = "AF2:AK117"
  ) %>%
    setNames(c("volume", "pm25", "ec", "oc", "oc_pm25", "date")) %>%
    mutate(date = as.Date(date))
  air_pollution
}

## readAirPollution(here("data", "air-pollution.xlsx"))
