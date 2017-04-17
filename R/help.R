#' Easy downloading of weather data from Environment Canada
#'
#' Extended documentation coming soon... see index for details.
#'
#' @references Environment and Climate CHange Canada \url{https://www.ec.gc.ca/?lang=En}.
#' @docType package
#' @name envirocan-package
#' @aliases envirocan envirocan-package
NULL

#' Dealing with CRAN Notes due to Non-standard evaluation
#'
.onLoad <- function(libname = find.package("envirocan"), pkgname = "envirocan"){
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
