readBackgroundSheet <- function(file, sheet) {
  read_excel(
    file, sheet, skip = 1,
    col_names = c("date", "pm25"),
    col_types = c("date", "numeric"),
    na = "-9999"
  ) %>%
    mutate(date = as.Date(date), station = sheet)
}
readAirPollutionBackground <- function() {
  file <- here("data", "PM25_hist_HPA.xlsx")
  sheets <- excel_sheets(file)
  map_df(sheets, ~ readBackgroundSheet(file, sheet = .))
}

## Example
## file <- here("data", "PM25_hist_HPA.xlsx")
## sheets <- excel_sheets(file)
## sheet <- sheets[1]
## readBackgroundSheet(file, sheet)
## readAirPollutionBackground()
