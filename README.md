# bios731_hw3_parrish



---

- [Directories \& Files](#directories-and-files)
- [Reproducibility](#reproducibility)
- [Session Info](#session-info)


---


## Directories and Files

```
.
├── README.md
├── analysis
│   ├── HW3_final_report.Rmd
│   ├── HW3_final_report.pdf
│   └── preamble.tex
├── bios731_hw3_parrish.Rproj
├── results
│   ├── ci_plot-1.pdf
│   ├── sim_data-1.pdf
│   ├── sim_data-2.pdf
│   └── time_plot-1.pdf
└── source
    ├── em_algorithm.R
    ├── logistic.R
    ├── logistic_methods.R
    └── logistic_simulate_data.R

```


---



## Reproducibility


### Required R packages

- ggplot2
- here
- kableExtra
- knitr
- matlib
- survival

```R
install.packages(c("ggplot2", "here", "kableExtra", "knitr", "matlib", "survival"))
```


### Running the analysis

Once the R packages are installed, ``./analysis/HW3_final_report.Rmd`` can be knitted to replicate the results.

---



## Session Info

```R
R version 4.2.3 (2023-03-15)
Platform: x86_64-apple-darwin17.0 (64-bit)
Running under: macOS Big Sur ... 10.16

Matrix products: default
BLAS:   /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRblas.0.dylib
LAPACK: /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRlapack.dylib

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] ggplot2_4.0.2    kableExtra_1.4.0 here_1.0.2       survival_3.7-0  

loaded via a namespace (and not attached):
 [1] compiler_4.2.3     pillar_1.9.0       RColorBrewer_1.1-3 tools_4.2.3       
 [5] digest_0.6.35      evaluate_1.0.5     lifecycle_1.0.5    tibble_3.2.1      
 [9] gtable_0.3.6       lattice_0.20-45    viridisLite_0.4.2  pkgconfig_2.0.3   
[13] rlang_1.1.7        Matrix_1.5-3       cli_3.6.5          rstudioapi_0.16.0 
[17] xfun_0.56          fastmap_1.1.1      withr_3.0.2        stringr_1.5.1     
[21] dplyr_1.2.0        xml2_1.3.6         knitr_1.51         generics_0.1.3    
[25] vctrs_0.7.1        systemfonts_1.3.1  tidyselect_1.2.1   rprojroot_2.1.1   
[29] grid_4.2.3         svglite_2.1.3      glue_1.8.0         R6_2.6.1          
[33] fansi_1.0.6        rmarkdown_2.30     farver_2.1.1       magrittr_2.0.3    
[37] scales_1.4.0       htmltools_0.5.9    splines_4.2.3      S7_0.2.1          
[41] utf8_1.2.4         stringi_1.8.4     


```

