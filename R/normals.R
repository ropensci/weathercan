#' Download climate normals from Environment and Climate Change Canada
#'
#' Downloads climate normals from Environment and Climate Change Canada (ECCC) for one or
#' more stations (defined by `climate_id`s). For details and units, see the glossary-normals vignette
#' (\code{vignette("glossary", package = "weathercan")}) or the glossary online
#' \url{http://climate.weather.gc.ca/glossary_e.html}.
#'
#' @param climate_ids Character. A vector containing the Climate ID(s) of the
#'   station(s) you wish to download data from. See the \code{\link{stations}}
#'   data frame or the \code{\link{stations_search}} function to find Climate
#'   IDs.
#' @param normals_years Character. The year range for which you want climate
#'   normals. Default "1981-2010".
#' @inheritParams weather_dl
#'
#' @return tibble with nested normals and first/last frost data
#'
#' @examples
#'
#' normals_dl(climate_ids = c("3010234", "3010410", "3010815"))
#'
#' normals_dl(climate_ids = "5010480")
#'
#' @export

normals_dl <- function(climate_ids, normals_years = "1981-2010",
                       format = TRUE, stn = weathercan::stations,
                       url = NULL, verbose = FALSE, quiet = FALSE) {

  check_ids(climate_ids, stn, type = "climate_id")
  check_normals(normals_years)

  n <- dplyr::filter(stn, climate_id %in% climate_ids) %>%
    dplyr::select(.data$prov, .data$station_name,
                  .data$climate_id, .data$normals) %>%
    dplyr::distinct()

  if(nrow(n) == 0) stop("No stations matched these climate ids", call. = FALSE)

  if(all(n$normals == FALSE)) {
    stop("No stations had climate normals available", .call = FALSE)
  } else if(any(n$normals == FALSE)) {
    message("Not all stations have climate normals available (climate ids: ",
            paste0(n$climate_id[!s$normals], collapse = ", "), ")")
    n <- dplyr::filter(n, .data$normals == TRUE)
  }

  n <- dplyr::mutate(n, url = normals_url(.data$prov,
                                          .data$climate_id,
                                          normals_years, url)) %>%
    dplyr::select(-normals)

  # Get skip value
  headings <- try(readLines(con <- url(n$url[1], encoding = "latin1"), n = 20),
                  silent = TRUE)
  close(con)

  if("try-error" %in% class(headings)) {
    stop("'url' must point to a csv file either local or online.")
  }
  skip <- find_skip(headings, cols = c("Jan", "Feb", "Mar"))

  # Download data
  n <- dplyr::mutate(n,
                     data = purrr::map(.data$url, ~ normals_raw(., skip)),
                     frost = purrr::map(.data$data, ~ frost_find(.)),
                     data = purrr::map2(.data$data, .data$climate_id,
                                        ~ normals_extract(.x, climate_id = .y)),
                     frost = purrr::map(.data$frost, ~ frost_extract(.)),
                     n_data = purrr::map_dbl(data, nrow),
                     n_frost = purrr::map_dbl(frost, nrow))

  if(any(no_data <- n$n_data + n$n_frost == 0)) {
    message("All climate normals missing for some stations (climate_ids: ",
            paste0(n$climate_id[no_data], collapse = ", "), ")")
  }

  dplyr::select(n, -"n_data", -"n_frost")
}

normals_url <- function(prov, climate_id, normals_years, url = NULL) {
  if(is.null(url)) {
    url <- paste0("https://dd.meteo.gc.ca/climate/observations/",
                  "normals/csv")
  } else {
    check_url(url)
  }

  url <- paste0(url, "/", normals_years)

  # Check if year-range present
  if(httr::http_error(httr::GET(url))) {
    stop("Climate normals are not available for years ", normals_years, call. = FALSE)
  }
  paste0(url, "/", prov,
         "/climate_normals_", prov, "_", climate_id, "_", normals_years, ".csv")
}

normals_raw <- function(url, skip = 14,
                        nrows = -1,
                        header = TRUE) {

  # Check if file present
  status <- httr::GET(url)
  httr::stop_for_status(status,
                        paste0("access climate normals for this ",
                               "station (climate id: " ,
                               stringr::str_extract(url, "[0-9A-Z]{7}"),
                               ")"))

  # Download file
  d <- readLines(con <- url(url, encoding = "latin1"), n = nrows)
  close(con)
  if(!is.null(skip)) d <- d[(skip + 1):length(d)]
  d
}


