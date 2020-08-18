## Prediction models for PM2.5, OC and EC

## subsetModels <- function(outcome = c("pm25", "oc", "ec"), predictors, data, nvmax) {
##   outcome <- match.arg(outcome)
##   no_predictors <- c("pm25", "oc", "ec", "oc_pm25", "date", "week_day")
##   predictors <- colnames(data)[!colnames(data) %in% no_predictors]
##   model_formula <- paste(outcome, "~", paste(predictors, collapse = "+")) %>%
##     as.formula()
##   regsub <- regsubsets(model_formula, data = data, nvmax = 6)
##   summary(regsub)
## }


fitModel <- function(outcome = c("pm25", "oc", "ec"), predictors, data) {
  outcome <- match.arg(outcome)
  ## predictors <- c("fires", "pm25_middelburg", "season", "aod_med_h20")
  model_formula <- paste(outcome, "~", paste(predictors, collapse = "+")) %>%
    as.formula()

  data_model <- data[, c(outcome, predictors)] %>%
    drop_na()

  train_control <- trainControl(method = "LOOCV")
  model <- train(
    model_formula,
    data = data_model,
    method = "lm",
    trControl = train_control)
  model
}

## outcomes <- c("pm25", "oc", "ec")
## predictors <- c("season", "fires", "aod_med_h20", "pm25_middelburg")
## models <- map(
##   c("pm25", "oc", "ec"),
##   ~ fitModel(., predictors, data_merged)
## )


createModelTable <- function(models) {
  model_r2 <- map_dbl(models, ~ summary(.)$adj.r.squared)
  metrics_loocv<- map_dfr(models, ~ .$results[2:4])
  tibble(outcome = outcomes, r2 = model_r2, metrics_loocv)
}

## model_r2 <- map_dbl(models, function(m) summary(m)$adj.r.squared)
## metrics_loocv<- map_dfr(models, ~ .$results[2:4])
## tibble(outcome = outcomes, metrics_loocv, r2 = model_r2)
## s <- summary(models[[1]])
## s$adj.r.squared
## s$sigma
## x <- fitModel("oc", data_merged)
## x$results
## sx <- summary(x)
## sx$adj.r.squared
