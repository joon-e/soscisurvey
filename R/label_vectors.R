#' Make label vector
#'
#' Creates a named vector of value labels for all variables
#'
#' @param variable Variable to create vector for
#' @param values Tibble containing value and label columns
#'
#' @return A named vector
make_label_vector <- function(variable, values) {
  value.labels <- dplyr::filter(values, .data$var == variable) %>%
    dplyr::select(.data$value, .data$label)
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
    labelled::val_labels(variable) <- values
  }
  return(variable)
}
