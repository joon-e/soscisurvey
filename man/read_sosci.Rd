% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_sosci.R
\name{read_sosci}
\alias{read_sosci}
\title{Load data from SoSciSurvey}
\usage{
read_sosci(URL, ...)
}
\arguments{
\item{URL}{SoSciSurvey API URL}

\item{...}{Additional parameters for API retrieval.
    See: \url{https://www.soscisurvey.de/help/doku.php/en:results:data-api}.

    Add \code{= TRUE} / \code{= FALSE} to parameters that are set without values in the API call
    (e.g., \code{vSkipTime}, \code{vQuality})}
}
\value{
A labelled tibble
}
\description{
Loads data from SoSciSurvey via the API and creates a labelled tibble.
}
