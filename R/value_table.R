# Tidy umbauen
get_value_table <- function(var) {

  labs <- labelled::val_labels(var)

  if (!is.null(labs)) {
    val_labels <- tibble::enframe(labs, "Label", "Value")
  } else {
    val_labels <- tibble::tibble(values = sort(unique(var)))
  }

  val_labels %>%
    dplyr::full_join(table(var, useNA = "ifany") %>%
                       tibble::enframe("Value", "n") %>%
                       dplyr::mutate_all(as.integer),
                     by = "Value") %>%
    dplyr::select("Value", "Label", "n") %>%
    dplyr::mutate(Label = ifelse(is.na(.data$Label), "Missing", .data$Label))
}
