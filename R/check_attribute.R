test_var <- data$GS01_01


check_attribute <- function(var, attribute, values = NULL) {

  if (is.null(attr(var, attribute))) {
    return(FALSE)
  }

  if (!is.null(values)) {
    if (attr(var, attribute) %in% values) {
      print(var, attribute)
      return(TRUE)
    } else {
      return(FALSE)
    }
  }

  return(TRUE)
}

check_attribute(test_var, "var.type", c("metric", "ordinal"))
