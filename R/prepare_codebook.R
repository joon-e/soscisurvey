codebook_data <- function(data, data_path, options) {

  df_name <- as_name(quo(data))

  load_data = glue("
                   ```{{r}}
                   {df_name} <- readRDS('{data_path}')
                   ```
                   ")

  subjects <- glue("`r nrow({df_name})`")
  variables <- glue("`r ncol({df_name})`")
  started <- glue("`r min({df_name}$STARTED)`")
  ended <- glue("`r max({df_name}$STARTED)`")

  user_data <- dplyr::select_if(data, ~ !check_attribute(., "var.input", "system"))
  # Or define through options?

  codebook <- glue_collapse(purrr::imap_chr(user_data, prepare_var_info, options), sep = "\n")

  list(
    project = attr(data, "project"),
    output = options$output,
    load_data = load_data,
    df_name = df_name,
    subjects = subjects,
    variables = variables,
    started = started,
    ended = ended,
    codebook = codebook
  )

}


prepare_codebook <- function(data, codebook_path = "codebook.Rmd", data_path = "data.rds",
                             options = list(output = "html_document")) {

  # Suggests testen
  requireNamespace("usethis", quietly = TRUE)
  requireNamespace("knitr", quietly = TRUE)

  if (options$output == "html_document") requireNamespace("reactable", quietly = TRUE)


  # Save data as RDS
  ## Check overwrite
  saveRDS(data, data_path)
  ui_done("Writing {ui_value(data_path)}")

  # Create Rmd
  usethis::use_template("codebook.Rmd",
                        save_as = codebook_path,
                        data = codebook_data(data, data_path, options),
                        package = "soscisuRvey")
}
