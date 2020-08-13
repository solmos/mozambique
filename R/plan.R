plan <- drake_plan(
  ## air_pollution_data = readAirPollution("data/air-pollution.xlsx"),
  ## fire_data = readFireCounts(here("data", "simplified.csv")),
  ## background_air_data = readBackgroundAirPollution(here("data", "PM25_hist_HPA.xlsx")),
  ## temperature_data = readTemperature()
  aod = readAOD()
)
