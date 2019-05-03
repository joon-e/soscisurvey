#' Load data from SoSciSurvey
#'
#' Loads data from SoSciSurvey via the API and creates a labelled tibble.
#'
#' @import dplyr
#' @import purrr
#' @import tibble
#' @import tidyr
#' @import labelled
#'
#' @param URL SoSciSurvey API URL
#' @param ... Additional parameters for API retrieval. See:
#'     https://www.soscisurvey.de/help/doku.php/en:results:data-api
#'
#' @return A labelled tibble
#'
#' @export
sosci <- function(URL, ...) {

  params <- list(...)

  # Add variable info to API parameters
  params[["infoVariables"]] <- TRUE
  params[["infoValues"]] <- TRUE
  params[["infoQuestionText"]] <- TRUE

  # Get data
  resp <- httr::GET(URL, query = params)
  httr::stop_for_status(resp)
  json <- httr::content(resp, "parsed")

  # Get dataset
  data <- json$data %>%
    bind_rows()

  # Get variable info
  varinfo <- json$variables

  vars <- tibble(
    var = names(varinfo),
    label = unlist(map(varinfo, "label", .null = NA)),
    type = unlist(map(varinfo, "type", .null = NA)),
    input = unlist(map(varinfo, "input", .null = NA)),
    question = unlist(map(varinfo, "question", .null = NA)),
    sysvar = unlist(map(varinfo, "sysvar", .null = NA))
  ) %>%
    filter(var %in% names(data))

  # Get value labels
  val.labels <- varinfo %>%
    enframe("var", "varinfo") %>%
    mutate(label = map(varinfo, "values", .null = list())) %>%
    select(var, label) %>%
    filter(label %>% map(length) > 0) %>%
    mutate(value = map(label, names)) %>%
    filter(value %>% map(length) > 0) %>%
    unnest(value, label) %>%
    unnest() %>%
    mutate(value = as.integer(value))

  # Get missings
  missings <- varinfo %>%
    enframe("var", "varinfo") %>%
    mutate(missing = map(varinfo, "missing", .null = list())) %>%
    select(var, missing) %>%
    filter(missing %>% map(length) > 0) %>%
    unnest() %>%
    unnest()

  # Add variable labels
  var.labels <- setNames(as.character(vars$label), vars$var)
  var_label(data) <- var.labels

  # Add attribute
  var.types <- tolower(pull(vars, type))
  var.input <- tolower(pull(vars, input))
  var.question <- pull(vars, question)
  var.sysvar <- pull(vars, sysvar)
  data <- modify2(data, var.types, `attr<-`, which = "var.type") %>%
    modify2(var.input, `attr<-`, which = "var.input") %>%
    modify2(var.question, `attr<-`, which = "var.question") %>%
    modify2(var.sysvar, `attr<-`, which = "var.sysvar")

  # Add value labels
  val.labs <- map(names(data), make_label_vector, val.labels)
  data <- modify2(data, val.labs, add_label)

  # Add missings
  miss.vals <- map(names(data), make_missing_vector, missings)
  data <- modify2(data, miss.vals, add_missings)

  return(data)
}
