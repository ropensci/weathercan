.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "weathercan v", utils::packageVersion("weathercan"), "\n",
    "The included data `stations` has been ",
    "deprecated in favour of the function `stations()`.\n",
    "See ?stations for more details.")
}

#' Easy downloading of weather data from Environment and Climate Change Canada
#'
#' \code{weathercan} is an R package for simplifying the downloading of
#' Historical Climate Data from the Environment and Climate Change Canada (ECCC)
#' website (<https://climate.weather.gc.ca>)
#'
#' Bear in mind that these downloads can be fairly large and performing
#' repeated, large downloads may use up Environment Canada's bandwidth
#' unnecessarily. Try to stick to what you need.
#'
#' There are four main aspects of this package:
#'
#' 1. Access **stations** lists
#'     - [`stations`] (a data frame listing stations)
#'     - [`stations_search()`] identify stations by name or proximity to a
#'     location
#'     - [`stations_dl()`] re-download/update stations data
#'
#'  2. Download **weather** data
#'    - [`weather_dl()`]
#'
#'  3. Merge **weather** data into other data sets through interpolation
#'  over time
#'    - [`weather_interp()`]
#'
#'  4. Download **climate normals** data
#'    - [`normals_dl()`]
#'
#' We also include several practice data sets:
#'
#'  - [`finches`]
#'  - [`kamloops`]
#'  - [`kamloops_day`]
#'  - [`pg`]
#'
#' As well as several vignettes:
#'
#'  - General Usage: `vignette("usage")`
#'  - Merging and Interpolating: `vignette("interpolation")`
#'  - Flags and Codes: `vignette("flags")`
#'  - Weather Data Glossary: `vignette("glossary")`
#'  - Climate Normals Glossary: `vignette("glossary_normals")`
#'
#' [Online](https://docs.ropensci.org/weathercan/) we also have some
#' advanced articles:
#'
#'  - Using `weathercan` with [tidyverse](https://www.tidyverse.org/)
#'  ([here](https://docs.ropensci.org/weathercan/articles/articles/use_with_tidyverse.html))
#'  - Mapping weather data
#'  ([here](https://docs.ropensci.org/weathercan/articles/articles/mapping.html))
#'
#' @references
#' Environment and Climate Change Canada: <https://www.canada.ca/en/environment-climate-change.html>
#'
#' Glossary of terms <https://climate.weather.gc.ca/glossary_e.html>
#'
#' ECCC Historical Climate Data: <https://climate.weather.gc.ca/>
#'
#'
#' @docType package
#' @name weathercan-package
#' @aliases weathercan weathercan-package
#' @importFrom dplyr "%>%"
#' @importFrom rlang .data

NULL

# Dealing with CRAN Notes due to Non-standard evaluation
.onLoad <- function(libname = find.package("weathercan"),
                    pkgname = "weathercan"){

  # Add caching for functions
  get_html <<- memoise::memoise(get_html, ~memoise::timeout(24 * 60 * 60))
  normals_html <<- memoise::memoise(normals_html, ~memoise::timeout(24 * 60 * 60))

  options(weathercan.urls.weather =
            "https://climate.weather.gc.ca/climate_data/bulk_data_e.html",
          weathercan.urls.normals =
            "https://climate.weather.gc.ca/climate_normals/bulk_data_e.html",
          weathercan.urls.stations =
            paste0("https://drive.google.com/uc?authuser=0&id=",
                   "1egfzGgzUb0RFu_EE5AYFZtsyXPfZ11y2&export=download"),
          weathercan.urls.stations.normals =
          "https://climate.weather.gc.ca/climate_normals/station_inventory_e.html",
          weathercan.time.message = FALSE)

  # CRAN Note avoidance
  if(getRversion() >= "2.15.1")
    utils::globalVariables(
      # Vars used in Non-Standard Evaluations, declare here to
      # avoid CRAN warnings
      c(".", " " # piping requires '.' at times
      )
    )
  invisible()
}
