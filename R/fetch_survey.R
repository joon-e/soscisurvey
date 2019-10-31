#' Fetch survey from SoSciSurvey
#'
#' Loads data from SoSciSurvey via the API and creates a labelled tibble.
#'
#' @param URL SoSciSurvey API URL
#' @param ... Additional parameters for API retrieval.
#'     See: \url{https://www.soscisurvey.de/help/doku.php/en:results:data-api}.
#'
#'     Add \code{= TRUE} / \code{= FALSE} to parameters that are set without values in the API call
#'     (e.g., \code{vSkipTime}, \code{vQuality})
#'
#' @return A labelled tibble
#'
#' @export
fetch_survey <- function(URL, ...) {
  params <- list(...)

  json <- request_data(URL, params)

  # Create data tibble
  data <- json$data %>%
    dplyr::bind_rows()

  # Get variable info
  varinfo <- json$variables

  vars <- tibble(
    var = names(varinfo),
    label = unlist(purrr::map(varinfo, "label", .null = NA)),
    type = unlist(purrr::map(varinfo, "type", .null = NA)),
    input = unlist(purrr::map(varinfo, "input", .null = NA)),
    question = unlist(purrr::map(varinfo, "question", .null = NA)),
    sysvar = unlist(purrr::map(varinfo, "sysvar", .null = NA))
    ) %>%
    dplyr::filter(.data$var %in% names(data))

  # Sort like data and remove vars not present in data
  vnames <- tibble::tibble(var = names(data))

  vars <- vnames %>%
    dplyr::left_join(vars, by = "var")

  # Get value labels
  varinfo <- tibble::enframe(varinfo, "var", "varinfo")

  val_labels <- varinfo %>%
    dplyr::mutate(label = purrr::map(varinfo, "values", .null = list())) %>%
    dplyr::select(.data$var, .data$label) %>%
    tidyr::unnest_longer(.data$label) %>%
    dplyr::transmute(.data$var, .data$label,
                     value = as.integer(.data$label_id)) %>%
    tidyr::drop_na()

  # Get missings
  missings <- varinfo %>%
    dplyr::mutate(missing = purrr::map(varinfo, "missing", .null = list())) %>%
    dplyr::select(.data$var, .data$missing) %>%
    tidyr::unnest_longer(.data$missing) %>%
    tidyr::drop_na()

  # Add attribute
  var.types <- tolower(dplyr::pull(vars, .data$type))
  var.input <- tolower(dplyr::pull(vars, .data$input))
  var.question <- dplyr::pull(vars, .data$question)
  var.sysvar <- dplyr::pull(vars, .data$sysvar)
  data <- purrr::modify2(data, var.types, `attr<-`, which = "var.type") %>%
    purrr::modify2(var.input, `attr<-`, which = "var.input") %>%
    purrr::modify2(var.question, `attr<-`, which = "var.question") %>%
    purrr::modify2(var.sysvar, `attr<-`, which = "var.sysvar")

  # Add value labels
  val.labs <- purrr::map(names(data), make_label_vector, val_labels)
  data <- purrr::modify2(data, val.labs, add_label)

  # Add missings
  miss.vals <- purrr::map(names(data), make_missing_vector, missings)
  data <- purrr::modify2(data, miss.vals, add_missings)

  # Add variable labels
  var.labels <- stats::setNames(as.list(as.character(vars$label)), vars$var)
  labelled::var_label(data) <- var.labels

  # Metadata (json$metadata)

  # Return tibble
  return(data)
}

#' Read data from SoSciSurvey
#'
#' This function will be deprecated soon; use \code{\link{fetch_survey}} instead.
#'
#' @inheritParams fetch_survey
#'
#' @export
read_sosci <- function(URL, ...) {
  warning("Soon, `read_sosci()` will be deprecated. Try using `fetch_survey()` instead.")
  fetch_survey(URL, ...)
}
