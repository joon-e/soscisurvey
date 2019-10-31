#' Make missings vector
#'
#' Creates a vector missing values for all variables
#'
#' @param variable Variable to create vector for
#' @param missings Tibble containg missing value information
#'
#' @return A vector of missing values
make_missing_vector <- function(variable, missings) {
  missings %>%
    dplyr::filter(.data$var == variable) %>%
    dplyr::pull(missing)
}

#' Add value labels
#'
#' Adds missings to variable
#'
#' @param variable Variable to add missings to
#' @param missings Vector containg missing values
#'
#' @return A vector with user-defined missings
add_missings <- function(variable, missings) {
  if (length(missings) > 0) {
    # Coerce label to character if variable is character
    if (is.character(variable)) {
      missings <- stats::setNames(as.character(missings), names(missings))
    }
    labelled::na_values(variable) <- missings
  }
  return(variable)
}
