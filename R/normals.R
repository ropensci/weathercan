#' Download climate normals from Environment and Climate Change Canada
#'
#' Downloads climate normals from Environment and Climate Change Canada (ECCC)
#' for one or more stations (defined by `climate_id`s). For details and units,
#' see the [`glossary_normals`], [`variables_normals_old`], and
#' [`variables_normals_new`] included data sets and/or the `glossary_normals`
#' vignette: \code{vignette("glossary_normals", package = "weathercan")}.
#'
#' @param climate_ids Character. A vector containing the Climate ID(s) of the
#'   station(s) you wish to download data from. See the [stations()]
#'   data frame or the [stations_search()] function to find Climate
#'   IDs.
#' @param normals_years Character. The year range for which you want climate
#'   normals. Default `current` (i.e. 1991-2020). One of `current`, `1991-2020`,
#'   `1981-2010`, or `1971-2000`. `current` returns only stations
#'   from the most recent *complete* normals year range (i.e. `1991-2020`).
#' @param format Logical. If TRUE (default) formats measurements to numeric and
#'   date accordingly. Unlike `weather_dl()`, `normals_dl()` will always format
#'   column headings as normals data from ECCC cannot be directly made into a
#'   data frame without doing so.
#' @param measurement_type Character vector. Measurement types (called element
#'   groups in original ECCC data) to include in normals data (only relevant for
#'   new normals >= `1991-2020`). Will return only the measurements included in
#'   the these groups. If `NULL` (default) returns all normals measurements.
#'   See `normals_measurement_types` of a list of types and which measurements
#'   are included.
#'
#' @details The format and method of downloading climate normals from ECCC
#' varies by year span.
#'
#' Regardless of year, each normals measurement column has a corresponding
#' `_code` column which reflects the data quality of that measurement (see the
#' [1991-2020](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1991_2020_Calculation_Information.pdf),
#' [1981-2010](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1981_2010_Calculation_Information.pdf),
#' or
#' [1971-2000](https://collaboration.cmc.ec.gc.ca/cmc/climate/Normals/Canadian_Climate_Normals_1971_2000_Calculation_Information.pdf)
#' for more details) ECCC calculation documents.
#'
#' ## Newer normals (1991-2020)
#' Newer normals from ECCC are provided in one bulk downloaded which weathercan
#' will fetch and store in a local cache directory ([cache_dir()]). Then
#' `normals_dl()` will read, filter, format, and return the climate normals in a
#' data frame easier to work with in R than the original data.
#'
#' These normals are also provided in a single table, so both 'normals' and
#' 'frost' data are combined in one.
#'
#' Newer climate normals are downloaded from the url stored in option
#' `weathercan.urls.normals_1991_2020`. To change this location use:
#' `options(weathercan.urls.normals_1991_2020 = "your_new_url")`.
#'
#' ## Older normals (1981-2010 and earlier)
#' Older normals from ECCC are provided by individual file downloads which
#' weathercan will fetch, format and return as requested (no local on-disk cache
#' storage).
#'
#' These older normals also include two separate data types: averages by month
#' for a variety of measurements as well as data relating to the frost-free
#' period. Because these two data sources are quite different, we return them as
#' nested data so the user can extract them as they wish. See examples for how
#' to use the `unnest()` function from the
#' [`tidyr`](https://tidyr.tidyverse.org/) package to extract the two different
#' datasets.
#'
#' The data also returns a column called `meets_wmo` this reflects whether or
#' not the climate normals for this station met the WMO standards for
#' temperature and precipitation (i.e. both have code >= A).
#'
#' Older climate normals are downloaded from the url stored in option
#' `weathercan.urls.normals`. To change this location use:
#' `options(weathercan.urls.normals = "your_new_url")`.
#'
#' @details @inheritSection weather_dl Verbosity
#'
#' @return For new climate normals, a tibble of normals. For older climate
#' normals, a tibble with *nested* normals and first/last frost data.
#'
#' @examplesIf check_eccc()
#'
#' # Find the climate_id
#' stations_search("Brandon A", normals_years = "current")
#'
#' # Download climate normals 1991-2020 ("current" normals)
#' n <- normals_dl(climate_ids = "5010480")
#' n
#'
#' # Download multiple climate Ids - But only one location!
#' # - 1990-2010 normals use composite stations
#' stations_search("Winnipeg", normals_years = "current")
#' n <- normals_dl(climate_ids = c("502S001", "5023227", "5023222"))
#' unique(dplyr::select(n, "location_name", "composite_stations"))
#'
#' # Download multiple climate Ids
#' n <- normals_dl(climate_ids = c("5010480", "5023222"))
#' unique(dplyr::select(n, "location_name", "composite_stations"))
#'
#' # Download climate normals 1981-2010
#' # - Note: Very different data format from current normals!
#' n <- normals_dl(climate_ids = "5010480", normals_years = "1981-2010")
#'
#' # Pull out last frost data *with* station information
#' library(tidyr)
#' f <- unnest(n, frost)
#' f
#'
#' # Pull out normals *with* station information
#' nm <- unnest(n, normals)
#' nm
#'
#' # Download climate normals 1971-2000
#' n <- normals_dl(climate_ids = "5010480", normals_years = "1971-2000")
#' n
#'
#' # Note that some do not have last frost dates
#' n$frost
#'
#' # Download multiple stations for 1981-2010,
#' n <- normals_dl(
#'   climate_ids = c("301C3D4", "301FFNJ", "301N49A"),
#'   normals_years = "1981-2010"
#' )
#' unnest(n, frost)
#'
#' # Note, putting both normals and frost data into the same data set can be
#' # done, but makes for a very unwieldy dataset (there is lots of repetition).
#' nm <- unnest(n, normals) |>
#'   unnest(frost)
#'
#' @export

