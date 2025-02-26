# Renders the .Rmd.orig files to .Rmd files. This is considered "half-rendering"
# because it creates .Rmd files that will get rendered by ROpenSci during the site
# builds that they run on Jenkins.
# see https://ropensci.org/blog/2019/12/08/precompute-vignettes/
# Inspired by https://github.com/ropensci/patentsview/blob/master/vignettes/build.R

cur_dir <- getwd()
on.exit(setwd(cur_dir))

directories <- c("vignettes", "vignettes/articles")

for (directory in directories) {
  setwd(directory)
  print(paste("Directory", directory))
  source_files <- list.files(pattern = "\\.Rmd\\.orig$")
  for (file in source_files) {
    print(paste("  Knitting", file))
    knitr::knit(file, gsub("\\.orig$", "", file))
  }

  setwd(cur_dir)
}
