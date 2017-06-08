#' Easy downloading of weather data from Environment and Climate Change Canada
#'
#' \code{weathercan} is an R package for simplifying the downloading of
#' Historical Climate Data from the Environment and Climate Change Canada (ECCC)
#' \href{http://climate.weather.gc.ca/historical_data/search_historic_data_e.html}{website}
#'
#' Bear in mind that these downloads can be fairly large and performing
#' multiple, downloads may use up Environment Canada's bandwidth unecessarily.
#' Try to stick to what you need.
#'
#' There are three main aspects of this package:
#'
#' \enumerate{
#'   \item Access \strong{stations} lists
#'   \itemize{
#'     \item \code{\link{stations}} (a data frame listing stations)
#'     \item \code{\link{stations_search}()} identify stations by name or
#'     proximity to a location
#'     \item \code{\link{stations_all}()} re-download stations data
#'     }
#'
#'  \item Download \strong{weather} data
#'  \itemize{
#'    \item \code{\link{weather}()}
#'    }
#'
#'  \item Merge weather data into other data sets through interpolation over time
#'  \itemize{
#'    \item \code{\link{add_weather}()}
#'    }
#' }
#'
#' We also include several practice data sets:
#'
#'  \itemize{
#'    \item \code{\link{finches}}
#'    \item \code{\link{kamloops}}
#'    \item \code{\link{kamloops_day}}
#'    \item \code{\link{pg}}
#'    }
#'
#' As well as several vignettes:
#'
#'  \itemize{
#'    \item General Usage: \code{vignette("usage")}
#'    \item Merging and Interpolating: \code{vignette("interpolation")}
#'    }
#'
#' \href{http://steffilazerte.github.io/weathercan}{Online} we also have an advanced article:
#'
#'   \itemize{
#'     \item Using \code{weathercan} with \href{http://tidyverse.org/}{tidyverse} (\href{http://steffilazerte.github.io/weathercan/articles/use_with_tidyverse.html}{here})
#'     }
#'
#' @references
#' Environment and Climate Change Canada: \url{https://www.ec.gc.ca/}
#'
#' Glossary of terms \url{http://climate.weather.gc.ca/glossary_e.html}
#'
#' ECCC Historical Climate Data: \url{http://climate.weather.gc.ca/}
#'
#'
#' @docType package
#' @name weathercan-package
#' @aliases weathercan weathercan-package
NULL

#' Dealing with CRAN Notes due to Non-standard evaluation
#'
.onLoad <- function(libname = find.package("weathercan"), pkgname = "weathercan"){
  # CRAN Note avoidance
  if(getRversion() >= "2.15.1")
    utils::globalVariables(
      # Vars used in Non-Standard Evaluations, declare here to avoid CRAN warnings
      c("Province", "Name", "Station.ID", "Climate.ID", "WMO.ID", "TC.ID",
        "type", "station_name", "station_id", "lat", "lon", "WMO_id", "TC_id", "prov", "distance",
        "flag", "hmdx", "pressure", "rel_hum", "temp_dew", "visib", "wind_chill",
        "variable", "value", "qual",
        "." # piping requires '.' at times
      )
    )
  invisible()
}
