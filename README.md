
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qPCR.analysis

<!-- badges: start -->
<!-- badges: end -->

The goal of qPCR.analysis is to take in a csv of the Results page from
an Applied Biosystems 96- or 384-W qPCR analysis and export mean +/- SD
for each sample.

## Installation

You can install the development version of qPCR.analysis from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("L-E-Bates/qPCR.analysis")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(qPCR.analysis)
## basic example code

x <- system.file("extdata", "SYBR 384W example.csv", package = "qPCR.analysis")
analyse_qPCR(x)
#> [1] "Detected SybrGreen run. Analysing."
#> [1] "Assuming analysis method is Delta-Delta CT. Performing analysis."
#> [1] "Control gene is Housekeeper"
#> [1] "Control line is D0 Untreated Rep 1"
#> [1] "1d Condition A Rep 1 Target3 is an outlier; p= 0.0271002710027057 . Excluding."
#> [1] "1d Condition A Rep 2 Target4 is an outlier; p= 0.0285248573757118 . Excluding."
#> [1] "2d Condition B Rep 2 Target3 is an outlier; p= 0.0336700336700348 . Excluding."
#> [1] "D0 Untreated Rep 1 Target2 is an outlier; p= 0.0372852122053811 . Excluding."
#> # A tibble: 110 x 9
#> # Groups:   Sample_Name [22]
#>    Sample_Name     Targe~1  mean_d    sd_d   sem_d mean_dd   sd_dd  sem_dd  nrep
#>    <chr>           <chr>     <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl> <int>
#>  1 1d Condition A~ Housek~ 1.00e+0 3.29e-2 1.10e-2   1.00  3.29e-2 0.0110      3
#>  2 1d Condition A~ Target1 6.73e-4 7.81e-5 2.60e-5   1.04  1.21e-1 0.0402      3
#>  3 1d Condition A~ Target2 6.20e-5 6.24e-5 2.08e-5  17.1   1.72e+1 5.75        3
#>  4 1d Condition A~ Target3 3.14e-4 2.77e-6 1.39e-6   1.65  1.46e-2 0.00730     2
#>  5 1d Condition A~ Target4 5.62e-4 3.50e-4 1.17e-4   0.557 3.47e-1 0.116       3
#>  6 1d Condition A~ Housek~ 1.14e+0 6.73e-1 2.24e-1   1.14  6.73e-1 0.224       3
#>  7 1d Condition A~ Target1 7.07e-4 9.56e-5 3.19e-5   1.09  1.48e-1 0.0493      3
#>  8 1d Condition A~ Target2 8.95e-5 1.18e-5 3.93e-6  24.7   3.26e+0 1.09        3
#>  9 1d Condition A~ Target3 3.49e-4 3.87e-5 1.29e-5   1.84  2.04e-1 0.0679      3
#> 10 1d Condition A~ Target4 5.88e-4 4.04e-6 2.02e-6   0.583 4.00e-3 0.00200     2
#> # ... with 100 more rows, and abbreviated variable name 1: Target_Name
#> # i Use `print(n = ...)` to see more rows
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.
