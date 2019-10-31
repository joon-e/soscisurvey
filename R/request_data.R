#' Request data from SoSciSurvey
#'
#' Performs API request to SoSciSurvey
#'
#' @param URL SoSciSurvey API URL
#' @param params Additional request parameters
#'
#' @return a list
#'
#' @keywords internal
request_data <- function(URL, params) {
  # Add variable info to API parameters
  params[["infoVariables"]] <- TRUE
  params[["infoValues"]] <- TRUE
  params[["infoQuestionText"]] <- TRUE

  # Get JSON data
  resp <- httr::GET(URL, query = params)
  httr::stop_for_status(resp)
  json <- httr::content(resp, "parsed")
  return(json)
}
