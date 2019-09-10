
<!-- README.md is generated from README.Rmd. Please edit that file -->
CytoComp
========

<!-- badges: start -->
<!-- badges: end -->
The goal of CytoComp is to compensate the spillover effects in CyTOF data which caused by technical effects without relying on control experiment.

Installation
------------

You can install the development version of CytoComp from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("qmiao19/CytoComp")
```

Example
-------

This is a example which shows you how to compensate a CyTOF dataset, we used a sample dataset that included in our package here:

``` r
library(CytoComp)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so:

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

You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don't forget to commit and push the resulting figure files, so they display on GitHub!
