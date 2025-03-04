# Pre-compile vignettes which depend on API access
library(knitr)
library(readr)
library(stringr)

# Make sure to put figures in local dir in knitr chunk options

v <- list.files("vignettes", ".orig$", full.names = TRUE, recursive = TRUE)

for(i in v) {
  new <- stringr::str_remove(i, ".orig$")
  knit(i, new)

  read_lines(new) %>%
    str_replace_all("\"vignettes(/articles)*/", "\"") %>%
    write_lines(new)
}

unlink("./vignettes/normals_cache/", recursive = TRUE)
unlink("./vignettes/articles/tidyhydat_cache/", recursive = TRUE)

# build vignette
#devtools::build_vignettes()
#unlink("./doc/", recursive = TRUE)
#unlink("./Meta/", recursive = TRUE)
