plan <- drake_plan(
  ## Data
  air_pollution = readAirPollution(),
  fire = readFireCounts(),
  air_pollution_background = readAirPollutionBackground(),
  temperature = readTemperature(),
  aod = readAOD(),
  data_merged = mergeData(
    airpollution = air_pollution,
    background = air_pollution_background,
    fire = fire,
    aod = aod,
    temperature = temperature
  ),
  ## Models
  outcomes = c("pm25", "oc", "ec"),
  predictors = c("season", "fires", "aod_med_h20", "pm25_middelburg"),
  models = map(
    outcomes,
    ~ fitModel(outcome = ., predictors, data_merged)
  ),
  ## Reports
  eda_report = target(
    command = {
      rmarkdown::render(knitr_in("reports/initial-models.Rmd"))
      file_out("reports/initial-models.html")
    }
  )

)
