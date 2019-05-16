#' SoSciSurvey: Load data from SoSciSurvey into R
#'
#' This package loads data obtained with \href{https://www.soscisurvey.de/en/index}{SoSciSurvey} as a tidy,
#'     labelled dataset.
#'
#' @section Obtain API key:
#'
#' Head to your \emph{SoSciSurvey} project and select \emph{Collected Data / API for Data Retrieval}
#'     and click on the plus sign in the top right corner to create a new API key. Make sure that
#'     \emph{Retrieve data via JSON interface} is selected under \emph{Function:}
#'     (this should be the default setting). Select the other options to your liking. Finally, click on the
#'     save button, then copy the created API URL.
#'
#' @section Functions:
#'
#' The main function to load the data is \code{\link{read_sosci}}.
#'
#' @docType package
#' @name soscisurvey
NULL

utils::globalVariables(c("var", "value", "label", "type", "input", "question", "sysvar"))
