#' Download climate normals from Environment and Climate Change Canada
#'
#' Downloads climate normals from Environment and Climate Change Canada (ECCC)
#' for one or more stations (defined by `climate_id`s). For details and units,
#' see the [`glossary_normals`] data frame or the `glossary_normals` vignette:
#' \code{vignette("glossary_normals", package = "weathercan")}
#'
#' @param climate_ids Character. A vector containing the Climate ID(s) of the
#'   station(s) you wish to download data from. See the \code{\link{stations}}
#'   data frame or the \code{\link{stations_search}} function to find Climate
#'   IDs.
#' @param normals_years Character. The year range for which you want climate
#'   normals. Default "1981-2010".
#' @param format Logical. If TRUE (default) formats measurements to numeric and
#'   date accordingly. Unlike `weather_dl()`, `normals_dl()` will always format
#'   column headings as normals data from ECCC cannot be directly made into a
#'   data frame without doing so.
#' @inheritParams weather_dl
#'
#' @details Climate normals from ECCC include two types of data, averages by
#'   month for a variety of measurements as well as data relating to the
#'   frost-free period. Because these two data sources are quite different, we
#'   return them as nested data so the user can extract them as they wish. See
#'   examples for how to use the `unnest()` function from the [`tidyr`](https://tidyr.tidyverse.org/)
#'   package to extract the two different datasets.
#'
#'   The data also returns a column called `meets_wmo` this reflects whether or
#'   not the climate normals for this station met the WMO standards for
#'   temperature and precipitation (i.e. both have code >= A). Each measurement
#'   column has a corresponding `_code` column which reflects the data quality
#'   of that measurement (see the [ECCC calculations
#'   document](http://climate.weather.gc.ca/doc/Canadian_Climate_Normals_1981_2010_Calculation_Information.pdf)
#'   for more details)
#'
#'   Climate normals are downloaded from the url stored in option
#'   `weathercan.urls.normals`. To change this location use:
#'   `options(weathercan.urls.normals = "your_new_url")`.
#'
#' @return tibble with nested normals and first/last frost data
#'
#' @examples
#' \dontrun{
#' # Find the climate_id
#' stations_search("Brandon A", normals_only = TRUE)
#'
#' # Download climate normals
#' n <- normals_dl(climate_ids = "5010480")
#'
#' # Pull out last frost data
#' library(tidyr)
#' f <- unnest(n, frost)
#'
#' # Pull out normals
#' nm <- unnest(n, normals)
#'
#' # Download multiple stations
#' n <- normals_dl(climate_ids = c("3010234", "3010410", "3010815"))
#' n
#'
#' # Note that some have files online but no data
#' n$normals[2]
#'
#' # Some have no last frost data
#' n$frost[3]
#'
#' # Note, putting both into the same data set can be done but makes for
#' # a very unweildly dataset (there is lots of repetition)
#' nm <- unnest(n, normals)
#' f <- unnest(n, frost)
#' both <- dplyr::full_join(nm, f)
#' }
#'
#' @export

normals_dl <- function(climate_ids, normals_years = "1981-2010",
                       format = TRUE, stn = weathercan::stations,
                       verbose = FALSE, quiet = FALSE) {

  check_ids(climate_ids, stn, type = "climate_id")
  check_normals(normals_years)

  n <- dplyr::filter(stn, .data$climate_id %in% climate_ids) %>%
    dplyr::select(.data$prov, .data$station_name,
                  .data$climate_id, .data$normals) %>%
    dplyr::distinct() %>%
    dplyr::mutate(climate_id = as.character(.data$climate_id))

  if(nrow(n) == 0) stop("No stations matched these climate ids", call. = FALSE)

  if(all(n$normals == FALSE)) {
    stop("No stations had climate normals available", call. = FALSE)
  } else if(any(n$normals == FALSE)) {
    message("Not all stations have climate normals available (climate ids: ",
            paste0(n$climate_id[!n$normals], collapse = ", "), ")")
    n <- dplyr::filter(n, .data$normals == TRUE)
  }

  n <- dplyr::mutate(n,
                     loc = normals_url(.data$prov,
                                       .data$climate_id,
                                       normals_years)) %>%
    dplyr::select(-"normals")

  # Download data
  n <- dplyr::mutate(n,
                     normals = purrr::map(.data$loc, normals_raw),
                     meets_wmo = purrr::map_lgl(.data$normals, meets_wmo),
                     normals = purrr::map(.data$normals, normals_extract),
                     frost = purrr::map(.data$normals, frost_find),
                     normals = purrr::map2(.data$normals, .data$climate_id,
                                        ~ data_extract(.x, climate_id = .y)),
                     frost = purrr::map2(.data$frost, .data$climate_id,
                                         ~ frost_extract(.x, climate_id = .y)),
                     n_data = purrr::map_dbl(.data$normals, nrow),
                     n_frost = purrr::map_dbl(.data$frost, nrow))

  if(any(no_data <- n$n_data + n$n_frost == 0)) {
    message("All climate normals missing for some stations (climate_ids: ",
            paste0(n$climate_id[no_data], collapse = ", "), ")")
  }

  # Format dates etc.
  n <- dplyr::mutate(n,
                     normals = purrr::map2(.data$normals,
                                           .data$climate_id,
                                           data_format),
                     frost = purrr::map2(.data$frost,
                                         .data$climate_id,
                                         frost_format))

  dplyr::select(n, "prov", "station_name", "climate_id",
                "meets_wmo", "normals", "frost")
}

