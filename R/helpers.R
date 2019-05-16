#' Make label vector
#'
#' Creates a named vector of value labels for all variables
#'
#' @import dplyr
#'
#' @param variable Variable to create vector for
#' @param values Tibble containing value and label columns
#'
#' @return A named vector
make_label_vector <- function(variable, values) {
  value.labels <- filter(values, var == variable)
  value.labels <- select(value.labels, value, label)
  value.labels <- stats::setNames(value.labels$value, value.labels$label)
  return(value.labels)
}

#' Add value labels
#'
#' Adds value labels to a variable
#'
#' @param variable Variable to add labels to
#' @param values Named vector containing value-label pairs
#'
#' @return A labelled vector
add_label <- function(variable, values) {
  if (length(values) > 0) {
    # Coerce label to character if variable is character
    if (is.character(variable)) {
      values <- stats::setNames(as.character(values), names(values))
    }
    val_labels(variable) <- values
  }
  return(variable)
}

#' Make missings vector
#'
#' Creates a vector missing values for all variables
#'
#' @import dplyr
#'
#' @param variable Variable to create vector for
#' @param missings Tibble containg missing value information
#'
#' @return A vector of missing values
make_missing_vector <- function(variable, missings) {
  miss.vals <- missings %>%
    filter(var == variable) %>%
    pull(missing)
}

#' Add value labels
#'
#' Adds missings to variable
#'
#' @import labelled
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
    na_values(variable) <- missings
  }
  return(variable)
}
