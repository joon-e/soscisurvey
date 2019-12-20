# Provide support for either kable or datatable

r_chunk <- function(x) {
  glue("
       ```{{r}}
       {x}
       ```

       ")
}


prepare_var_info <- function(var, name, options) {

  header <- prepare_var_header(var, name)

  body <- c()

  if (check_attribute(var, "var.type", c("nominal", "ordinal"))) {

    if (options$output == "html_document") {
      exp <- glue("reactable::reactable(get_value_table(data${name}), ",
                  "columns = list(Value = reactable::colDef(align = 'left')))")
    } else {
      exp <- glue("knitr::kable(get_value_table(data${name}), ",
                  "caption = 'Value labels & counts', ",
                  "align = c('l', 'l', 'r'))")
    }

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