normals_url <- function(prov, climate_id, normals_years) {

  check_url(getOption("weathercan.urls.normals"))

  loc <- paste0(getOption("weathercan.urls.normals"), "/", normals_years)

  # Check if year-range present
  check_url(loc, task = paste0("access climate normals for years ", normals_years))

  paste0(loc, "/", prov,
         "/climate_normals_", prov, "_", climate_id, "_", normals_years, ".csv")
}

normals_raw <- function(loc,
                        nrows = -1) {
  # Check if file present
  status <- httr::GET(loc)
  httr::stop_for_status(status,
                        paste0("access climate normals for this ",
                               "station (climate id: " ,
                               stringr::str_extract(loc, "[0-9A-Z]{7}"),
                               ")"))

  # Download file
  httr::GET(loc) %>%
    httr::content(as = "text", encoding = "latin1") %>%
    stringr::str_split(pattern = "\n") %>%
    unlist()
}


normals_extract <- function(n, return = "data") {
  wmo <- find_line(n, cols = "meets WMO standards")
  skip <- find_line(n, cols = c("Jan", "Feb", "Mar"))
  if(return == "data") {
    if(length(wmo) > 0) {
      n <- n[c(wmo, skip:length(n))]
    } else {
      n <- n[skip:length(n)]
    }
    # Remove WMO if exists
    if(stringr::str_detect(n[1], "WMO standards")) n <- n[-1]

    # Remove empty strings if they exist
    n <- stringr::str_remove_all(n, "[,]{2,}$")
  }
  n
}


