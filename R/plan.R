plan <- drake_plan(
  ## Data
  air_pollution = readAirPollution(),
  fire = readFireCounts(),
  air_pollution_background = readAirPollutionBackground(),
  temperature = readTemperature(),
  aod = readAOD()
  ## EDA
)
