
<head>

<link rel="stylesheet" type="text/css" href="https://d335w9rbwpvuxm.cloudfront.net/semantic.min.css"/>’

</head>

<!-- README.md is generated from README.Rmd. Please edit that file -->

# mlgraph <img src="data/mlgraph.png" width="160px" align="right" />

[![](https://img.shields.io/github/languages/code-size/systats/mlgraph.svg)](https://github.com/systats/mlgraph)
[![](https://img.shields.io/github/last-commit/systats/mlgraph.svg)](https://github.com/systats/mlgraph/commits/master)
[![](https://img.shields.io/badge/lifecycle-experimental-blue.svg)](https://www.tidyverse.org/lifecycle/#experimental)

`mlgraph` provides performance visualizations for standardized ml models
with linear, binary or multi tasks. It is implemented as an extension of
[deeplyr](). At the moment several graphics packages are implemented
including

  - `gg_` ggplot2
  - `hc_` highcharter
  - `ax_` apexcharter

Computations are based on

  - [Metrics](https://github.com/mfrasco/Metrics)
  - [yardstick](https://github.com/tidymodels/yardstick)

Several task specific plots are available:

  - Linear
      - …
  - Binary
      - Confusion Matrix
      - ROC
      - Density
  - Multi
      - Confusion Matrix
      - ROC
      - Density

# Installation

Get the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("systats/mlgraph")
```

``` r
preds <- readRDS("data/preds.rds") %>% 
  glimpse
#> Observations: 4,016
#> Variables: 7
#> $ pred   <dbl> 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0,…
#> $ prob0  <dbl> 0.925, 0.152, 0.698, 0.887, 0.750, 0.046, 0.018, 0.193, 0.874,…
#> $ prob1  <dbl> 0.075, 0.848, 0.302, 0.113, 0.250, 0.954, 0.982, 0.807, 0.126,…
#> $ target <dbl> 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0,…
#> $ pol    <dbl> 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0,…
#> $ tweet  <chr> "rt @rzhongnotes: salt fat acid heat long ago the four element…
#> $ split  <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
```

``` r
df <- mlgraph::eval_classifier(preds, target, pred, prob1) %>% glimpse
#> List of 3
#>  $ confusion:Classes 'tbl_df', 'tbl' and 'data.frame':   4 obs. of  6 variables:
#>   ..$ actual     : Factor w/ 2 levels "0","1": 1 1 2 2
#>   ..$ pred       : Factor w/ 2 levels "0","1": 1 2 1 2
#>   ..$ n          : num [1:4] 1831 177 233 1775
#>   ..$ n_actual   : num [1:4] 2008 2008 2008 2008
#>   ..$ perc_actual: num [1:4] 0.912 0.088 0.116 0.884
#>   ..$ perc_all   : num [1:4] 0.456 0.044 0.058 0.442
#>  $ roc      :Classes 'tbl_df', 'tbl' and 'data.frame':   838 obs. of  4 variables:
#>   ..$ .threshold : num [1:838] -Inf 0.016 0.017 0.018 0.019 ...
#>   ..$ specificity: num [1:838] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ sensitivity: num [1:838] 0 0.000498 0.000996 0.00498 0.006972 ...
#>   ..$ .level     : num [1:838] 1 1 1 1 1 1 1 1 1 1 ...
#>  $ dens     :Classes 'tbl_df', 'tbl' and 'data.frame':   1024 obs. of  3 variables:
#>   ..$ x     : num [1:1024] -0.0564 -0.0542 -0.052 -0.0499 -0.0477 ...
#>   ..$ y     : num [1:1024] 0.000134 0.000176 0.000229 0.000296 0.000379 ...
#>   ..$ actual: chr [1:1024] "0" "0" "0" "0" ...
```

### ggplot2

``` r
gg_plot2 <- gridExtra::grid.arrange(
  gg_plot_confusion(df$confusion), 
  gg_plot_roc(df$roc),
  gg_plot_density(df$dens), nrow = 1
)

ggsave(gg_plot2, filename = "man/figures/gg_plot2.png", width = 18, height = 6)
```

![](man/figures/gg_charts.png)

### highcharter

``` r
pacman::p_load(shiny, shiny.semantic)
shiny.semantic::semanticPage(
  div(class= "ui three column grid", 
    div(class = "column",
      hc_plot_confusion(df$confusion)
    ),
    div(class = "column",
      hc_plot_roc(df$roc)
    ),
    div(class = "column",
      hc_plot_density(df$dens)
    )
  )
)
```

![](man/figures/hc_charts.png)

### apexcharter

``` r
pacman::p_load(shiny, shiny.semantic)
shiny.semantic::semanticPage(
  div(class= "ui three column grid", 
    div(class = "column",
      ax_plot_confusion(df$confusion)
    ),
    div(class = "column",
      ax_plot_roc(df$roc)
    ),
    div(class = "column",
      ax_plot_density(df$dens)
    )
  )
)
#htmltools::html_print(out)
```

![](man/figures/ax_charts.png)

``` r
sessionInfo()
#> R version 3.6.0 (2019-04-26)
#> Platform: x86_64-apple-darwin15.6.0 (64-bit)
#> Running under: macOS  10.15.1
#> 
#> Matrix products: default
#> BLAS:   /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRblas.0.dylib
#> LAPACK: /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRlapack.dylib
#> 
#> locale:
#> [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#>  [1] mlgraph_0.1.0    forcats_0.4.0    stringr_1.4.0    dplyr_0.8.3     
#>  [5] purrr_0.3.3      readr_1.3.1      tidyr_1.0.0.9000 tibble_2.1.3    
#>  [9] ggplot2_3.2.1    tidyverse_1.3.0  badger_0.0.4    
#> 
#> loaded via a namespace (and not attached):
#>  [1] tidyselect_0.2.5     xfun_0.11            haven_2.2.0         
#>  [4] lattice_0.20-38      colorspace_1.4-1     generics_0.0.2      
#>  [7] vctrs_0.2.99.9000    htmltools_0.4.0      yaml_2.2.0          
#> [10] utf8_1.1.4           rlang_0.4.2          pillar_1.4.3        
#> [13] withr_2.1.2          glue_1.3.1           DBI_1.1.0           
#> [16] RColorBrewer_1.1-2   dbplyr_1.4.2         modelr_0.1.5        
#> [19] readxl_1.3.1         plyr_1.8.5           rvcheck_0.1.3       
#> [22] lifecycle_0.1.0      dlstats_0.1.0        munsell_0.5.0       
#> [25] gtable_0.3.0         cellranger_1.1.0     rvest_0.3.5         
#> [28] evaluate_0.14        knitr_1.26           fansi_0.4.0         
#> [31] broom_0.5.3          Rcpp_1.0.3           scales_1.1.0        
#> [34] backports_1.1.5      jsonlite_1.6         fs_1.3.1            
#> [37] hms_0.5.2            digest_0.6.23        stringi_1.4.3       
#> [40] grid_3.6.0           cli_2.0.0            tools_3.6.0         
#> [43] magrittr_1.5         lazyeval_0.2.2       pacman_0.5.1        
#> [46] crayon_1.3.4         pkgconfig_2.0.3      xml2_1.2.2          
#> [49] pROC_1.15.3          reprex_0.3.0         lubridate_1.7.4     
#> [52] yardstick_0.0.4.9000 rstudioapi_0.10      assertthat_0.2.1    
#> [55] rmarkdown_2.0        httr_1.4.1           R6_2.4.1            
#> [58] nlme_3.1-139         compiler_3.6.0
```