data_extract <- function(n, climate_id) {

  # Remove frost dates
  n <- frost_find(n, type = "remove")

  # Read normals
  n <- utils::read.csv(text = n, check.names = FALSE, stringsAsFactors = FALSE)

  if(nrow(n) == 0) return(dplyr::tibble())

  # Line up names to deal with duplicate variable names
  names(n)[1] <- "variable"
  n <- dplyr::mutate(n, variable = tolower(.data$variable))

  # Mark title variables align variable names accordingly
  nn <- dplyr::filter(n_names,
                      stringr::str_detect(.data$new_var, "title"),
                      .data$variable %in% n$variable)
  # Remove missing groups
  nn <- dplyr::filter(n_names, .data$group %in% nn$group)

  # Detect missing measurements
  missing_data <- dplyr::filter(nn, .data$type == "unique") %>%
    dplyr::anti_join(dplyr::select(n, "variable"), by = "variable")
  nn <- dplyr::filter(nn, !.data$new_var %in% missing_data$new_var)

  # Remove leftover missing subgroups
  nn <- dplyr::group_by(nn, .data$subgroup) %>%
    dplyr::filter(!all(.data$type == "sub")) %>%
    dplyr::ungroup()

  # Make subgroups unique
  n <- dplyr::left_join(n,
                        dplyr::filter(nn, .data$type != "sub") %>%
                          dplyr::select("variable", "subgroup"),
                        by = "variable")
  for(i in 1:nrow(n)) {
    if(is.na(n[["subgroup"]][i])) n[["subgroup"]][i] <- n[["subgroup"]][i-1]
  }

  n <- dplyr::mutate(n, variable_sub =
                       paste0(.data$variable, "_", .data$subgroup))

  # Detect extra measurements not expected
  missing_names <- dplyr::anti_join(dplyr::select(n, "variable_sub"),
                                    nn, by = "variable_sub")

  if(nrow(missing_names) > 0) {
    stop("Not all variables for climate station ", climate_id,
         " were identified.\nPlease report this here: ",
         "https://github.com/ropensci/weathercan/issues", call. = FALSE)
  } else if (nrow(nn) != nrow(n)) {
    stop("Variables for climate station ", climate_id,
         " were misidentified. Please report this here: ",
         "https://github.com/ropensci/weathercan/issues", call. = FALSE)
  }

  # Join new, unique measurement names by sub labels
  n_nice <- dplyr::left_join(n, dplyr::select(nn, "new_var", "variable_sub"),
                             by = "variable_sub")

  # Check for problems
  if(!all(nn$variable[nn$new_var %in% n_nice$new_var] %in% n$variable)) {
    stop("Variable names did not align correctly during formating, ",
         "consider using 'format = FALSE' and/or reporting this error.",
         .call = FALSE)
  }

  # Remove titles
  nn <- dplyr::filter(nn, !stringr::str_detect(.data$new_var, "title"))
  n_nice <- dplyr::filter(n_nice, !stringr::str_detect(.data$new_var, "title"))

  # Get codes
  codes <- dplyr::select(n_nice, "code" = "Code", "new_var") %>%
    dplyr::mutate(new_var = paste0(.data$new_var, "_code")) %>%
    tidyr::spread(key = "new_var", value = "code")

  # Spread variables
  n_nice <- n_nice %>%
    dplyr::select(-"Code", -"variable", -"subgroup", -"variable_sub") %>%
    tidyr::gather(key = "period", value = "measure", -"new_var") %>%
    tidyr::spread(key = "new_var", value = "measure") %>%
    # Add Codes
    cbind(codes)

  # Column order
  o <- c(rbind(nn$new_var, paste0(nn$new_var, "_code")))
  n_nice <- dplyr::select(n_nice, "period", !!o)

  # Row order
  o <- names(n)[!names(n) %in% c("variable", "Code", "subgroup", "variable_sub")]
  n_nice %>%
    dplyr::mutate(period = factor(.data$period, levels = o)) %>%
    dplyr::arrange(.data$period) %>%
    dplyr::as_tibble()
}

data_format <- function(n, climate_id) {
  fmts <- dplyr::filter(n_formats, .data$new_var %in% names(n))
  dates <- dplyr::filter(fmts, .data$format == "date") %>%
    dplyr::pull("new_var")
  nums <- dplyr::filter(fmts, .data$format == "numeric") %>%
    dplyr::pull("new_var")
  chars <- dplyr::filter(fmts, .data$format == "character") %>%
    dplyr::pull("new_var")

  # Prepare dates (if missing, NA)
  n_fmt <- n %>%
    dplyr::mutate_at(.vars = dates,
                     ~dplyr::if_else(. == "", as.character(NA),
                                     paste0(., "/", as.numeric(period)))) %>%
    dplyr::mutate_at(.vars = dates,
                     ~dplyr::if_else(period == "Year", as.character(NA), .))

  # In case of warnings
  tryCatch({n_fmt <- dplyr::mutate_at(n_fmt, .vars = dates, ~lubridate::ydm(.))},
           warning = function(w) stop(climate_id,
                                      " has a formating issue with dates",
                                      call. = FALSE))
  tryCatch({n_fmt <- dplyr::mutate_at(n_fmt, .vars = nums, as.numeric)},
           warning = function(w) stop(climate_id,
                                      " has a formating issue with numbers",
                                      call. = FALSE))
  tryCatch({n_fmt <- dplyr::mutate_at(n_fmt, .vars = chars,
                                      ~dplyr::if_else(. == "",
                                                      as.character(NA),
                                                      as.character(.)))},
           warning = function(w) stop(climate_id,
                                      " has a formating issue with characters",
                                      call. = FALSE))
  n_fmt
}

