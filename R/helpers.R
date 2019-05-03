#' Make label vector
#'
#' Creates a named vector of value labels for all variables
#'
#' @import dplyr
make_label_vector <- function(variable, values) {
  value.labels <- filter(values, var == variable)
  value.labels <- select(value.labels, value, label)
  value.labels <- setNames(value.labels$value, value.labels$label)
  return(value.labels)
}

#' Add value labels
#'
#' Adds value labels to a variable
add_label <- function(variable, values) {
  if (length(values) > 0) {
    # Coerce label to character if variable is character
    if (is.character(variable)) {
      values <- setNames(as.character(values), names(values))
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
make_missing_vector <- function(variable, missings) {
  miss.vals <- missings %>%
    filter(var == variable) %>%
    pull(missing)
}

#' Add value labels
#'
#' Adds missings to variable
add_missings <- function(variable, missings) {
  if (length(missings) > 0) {
    # Coerce label to character if variable is character
    if (is.character(variable)) {
      missings <- setNames(as.character(missings), names(missings))
    }
    na_values(variable) <- missings
  }
  return(variable)
}
