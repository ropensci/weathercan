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
#' As well as several vignettes available in the package and [Online](https://docs.ropensci.org/weathercan/):
#'
#'  - [General Usage](https://docs.ropensci.org/weathercan/articles/weathercan.html): `vignette("weathercan", package = "weathercan")`
#'  - [Interpolating](https://docs.ropensci.org/weathercan/articles/interpolate_data.html): `vignette("interpolation", package = "weathercan")`
#'  - [Reproducibility](https://docs.ropensci.org/weathercan/articles/reproducibility.html): `vignette("reproducibility", package = "weathercan")`
#'  - [Flags and Codes](https://docs.ropensci.org/weathercan/articles/flags.html): `vignette("flags", package = "weathercan")`
#'  - [Weather: Terms and Units](https://docs.ropensci.org/weathercan/articles/glossary.html): `vignette("glossary", package = "weathercan")`
#'  - [Climate Normals: Terms and Units](https://docs.ropensci.org/weathercan/articles/glossary_normals.html): `vignette("glossary_normals", package = "weathercan")`
#'
#' We also have some advanced articles:
#'
#'  - [Using `weathercan` with tidyhydat](https://docs.ropensci.org/weathercan/articles/tidyhydat.html))
#'
#' @references
#' Environment and Climate Change Canada: <https://www.canada.ca/en/environment-climate-change.html>
#'
#' Glossary of terms <https://climate.weather.gc.ca/glossary_e.html>
#'
#' ECCC Historical Climate Data: <https://climate.weather.gc.ca/>
#'
#'
#' @keywords internal
"_PACKAGE"
#' @importFrom dplyr "%>%"
#' @importFrom rlang .data .env
NULL

# Dealing with CRAN Notes due to Non-standard evaluation
.onLoad <- function(
  libname = find.package("weathercan"),
  pkgname = "weathercan"
) {
  # Add caching for functions
  get_html <<- memoise::memoise(get_html, ~ memoise::timeout(24 * 60 * 60))
  normals_html <<- memoise::memoise(
    normals_html,
    ~ memoise::timeout(24 * 60 * 60)
  )

  options(
    weathercan.urls.weather = "https://climate.weather.gc.ca/climate_data/bulk_data_e.html",
    weathercan.urls.normals = "https://climate.weather.gc.ca/climate_normals/bulk_data_e.html",
    # Download from google drive: https://stackoverflow.com/a/50533232/3362144
    weathercan.urls.stations = paste0(
      "https://collaboration.cmc.ec.gc.ca/cmc/climate/",
      "Get_More_Data_Plus_de_donnees/Station%20Inventory%20EN.csv"
    ),
    #weathercan.urls.stations =
    #  paste0("https://drive.google.com/uc?export=download&id=",
    #         "1HDRnj41YBWpMioLPwAFiLlK4SK8NV72C"),
    weathercan.urls.stations.normals = "https://climate.weather.gc.ca/climate_normals/station_inventory_e.html",
    weathercan.time.message = FALSE
  )

  # CRAN Note avoidance
  if (getRversion() >= "2.15.1") {
    utils::globalVariables(
      # Vars used in Non-Standard Evaluations, declare here to
      # avoid CRAN warnings
      c(
        ".",
        " " # piping requires '.' at times
      )
    )
  }
  invisible()
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "As of v0.7.2, the `normals` column in `stations()` reflects whether or not ",
    "there\nare *any* normals available (not just the most recent)."
  )
}
