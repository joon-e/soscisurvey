# Provide support for either kable or datatable

r_chunk <- function(x) {
  glue("
       ```{{r}}
       {x}
       ```

       ")
}


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
                       dplyr::mutate(Value = as.integer(.data$Value)),
                     by = "Value") %>%
    dplyr::select("Value", "Label", "n")
}

prepare_var_info <- function(var, name) {

  header <- prepare_var_header(var, name)

  body <- c()

  if (is_table_var(var)) {
    exp <- glue("knitr::kable(get_value_table(data${name}), ",
                "caption = 'Value labels & counts', ",
                "align = c('l', 'l', 'r'))")

    body <- c(body, r_chunk(exp))
  }

  glue_collapse(c(header, body), sep = "\n")
}


prepare_var_header <- function(var, name) {

  var_id <- name
  var_ats <- attributes(var)

  if (!is.null(var_ats$label)) {
    headline <- glue("## [{var_id}] {var_ats$label}")
  } else {
    headline <- glue("## [{var_id}]")
  }

  var_info <- c()

  if (!is.null(var_ats$var.question)) {
    var_info <- c(var_info, glue("* Question wording: {var_ats$var.question}"))
  }

  if (!is.null(var_ats$var.type)) {
    var_info <- c(var_info, glue("* Type: {var_ats$var.type}"))
  }

  if (!is.null(var_ats$var.input)) {
    var_info <- c(var_info, glue("* Input: {var_ats$var.input}"))
  }

  if (!is.null(var_ats$var.sysvar)) {
    var_info <- c(var_info, glue("* System name: {var_ats$var.sysvar}"))
  }

  var_info <- glue_collapse(var_info, sep = "\n")

  glue("
       {headline}

       {var_info}

       ")

}

is_user_var <- function(x) !is.null(attr(x,  "var.input")) & attr(x, "var.input") != "system"

is_table_var <- function(x) !is.null(attr(x,  "var.type")) & attr(x, "var.type") %in% c("nominal", "ordinal")
