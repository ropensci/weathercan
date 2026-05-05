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
#' @inheritParams weather_dl
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
#' n <- normals_dl(climate_ids = "5010480", normals_year = "1981-2010")
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
#' # done, but makes for a very unweildly dataset (there is lots of repetition).
#' nm <- unnest(n, normals) |>
#'   unnest(frost)
#'
#' @export

normals_dl <- function(
  climate_ids,
  normals_years = "current",
  format = TRUE
) {
  stn <- stations()

  check_ids(climate_ids, stn, type = "climate_id")
  normals_years <- check_normals(normals_years)

  # For new normals, download and access locally cached data
  if (normals_years == "1991-2020") {
    return(normals_cached(climate_ids))
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

  # Download data
  n <- n |>
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

normals_html <- function(prov, station_id, climate_id, normals_years) {
  yrs <- stringr::str_extract(normals_years, "^[0-9]{4}")

  q <- list(
    ffmt = "csv",
    lang = "e",
    prov = prov,
    yr = yrs,
    stnID = station_id,
    climate_id = climate_id, #This keeps changing!
    submit = "Download Data"
  )

  # https://climate.weather.gc.ca/climate_normals/bulk_data_e.html?lang=e&prov=MB&stnname=BRANDON&yr=1991&stnID=219000000&climate_id=5010480&submit=Download+Data

  # https://climate.weather.gc.ca/climate_normals/bulk_data_e.html?ffmt=csv&lang=e&prov=MB&yr=1981&stnID=3472&climate_id=5010485&submit=Download+Data

  get_check(
    url = getOption("weathercan.urls.normals"),
    query = q,
    task = "access climate normals"
  )
}

normals_raw <- function(html, nrows = -1) {
  # Extract file
  html |>
    httr2::resp_body_string(encoding = "latin1") |>
    stringr::str_split(pattern = "\n") |>
    unlist() |>
    # Get rid of all special symbols
    stringr::str_remove_all("[^\001-\177]")
}

normals_extract <- function(n, return = "data") {
  wmo <- find_line(n, cols = "meets WMO standards")
  skip <- find_line(n, cols = c("Jan", "Feb", "Mar"))
  if (return == "data") {
    if (length(wmo) > 0) {
      n <- n[c(wmo, skip:length(n))]
    } else {
      n <- n[skip:length(n)]
    }
    # Remove WMO if exists
    if (stringr::str_detect(n[1], "WMO standards")) {
      n <- n[-1]
    }

    # Remove empty strings if they exist
    n <- stringr::str_remove_all(n, "[,]{2,}$")
  }
  n
}


data_extract <- function(n, climate_id) {
  # Remove frost dates
  n <- frost_find(n, type = "remove")

  readr::local_edition(1)

  # Read normals (expect warnings due to header rows, etc.)
  suppressWarnings(n <- readr::read_csv(I(n), col_types = readr::cols()))

  if (nrow(n) == 0) {
    return(dplyr::tibble())
  }

  # Line up names to deal with duplicate variable names
  names(n)[1] <- "variable"
  n <- dplyr::mutate(n, variable = tolower(.data$variable))

  # Mark title variables align variable names accordingly
  nn <- dplyr::filter(
    n_names,
    stringr::str_detect(.data$new_var, "title"),
    .data$variable %in% n$variable
  )
  # Remove missing groups
  nn <- dplyr::filter(n_names, .data$group %in% nn$group)

  # Detect missing measurements
  missing_data <- dplyr::filter(nn, .data$type == "unique") |>
    dplyr::anti_join(dplyr::select(n, "variable"), by = "variable")
  nn <- dplyr::filter(nn, !.data$new_var %in% missing_data$new_var)

  # Remove leftover missing subgroups
  nn <- dplyr::group_by(nn, .data$subgroup) |>
    dplyr::filter(!all(.data$type == "sub")) |>
    dplyr::ungroup()

  # Make subgroups unique
  n <- dplyr::left_join(
    n,
    dplyr::filter(nn, .data$type != "sub") |>
      dplyr::select("variable", "subgroup"),
    by = "variable"
  )
  for (i in seq_len(nrow(n))) {
    if (is.na(n[["subgroup"]][i])) n[["subgroup"]][i] <- n[["subgroup"]][i - 1]
  }

  n <- dplyr::mutate(
    n,
    variable_sub = paste0(.data$variable, "_", .data$subgroup)
  )

  # Detect extra measurements not expected
  missing_names <- dplyr::anti_join(
    dplyr::select(n, "variable_sub"),
    nn,
    by = "variable_sub"
  )

  if (nrow(missing_names) > 0) {
    wc_stop(
      "Not all variables for climate station {climate_id} ",
      "were identified.\nPlease report this here: ",
      "https://github.com/ropensci/weathercan/issues"
    )
  } else if (nrow(nn) != nrow(n)) {
    wc_stop(
      "Variables for climate station {climate_id} were misidentified. ",
      "Please report this here: https://github.com/ropensci/weathercan/issues"
    )
  }

  # Join new, unique measurement names by sub labels
  n_nice <- dplyr::left_join(
    n,
    dplyr::select(nn, "new_var", "variable_sub"),
    by = "variable_sub"
  )

  # Check for problems
  if (!all(nn$variable[nn$new_var %in% n_nice$new_var] %in% n$variable)) {
    wc_stop(
      "Variable names did not align correctly during formating, ",
      "consider using 'format = FALSE' and/or reporting this error."
    )
  }

  # Remove titles
  nn <- dplyr::filter(nn, !stringr::str_detect(.data$new_var, "title"))
  n_nice <- dplyr::filter(n_nice, !stringr::str_detect(.data$new_var, "title"))

  # Get codes
  codes <- dplyr::select(n_nice, "code" = "Code", "new_var") |>
    dplyr::mutate(new_var = paste0(.data$new_var, "_code")) |>
    tidyr::spread(key = "new_var", value = "code")

  # Spread variables
  n_nice <- n_nice |>
    dplyr::select(-"Code", -"variable", -"subgroup", -"variable_sub") |>
    tidyr::gather(key = "period", value = "measure", -"new_var") |>
    tidyr::spread(key = "new_var", value = "measure") |>
    # Add Codes
    cbind(codes)

  # Column order
  o <- c(rbind(nn$new_var, paste0(nn$new_var, "_code")))

  n_nice <- dplyr::select(n_nice, "period", dplyr::all_of(o))

  # Row order
  o <- names(n)[
    !names(n) %in% c("variable", "Code", "subgroup", "variable_sub")
  ]
  n_nice |>
    dplyr::mutate(period = factor(.data$period, levels = o)) |>
    dplyr::arrange(.data$period) |>
    dplyr::as_tibble()
}

data_format <- function(n, climate_id) {
  fmts <- dplyr::filter(n_formats, .data$new_var %in% names(n))
  dates <- dplyr::filter(fmts, .data$format == "date") |>
    dplyr::pull("new_var")
  nums <- dplyr::filter(fmts, .data$format == "numeric") |>
    dplyr::pull("new_var")
  chars <- dplyr::filter(fmts, .data$format == "character") |>
    dplyr::pull("new_var")

  # Prepare dates (if missing, NA)
  n_fmt <- n |>
    dplyr::mutate(
      dplyr::across(
        .cols = dplyr::all_of(dates),
        .fns = \(x) {
          dplyr::if_else(
            condition = x == "",
            true = as.character(NA),
            false = paste0(x, "/", as.numeric(.data$period))
          )
        }
      )
    ) |>
    dplyr::mutate(
      dplyr::across(
        .cols = dplyr::all_of(dates),
        .fns = \(x) {
          dplyr::if_else(
            condition = .data$period == "Year",
            true = as.character(NA),
            false = x
          )
        }
      )
    )

  # In case of warnings

  tryCatch(
    {
      n_fmt <- dplyr::mutate(
        .data = n_fmt,
        dplyr::across(
          .cols = dplyr::all_of(dates),
          .fns = lubridate::ydm
        )
      )
    },
    warning = function(w) {
      wc_stop("{climate_id} has a formating issue with dates")
    }
  )

  tryCatch(
    {
      n_fmt <- dplyr::mutate(
        .data = n_fmt,
        dplyr::across(
          .cols = dplyr::all_of(nums),
          .fns = as.numeric
        )
      )
    },
    warning = function(w) {
      wc_stop("{climate_id} has a formating issue with numbers")
    }
  )

  tryCatch(
    {
      n_fmt <- dplyr::mutate(
        .data = n_fmt,
        dplyr::across(
          .cols = dplyr::all_of(chars),
          .fns = \(x) {
            dplyr::if_else(x == "", as.character(NA), as.character(x))
          }
        )
      )
    },
    warning = function(w) {
      wc_stop("{climate_id} has a formating issue with characters")
    }
  )

  n_fmt
}

frost_extract <- function(f, climate_id) {
  if (all(f == "")) {
    return(dplyr::tibble())
  }

  frost_free <- stringr::str_which(f, f_names$match[f_names$group == 1][1])[1]
  frost_probs <- stringr::str_which(f, f_names$match[f_names$group == 2][1])[1]

  # Frost free days overall
  if (!all(is.na(frost_free)) && length(frost_free) > 0) {
    if (length(frost_probs) == 0) {
      last <- length(f)
    } else {
      last <- frost_probs - 1
    }

    readr::local_edition(1)
    f1 <- readr::read_csv(
      I(f[frost_free:last]),
      col_names = c("variable", "value", "frost_code"),
      col_types = readr::cols(),
      progress = FALSE
    ) |>
      tidyr::spread(key = "variable", value = "value")

    nms <- purrr::map(stats::setNames(f_names$match, f_names$new_var), \(x) {
      stringr::str_subset(names(f1), x)
    }) |>
      unlist()

    f1 <- dplyr::rename(f1, !!nms) |>
      dplyr::mutate(
        dplyr::across(.cols = dplyr::contains("date"), \(x) {
          lubridate::yday(lubridate::as_date(paste0("1999", x)))
        })
      ) |>
      dplyr::mutate(
        length_frost_free = stringr::str_extract(
          .data$length_frost_free,
          "[0-9]*"
        ),
        length_frost_free = as.numeric(.data$length_frost_free)
      )
  } else {
    f1 <- na_tibble(f_names$new_var[f_names$group == 1])
  }

  # Frost free probabilities
  if (!all(is.na(frost_probs)) && length(frost_probs) > 0) {
    readr::local_edition(1)
    f2 <- readr::read_csv(
      I(f[frost_probs:length(f)]),
      col_names = FALSE,
      col_types = readr::cols(),
      progress = FALSE
    ) |>
      dplyr::select(dplyr::where(\(x) !all(is.na(x)))) |>
      dplyr::rename_with(
        .fn = \(x) "prob",
        .cols = dplyr::where(\(x) {
          any(stringr::str_detect(x, "(P|p)robability"))
        })
      ) |>
      dplyr::rename_with(
        .fn = \(x) "value",
        .cols = dplyr::where(\(x) {
          any(stringr::str_detect(
            x,
            paste0("(", paste0(month.abb, collapse = ")|("), ")")
          ))
        })
      ) |>
      dplyr::mutate(
        measure = stringr::str_remove(.data$prob, "\\(\\d{2}%\\)"),
        prob = stringr::str_extract(.data$prob, "\\d{2}%")
      ) |>
      tidyr::pivot_wider(names_from = "measure", values_from = "value")

    nms <- purrr::map(stats::setNames(f_names$match, f_names$new_var), \(x) {
      stringr::str_subset(names(f2), x)
    }) |>
      unlist()

    f2 <- dplyr::rename(f2, !!nms)
  } else {
    f2 <- na_tibble(f_names$new_var[f_names$group == 2])
  }

  if (nrow(f1) == 0 && nrow(f2) == 0) {
    r <- cbind(f1, f2)
  } else {
    r <- dplyr::full_join(
      dplyr::mutate(f1, climate_id = .env$climate_id),
      dplyr::mutate(f2, climate_id = .env$climate_id),
      by = "climate_id",
      relationship = "many-to-many"
    ) |>
      dplyr::select(-"climate_id")
  }

  dplyr::as_tibble(r)
}

frost_find <- function(n, type = "extract") {
  frost <- find_line(n, "station data \\(Frost-Free\\)")

  # If no frost-free title, look for next measurement

  if (length(frost) == 0) {
    frost <- purrr::map(f_names$match, \(x) find_line(n, x)) |>
      unlist() |>
      min_na()
  }

  if (length(frost) == 1) {
    if (type == "extract") {
      r <- n[(frost):length(n)]
    }
    if (type == "remove") r <- n[1:(frost - 1)]
  } else if (length(frost) == 0) {
    if (type == "extract") {
      r <- ""
    }
    if (type == "remove") r <- n
  } else {
    wc_stop(
      "Problem identifying frost data in normals\nPlease report this here: ",
      "https://github.com/ropensci/weathercan/issues"
    )
  }
  r
}

frost_format <- function(f, climate_id) {
  fmts <- dplyr::filter(f_formats, .data$new_var %in% names(f))
  dates <- dplyr::filter(fmts, .data$format == "date") |>
    dplyr::pull("new_var")
  nums <- dplyr::filter(fmts, .data$format == "numeric") |>
    dplyr::pull("new_var")
  chars <- dplyr::filter(fmts, .data$format == "character") |>
    dplyr::pull("new_var")

  f_fmt <- dplyr::mutate(
    f,
    dplyr::across(.cols = dplyr::all_of(dates), \(x) {
      dplyr::if_else(x == "" | is.na(x), as.character(NA), paste0(x, " 1999"))
    })
  )

  # In case of warnings
  tryCatch(
    {
      f_fmt <- dplyr::mutate(
        f_fmt,
        dplyr::across(.cols = dplyr::all_of(dates), \(x) {
          lubridate::yday(lubridate::mdy(x))
        })
      )
    },
    warning = function(w) {
      wc_stop("{climate_id} has a formating issue with dates")
    }
  )
  tryCatch(
    {
      f_fmt <- dplyr::mutate(
        f_fmt,
        dplyr::across(dplyr::all_of(nums), \(x) as.numeric(as.character(x)))
      )
    },
    warning = function(w) {
      wc_stop("{climate_id} has a formating issue with numbers")
    }
  )
  tryCatch(
    {
      f_fmt <- dplyr::mutate(
        f_fmt,
        dplyr::across(dplyr::all_of(chars), \(x) {
          dplyr::if_else(x == "", as.character(NA), as.character(x))
        })
      )
    },
    warning = function(w) {
      wc_stop("{climate_id} has a formating issue with characters")
    }
  )
  f_fmt
}

meets_wmo <- function(n) {
  start <- stringr::str_which(n, "STATION_NAME")
  any(stringr::str_detect(n[start:(start + 1)], "\\*"))
}
