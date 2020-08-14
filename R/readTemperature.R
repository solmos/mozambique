## Read temperature data

readTempSheet <- function(file, sheet, range = "A8:K38") {
  var_names <- c("day", "temp_max", "temp_min", "temp_land", "evaporation",
                 "temp_8h_max", "temp_8h_min", "temp_14h_max", "temp_14h_min",
                 "pct_8h", "pct_14h")
  read_excel(
    file,
    sheet,
    range = range,
    col_names = var_names
  )
}

readTempFile <- function(file, year) {
  sheets <- excel_sheets(file)
  map_df(sheets, ~ readTempSheet(file, .), .id = "month") %>%
    mutate(
      year = year,
      month = as.integer(month),
      day = as.integer(day)
    ) %>%
    select(year, everything())
}

readTempFile(files[1], 2014)

## Sheet corresponding to October 2014 has different column headers
## so we need to parse it differently than the rest.
readTemperature <- function() {
  files <- c(
    here("data", "temperature2014.xls"),
    here("data", "temperature2015.xls")
  )
  years <- 2014:2015
  temp <- map2_df(files, years, readTempFile)
  file2014 <- files[str_detect(files, "2014")]
  temp2014_oct <- readTempSheet(file2014, "Outubro", "F8:P38") %>%
    mutate(year = "1", month = "10") %>%
    select(year, month, everything())
  temp[temp$year == "1" & temp$month == "10",] <- temp2014_oct
  ## Remove non existing days (i.e. February 30)
  temp %>%
    filter(!is.na(temp_max)) %>%
    mutate(date = make_date(year, month, day)) %>%
    select(date, everything()) %>%
    select(-year, -month, -day, -temp_land)
}