frost_extract <- function(f, climate_id) {

  if(all(f == "")) return(dplyr::tibble())

  frost_free <- stringr::str_which(f, f_names$variable[f_names$group == 1][1])
  frost_probs <- stringr::str_which(f, f_names$variable[f_names$group == 2][1])

  # Frost free days overall
  if(length(frost_free) > 0) {
    if(length(frost_probs) == 0) last <- length(f) else last <- frost_probs - 1

    f1 <- utils::read.csv(text = f[frost_free:last],
                          check.names = FALSE, header = FALSE,
                          col.names = c("variable", "value", "frost_code")) %>%
      tidyr::spread(key = "variable", value = "value")

    n <- tibble_to_list(f_names[f_names$variable %in% names(f1),
                                c("new_var", "variable")])
    f1 <- dplyr::rename(f1, !!n) %>%
      dplyr::mutate_at(.vars = dplyr::vars(dplyr::contains("date")),
                       ~lubridate::yday(lubridate::as_date(paste0("1999", .)))) %>%
      dplyr::mutate(length_frost_free =
                      stringr::str_extract(.data$length_frost_free, "[0-9]*"),
                    length_frost_free = as.numeric(.data$length_frost_free))
  } else f1 <- na_tibble(f_names$new_var[f_names$group == 1])

  # Frost free probabilities
  if(length(frost_probs) > 0) {
    f2 <- utils::read.csv(text = f[frost_probs:length(f)],
                          header = FALSE, stringsAsFactors = FALSE)
    f2 <- data.frame(prob = rep(c("10%", "25%", "33%", "50%",
                                  "66%", "75%", "90%"), 3),
                     value = c(t(f2[2, 2:8]), t(f2[4, 2:8]), t(f2[6, 2:8])),
                     measure = c(rep(f2[1,1], 7), rep(f2[3,1], 7),
                                 rep(f2[5,1], 7))) %>%
      tidyr::spread("measure", "value")

    n <- tibble_to_list(f_names[f_names$variable %in% names(f2),
                                c("new_var", "variable")])

    f2 <- dplyr::rename(f2, !!n)
  } else f2 <- na_tibble(f_names$new_var[f_names$group == 2])

  if(nrow(f1) == 0 & nrow(f2) == 0) {
    r <- cbind(f1, f2)
  } else {
    r <- dplyr::full_join(
      dplyr::mutate(f1, climate_id = climate_id),
      dplyr::mutate(f2, climate_id = climate_id), by = "climate_id") %>%
      dplyr::select(-climate_id)
  }

  dplyr::as_tibble(r)
}

frost_find <- function(n, type = "extract") {

  frost <- find_line(n, "station data \\(Frost-Free\\)")

  # If no frost-free title, look for next measurement

  if(length(frost) == 0) {
    for(i in f_names$variable) {
      frost <- find_line(n, i)
      if(length(frost) != 0) break
    }
  }

  if(length(frost) == 1) {
    if(type == "extract") r <- n[(frost):length(n)]
    if(type == "remove") r <- n[1:(frost-1)]
  } else {
    if(type == "extract") r <- ""
    if(type == "remove") r <- n
  }
  r
}

frost_format <- function(f, climate_id) {
  fmts <- dplyr::filter(f_formats, .data$new_var %in% names(f))
  dates <- dplyr::filter(fmts, .data$format == "date") %>%
    dplyr::pull("new_var")
  nums <- dplyr::filter(fmts, .data$format == "numeric") %>%
    dplyr::pull("new_var")
  chars <- dplyr::filter(fmts, .data$format == "character") %>%
    dplyr::pull("new_var")

  f_fmt <- dplyr::mutate_at(f, .vars = dates,
                            ~dplyr::if_else(. == "" | is.na(.), as.character(NA),
                                            paste0(., " 1999")))

  # In case of warnings
  tryCatch({f_fmt <- dplyr::mutate_at(f_fmt, .vars = dates,
                                      ~lubridate::yday(lubridate::mdy(.)))},
           warning = function(w) stop(climate_id,
                                      " has a formating issue with dates",
                                      call. = FALSE))
  tryCatch({f_fmt <- dplyr::mutate_at(f_fmt, .vars = nums,
                                      ~as.numeric(as.character(.)))},
           warning = function(w) stop(climate_id,
                                      " has a formating issue with numbers",
                                      call. = FALSE))
  tryCatch({f_fmt <- dplyr::mutate_at(f_fmt, .vars = chars,
                                      ~dplyr::if_else(. == "",
                                                      as.character(NA),
                                                      as.character(.)))},
           warning = function(w) stop(climate_id,
                                      " has a formating issue with characters",
                                      call. = FALSE))
  f_fmt
}

meets_wmo <- function(n) {
  start <- stringr::str_which(n, "STATION_NAME")
  any(stringr::str_detect(n[start:(start+1)], "\\*"))
}
