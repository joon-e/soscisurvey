get_survey_stats <- function(data) {
  list(
    N = nrow(data),
    started = as.POSIXct(min(data$STARTED)),
    ended = as.POSIXct(max(data$STARTED))
  )
}
