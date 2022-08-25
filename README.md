
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

x <- "C:/Users/Lawrence/Downloads/STAN_qPCR/STAN_qPCR/150422_STAN_NE_QuantStudio 12K Flex_export.csv"
analyse_qPCR(x)
#> [1] "Detected SybrGreen run. Analysing."
#> [1] "Assuming analysis method is Delta-Delta CT. Performing analysis."
#> [1] "Control gene is UBC"
#> [1] "Control line is 161_NAIVE"
#> # A tibble: 34 x 9
#> # Groups:   Sample_Name [6]
#>    Sample_Name Target_Name  mean_d    sd_d   sem_d mean_dd   sd_dd  sem_dd  nrep
#>    <chr>       <chr>         <dbl>   <dbl>   <dbl>   <dbl>   <dbl>   <dbl> <int>
#>  1 161_NAIVE   ACTB        7.73e-1 1.77e-2 4.41e-3 1.00e+0 2.28e-2 5.71e-3     4
#>  2 161_NAIVE   FOXG1       8.75e-5 2.01e-5 5.04e-6 1.02e+0 2.35e-1 5.88e-2     4
#>  3 161_NAIVE   OTX2        4.74e-3 1.64e-3 4.10e-4 1.05e+0 3.64e-1 9.11e-2     4
#>  4 161_NAIVE   PAX6        1.47e-6 3.99e-7 2.00e-7 1.02e+0 2.76e-1 1.38e-1     2
#>  5 161_NAIVE   SOX1        1.60e-4 2.23e-5 5.57e-6 1.01e+0 1.40e-1 3.50e-2     4
#>  6 161_NAIVE   UBC         1.32e+0 1.09e+0 2.73e-1 1.32e+0 1.09e+0 2.73e-1     4
#>  7 161_NE      ACTB        3.36e-1 1.25e-2 3.12e-3 4.35e-1 1.61e-2 4.03e-3     4
#>  8 161_NE      FOXG1       1.72e-3 1.26e-4 3.16e-5 2.01e+1 1.48e+0 3.69e-1     4
#>  9 161_NE      OTX2        1.11e-2 8.69e-4 2.17e-4 2.46e+0 1.93e-1 4.82e-2     4
#> 10 161_NE      PAX6        4.86e-3 3.37e-4 8.42e-5 3.37e+3 2.33e+2 5.83e+1     4
#> # ... with 24 more rows
#> # i Use `print(n = ...)` to see more rows
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/v1/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
