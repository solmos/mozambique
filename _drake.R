source("R/packages.R")

## lapply(list.files(here("R"), full.names = TRUE), source)

source("R/readAOD.R")
source("R/readAirPollution.R")
source("R/readAirPollutionBackground.R")
source("R/readFireCounts.R")
source("R/readTemperature.R")
source("R/mergeData.R")
source("R/plan.R")


drake_config(plan)
