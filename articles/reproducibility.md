# Reproducibility

When using data from external sources it’s a good idea to take note of
when data was downloaded, which version (if possible) and with what.

Reproducibility with `weathercan` can be achieved by taking note (or
better yet, compiling reports) with the following information:

1.  Your computer information (and date)
    - R version
2.  Specific information on packages you’re using
    - Citations if presenting in papers/reports
3.  The stations list version

For example:

``` r

# Work
library(weathercan)
s <- stations_search("Winnipeg", normals_years = "current")
w <- weather_dl(s, interval = "month", start = "2021-01-01")

# Reproducibility
stations_meta()
citation('weathercan')
devtools::session_info() # Install devtools if you don't have it
```

    ## # A tibble: 1 × 2
    ##   ECCC_modified       weathercan_modified
    ##   <dttm>              <date>             
    ## 1 2026-06-03 23:30:00 2026-06-11

    ## To cite 'weathercan' in publications, please use:
    ## 
    ##   LaZerte, Stefanie E and Sam Albers (2018). weathercan: Download and format weather data from Environment and
    ##   Climate Change Canada. The Journal of Open Source Software 3(22):571. doi:10.21105/joss.00571.
    ## 
    ## A BibTeX entry for LaTeX users is
    ## 
    ##   @Article{,
    ##     title = {{weathercan}: {D}ownload and format weather data from Environment and Climate Change Canada},
    ##     author = {Stefanie E LaZerte and Sam Albers},
    ##     journal = {The Journal of Open Source Software},
    ##     volume = {3},
    ##     number = {22},
    ##     pages = {571},
    ##     year = {2018},
    ##     url = {https://joss.theoj.org/papers/10.21105/joss.00571},
    ##   }

    ## ─ Session info ────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  setting  value
    ##  version  R version 4.6.0 (2026-04-24)
    ##  os       Ubuntu 24.04.4 LTS
    ##  system   x86_64, linux-gnu
    ##  ui       Positron
    ##  language en_CA:en_US:en
    ##  collate  en_US.UTF-8
    ##  ctype    en_US.UTF-8
    ##  tz       America/Winnipeg
    ##  date     2026-06-11
    ##  pandoc   3.1.3 @ /usr/bin/pandoc
    ##  quarto   1.6.39 @ /opt/quarto/bin/quarto
    ## 
    ## ─ Packages ────────────────────────────────────────────────────────────────────────────────────────────────────────────────
    ##  ! package      * version   date (UTC) lib source
    ##    bit            4.6.0     2025-03-06 [1] CRAN (R 4.6.0)
    ##    bit64          4.8.2     2026-05-19 [1] CRAN (R 4.6.0)
    ##    blob           1.3.0     2026-01-14 [1] CRAN (R 4.6.0)
    ##    brio           1.1.5     2024-04-24 [1] CRAN (R 4.6.0)
    ##    cachem         1.1.0     2024-05-16 [1] CRAN (R 4.6.0)
    ##    class          7.3-23    2025-01-01 [4] CRAN (R 4.4.2)
    ##    classInt       0.4-11    2025-01-08 [1] CRAN (R 4.6.0)
    ##    cli            3.6.6     2026-04-09 [1] CRAN (R 4.6.0)
    ##    commonmark     2.0.0     2025-07-07 [1] CRAN (R 4.6.0)
    ##    crayon         1.5.3     2024-06-20 [1] CRAN (R 4.6.0)
    ##    curl           7.1.0     2026-04-22 [1] CRAN (R 4.6.0)
    ##    DBI            1.3.0     2026-02-25 [1] CRAN (R 4.6.0)
    ##    dbplyr         2.5.2     2026-02-13 [1] CRAN (R 4.6.0)
    ##    desc           1.4.3     2023-12-10 [1] CRAN (R 4.6.0)
    ##    devtools       2.5.2     2026-04-30 [1] CRAN (R 4.6.0)
    ##    diffobj        0.3.6     2025-04-21 [1] CRAN (R 4.6.0)
    ##    dplyr        * 1.2.1     2026-04-03 [1] CRAN (R 4.6.0)
    ##    e1071          1.7-17    2025-12-18 [1] CRAN (R 4.6.0)
    ##    ellipsis       0.3.3     2026-04-04 [1] CRAN (R 4.6.0)
    ##    evaluate       1.0.5     2025-08-27 [1] CRAN (R 4.6.0)
    ##    farver         2.1.2     2024-05-13 [1] CRAN (R 4.6.0)
    ##    fastmap        1.2.0     2024-05-15 [1] CRAN (R 4.6.0)
    ##    fs             2.1.0     2026-04-18 [1] CRAN (R 4.6.0)
    ##    generics       0.1.4     2025-05-09 [1] CRAN (R 4.6.0)
    ##    ggplot2      * 4.0.3     2026-04-22 [1] CRAN (R 4.6.0)
    ##    glue         * 1.8.1     2026-04-17 [1] CRAN (R 4.6.0)
    ##    gtable         0.3.6     2024-10-25 [1] CRAN (R 4.6.0)
    ##    hms            1.1.4     2025-10-17 [1] CRAN (R 4.6.0)
    ##    httr2          1.2.2     2025-12-08 [1] CRAN (R 4.6.0)
    ##    KernSmooth     2.23-26   2025-01-01 [4] CRAN (R 4.4.2)
    ##    knitr        * 1.51      2025-12-20 [1] CRAN (R 4.6.0)
    ##    labeling       0.4.3     2023-08-29 [1] CRAN (R 4.6.0)
    ##    lifecycle      1.0.5     2026-01-08 [1] CRAN (R 4.6.0)
    ##    lubridate    * 1.9.5     2026-02-04 [1] CRAN (R 4.6.0)
    ##    lutz           0.3.2     2023-10-17 [1] CRAN (R 4.6.0)
    ##    magrittr       2.0.5     2026-04-04 [1] CRAN (R 4.6.0)
    ##    memoise        2.0.1     2021-11-26 [1] CRAN (R 4.6.0)
    ##    naniar       * 1.1.0     2024-03-05 [1] CRAN (R 4.6.0)
    ##    otel           0.2.0     2025-08-29 [1] CRAN (R 4.6.0)
    ##    pillar         1.11.1    2025-09-17 [1] CRAN (R 4.6.0)
    ##    pkgbuild       1.4.8     2025-05-26 [1] CRAN (R 4.6.0)
    ##    pkgconfig      2.0.3     2019-09-22 [1] CRAN (R 4.6.0)
    ##    pkgload        1.5.2     2026-04-22 [1] CRAN (R 4.6.0)
    ##    proxy          0.4-29    2025-12-29 [1] CRAN (R 4.6.0)
    ##    purrr          1.2.2     2026-04-10 [1] CRAN (R 4.6.0)
    ##    R6             2.6.1     2025-02-15 [1] CRAN (R 4.6.0)
    ##    rappdirs       0.3.4     2026-01-17 [1] CRAN (R 4.6.0)
    ##    RColorBrewer   1.1-3     2022-04-03 [1] CRAN (R 4.6.0)
    ##    Rcpp           1.1.1-1.1 2026-04-24 [1] CRAN (R 4.6.0)
    ##    readr        * 2.2.0     2026-02-19 [1] CRAN (R 4.6.0)
    ##    rlang          1.2.0     2026-04-06 [1] CRAN (R 4.6.0)
    ##    roxygen2       7.3.3     2025-09-03 [1] CRAN (R 4.6.0)
    ##    rprojroot      2.1.1     2025-08-26 [1] CRAN (R 4.6.0)
    ##    RSQLite        2.4.6     2026-02-06 [1] CRAN (R 4.6.0)
    ##    rstudioapi     0.18.0    2026-01-16 [1] CRAN (R 4.6.0)
    ##    s2             1.1.9     2025-05-23 [1] CRAN (R 4.6.0)
    ##    S7             0.2.2     2026-04-22 [1] CRAN (R 4.6.0)
    ##    scales         1.4.0     2025-04-24 [1] CRAN (R 4.6.0)
    ##    sessioninfo    1.2.3     2025-02-05 [1] CRAN (R 4.6.0)
    ##    sf             1.1-1     2026-05-06 [1] CRAN (R 4.6.0)
    ##    stringi        1.8.7     2025-03-27 [1] CRAN (R 4.6.0)
    ##    stringr      * 1.6.0     2025-11-04 [1] CRAN (R 4.6.0)
    ##    testthat     * 3.3.2     2026-01-11 [1] CRAN (R 4.6.0)
    ##    tibble         3.3.1     2026-01-11 [1] CRAN (R 4.6.0)
    ##    tidyhydat    * 1.0.0     2026-02-03 [1] CRAN (R 4.6.0)
    ##    tidyr        * 1.3.2     2025-12-19 [1] CRAN (R 4.6.0)
    ##    tidyselect     1.2.1     2024-03-11 [1] CRAN (R 4.6.0)
    ##    timechange     0.4.0     2026-01-29 [1] CRAN (R 4.6.0)
    ##    tzdb           0.5.0     2025-03-15 [1] CRAN (R 4.6.0)
    ##    units          1.0-1     2026-03-11 [1] CRAN (R 4.6.0)
    ##    usethis        3.2.1     2025-09-06 [1] CRAN (R 4.6.0)
    ##    utf8           1.2.6     2025-06-08 [1] CRAN (R 4.6.0)
    ##    vctrs          0.7.3     2026-04-11 [1] CRAN (R 4.6.0)
    ##    visdat         0.6.0     2023-02-02 [1] CRAN (R 4.6.0)
    ##    vroom          1.7.1     2026-03-31 [1] CRAN (R 4.6.0)
    ##    waldo          0.6.2     2025-07-11 [1] CRAN (R 4.6.0)
    ##  P weathercan   * 0.7.8     2026-05-05 [?] local
    ##    withr          3.0.2     2024-10-28 [1] CRAN (R 4.6.0)
    ##    wk             0.9.5     2025-12-18 [1] CRAN (R 4.6.0)
    ##    xfun           0.57      2026-03-20 [1] CRAN (R 4.6.0)
    ##    xml2           1.5.2     2026-01-17 [1] CRAN (R 4.6.0)
    ## 
    ##  [1] /home/steffi/R/x86_64-pc-linux-gnu-library/4.6
    ##  [2] /usr/local/lib/R/site-library
    ##  [3] /usr/lib/R/site-library
    ##  [4] /usr/lib/R/library
    ## 
    ##  * ── Packages attached to the search path.
    ##  P ── Loaded and on-disk path mismatch.
    ## 
    ## ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
