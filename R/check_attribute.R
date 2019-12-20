check_attribute <- function(var, attribute, values = NULL) {

  if (is.null(attr(var, attribute))) {
    return(FALSE)
  }

  if (!is.null(values)) {
    if (attr(var, attribute) %in% values) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }

  return(TRUE)
}
