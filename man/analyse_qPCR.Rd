% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/analyse_qPCR.R
\name{analyse_qPCR}
\alias{analyse_qPCR}
\title{Analyse qPCR file}
\usage{
analyse_qPCR(qPCR_file, ctrl_gene = FALSE, ctrl_line = FALSE, out_data = FALSE)
}
\arguments{
\item{qPCR_file}{The path to a csv file of the Results page of a qPCR run.}

\item{ctrl_gene}{Name of the control gene to normalize to if not included or different to that stated in the file.}

\item{ctrl_line}{Name of the control line to normalize to if not included or different to that stated in the file.}

\item{out_data}{Logical. Set to true to output the full analysed dataset rather than the summary statistics.}
}
\value{
A tibble containing the mean and SD for the delta and delta delta values for each gene in each sample.
}
\description{
Analyse qPCR file
}
\examples{

x <- system.file("extdata", "SYBR 384W example.csv", package = "qPCR.analysis")
analyse_qPCR(x)

}