normals_extract <- function(n, climate_id) {

  # Remove frost dates
  n <- frost_find(n, type = "remove")

  # Read normals
  n <- utils::read.csv(text = n, check.names = FALSE, stringsAsFactors = FALSE)

  if(nrow(n) == 0) return(data.frame())

  # Line up names to deal with duplicate variable names
  n <- n %>%
    dplyr::rename("variable" = ` `) %>%
    dplyr::mutate(variable = tolower(variable))

  # Mark title variables align variable names accordingly
  nn <- dplyr::filter(n_names,
                      stringr::str_detect(new_var, "title"),
                      variable %in% n$variable)
  nn <- dplyr::filter(n_names, group %in% nn$group)  # Remove missing groups

  # Detect missing measurements
  missing_data <- dplyr::filter(nn, type == "unique") %>%
    dplyr::anti_join(dplyr::select(n, "variable"), by = "variable")
  nn <- dplyr::filter(nn, !new_var %in% missing_data$new_var)

  # Detect extra measurements not expected
  missing_names <- dplyr::anti_join(dplyr::select(n, "variable"),
                                    nn, by = "variable")

  if(nrow(missing_names) > 0) {
    stop("Not all variables for climate station ", climate_id,
         " were identified. Please report this here: ",
         "https://github.com/ropensci/weathercan/issues", call. = FALSE)
  }

  # Add new, unique measurement names
  n_nice <- n %>%
    dplyr::mutate(new_var = nn$new_var)

  # Check name order
  if(!all(nn$variable[nn$new_var %in% n_nice$new_var] == n$variable)) {
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
    dplyr::select(-"Code", -"variable") %>%
    tidyr::gather(key = "period", value = "measure", -"new_var") %>%
    tidyr::spread(key = "new_var", value = "measure") %>%
    # Add Codes
    cbind(codes)

  # Column order
  o <- c(rbind(nn$new_var, paste0(nn$new_var, "_code")))
  n_nice <- dplyr::select(n_nice, "period", !!o)

  # Row order
  o <- names(n)[!names(n) %in% c("variable", "Code")]
  n_nice %>%
    dplyr::mutate(period = factor(.data$period, levels = o)) %>%
    dplyr::arrange(period) %>%
    dplyr::as_tibble()
}

frost_extract <- function(f) {

  if(all(f == "")) return(data.frame())

  # Frost free days overall
  f1 <- utils::read.csv(text = f[1:3], check.names = FALSE, header = FALSE,
                        col.names = c("variable", "value", "code")) %>%
    tidyr::spread(key = "variable", value = "value")

  n <- f_names[f_names %in% names(f1)]
  f1 <- dplyr::rename(f1, !!!n) %>%
    dplyr::mutate_at(.vars = dplyr::vars(dplyr::contains("date")),
                     ~lubridate::yday(lubridate::as_date(paste0("1999", .)))) %>%
    dplyr::mutate(length_frost_free = stringr::str_extract(length_frost_free,
                                                           "[0-9]*"),
                  length_frost_free = as.numeric(length_frost_free))

  # Frost free probabilities
  f2 <- utils::read.csv(text = f[4:length(f)], header = FALSE, stringsAsFactors = FALSE)
  f2 <- data.frame(prob = rep(c("10%", "25%", "33%", "50%", "66%", "75%", "90%"), 3),
                   value = c(t(f2[2, 2:8]), t(f2[4, 2:8]), t(f2[6, 2:8])),
                   measure = c(rep(f2[1,1], 7), rep(f2[3,1], 7), rep(f2[5,1], 7))) %>%
    tidyr::spread("measure", "value")

  n <- f_names[f_names %in% names(f2)]
  f2 <- dplyr::rename(f2, !!n)

  cbind(f1, f2)
}

frost_find <- function(n, type = "extract") {
  frost <- stringr::str_which(n, "station data \\(Frost-Free\\)")
  if(length(frost) == 1) {
    if(type == "extract") r <- n[(frost + 2):length(n)]
    if(type == "remove") r <- n[1:(frost-1)]
  } else {
    if(type == "extract") r <- ""
    if(type == "remove") r <- n
  }
  r
}