normals_dl <- function(
  climate_ids,
  normals_years = "current",
  format = TRUE,
  measurement_type = NULL
) {
  stn <- stations()

  if (missing(normals_years) && !getOption("weathercan.normals.message")) {
    wc_inform(
      "As of weathercan v1.0.0 the default normals are 1991-2020. Note that these normals are in a different format from previous years. See ?normals_dl for more details or use `normals_years = '1981-2010'` to revert to the previous set of normals.\n",
      "This message is shown once per session"
    )
    message("")
    options("weathercan.normals.message" = TRUE)
  }

  check_ids(climate_ids, stn, type = "climate_id")
  normals_years <- check_normals(normals_years)

  # For new normals, download and access locally cached data
  if (normals_years == "1991-2020") {
    return(normals_cached(climate_ids, measurement_type = measurement_type))
  }

  if (!missing(measurement_type)) {
    wc_inform(
      c(
        "The argument `measurement_type` is only used for 'new' normals ",
        "(1991-2020). It has no effect with older normals downloads."
      )
    )
  }

  yrs <- paste0("normals_", stringr::str_replace(normals_years, "-", "_"))

  n <- dplyr::filter(stn, .data$climate_id %in% climate_ids) |>
    dplyr::select(
      "prov",
      "station_name",
      "station_id",
      "climate_id",
      "normals" = dplyr::matches(yrs)
    ) |>
    dplyr::distinct() |>
    dplyr::mutate(climate_id = as.character(.data$climate_id))

  if (!any(n$normals)) {
    wc_stop("No stations had climate normals available")
  } else if (!all(n$normals)) {
    wc_inform(
      "Not all stations have climate normals available (climate ids: ",
      paste0(n$climate_id[!n$normals], collapse = ", "),
      ")"
    )
    n <- dplyr::filter(n, .data$normals) |>
      dplyr::select(-"normals")
  }

  n <- normals_combine(n, normals_years)

  no_data <- n$n_data + n$n_frost == 0
  if (any(no_data)) {
    wc_inform(
      "All climate normals missing for some stations (climate_ids: ",
      paste0(n$climate_id[no_data], collapse = ", "),
      ")"
    )
  }
  # Format dates etc.
  n <- dplyr::mutate(
    n,
    normals_years = !!normals_years,
    normals = purrr::map2(.data$normals, .data$climate_id, data_format),
    frost = purrr::map2(.data$frost, .data$climate_id, frost_format)
  )

  dplyr::select(
    n,
    "prov",
    "station_name",
    "climate_id",
    "normals_years",
    "meets_wmo",
    "normals",
    "frost"
  )
}

#' Download and combine normals data
#'
#' Downloads normals data from ECCC for multiple stations, extracts both
#' regular measurements and frost data, and combines into a single data frame.
#'
#' @param n Data frame. Stations data with prov, station_id, and climate_id
#' @param normals_years Character. Normals years in format YYYY-YYYY
#'
#' @returns Data frame with nested normals and frost data columns
#'
#' @noRd

normals_combine <- function(n, normals_years) {
  # Download data
  n |>
    dplyr::mutate(
      html = purrr::pmap(
        list(.data$prov, .data$station_id, .data$climate_id),
        \(p, s, c) normals_html(p, s, c, normals_years),
        .progress = wc_noise("noisy")
      ),
      normals = purrr::map(.data$html, normals_raw),
      meets_wmo = purrr::map_lgl(.data$normals, meets_wmo),
      normals = purrr::map(.data$normals, normals_extract),
      frost = purrr::map(.data$normals, frost_find),
      normals = purrr::map2(
        .data$normals,
        .data$climate_id,
        \(n, c) data_extract(n, climate_id = c)
      ),
      frost = purrr::map2(
        .data$frost,
        .data$climate_id,
        \(f, c) frost_extract(f, climate_id = c)
      ),
      n_data = purrr::map_dbl(.data$normals, nrow),
      n_frost = purrr::map_dbl(.data$frost, nrow)
    )
}
