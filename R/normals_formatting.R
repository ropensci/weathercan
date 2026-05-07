#' Extract normals data or metadata
#'
#' Extracts either the data portion or full content from raw normals text,
#' removing WMO standards rows and cleaning trailing commas.
#'
#' @param n Character vector. Raw normals data lines
#' @param return Character. Either "data" to extract data portion or anything
#'   else to return full content
#'
#' @returns Character vector of extracted normals content
#'
#' @noRd

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


#' Extract and format normals measurements
#'
#' Reads raw normals CSV data, identifies measurement variables, aligns
#' variable names, and reshapes into wide format with codes.
#'
#' @param n Character vector. Raw normals data to parse
#' @param climate_id Character. Climate ID for error reporting
#'
#' @returns Tibble of extracted and formatted normals measurements
#'
#' @noRd

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
    tidyr::pivot_wider(names_from = "new_var", values_from = "code")

  # Spread variables
  n_nice <- n_nice |>
    dplyr::select(-"Code", -"variable", -"subgroup", -"variable_sub") |>
    tidyr::pivot_longer(
      cols = -"new_var",
      names_to = "period",
      values_to = "measure"
    ) |>
    tidyr::pivot_wider(names_from = "new_var", values_from = "measure") |>
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

#' Format normals data
#'
#' Converts normals measurement columns to appropriate data types (dates,
#' numerics, characters) based on predefined formats.
#'
#' @param n Data frame. Extracted normals data to format
#' @param climate_id Character. Climate ID for error reporting
#'
#' @returns Tibble with properly formatted columns
#'
#' @noRd

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

#' Extract frost-free period data
#'
#' Extracts and formats frost-free period information including dates and
#' probabilities from raw normals data.
#'
#' @param f Character vector. Frost data lines from normals
#' @param climate_id Character. Climate ID for joining data
#'
#' @returns Tibble of frost-free period data
#'
#' @noRd

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
      tidyr::pivot_wider(names_from = "variable", values_from = "value")

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

#' Find frost data in normals
#'
#' Locates the frost-free period section in raw normals data and either
#' extracts it or removes it from the data.
#'
#' @param n Character vector. Raw normals data lines
#' @param type Character. Either "extract" to return frost data or "remove"
#'   to return data without frost section
#'
#' @returns Character vector of frost data or data without frost section
#'
#' @noRd

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

#' Format frost data
#'
#' Converts frost data columns to appropriate data types (dates, numerics,
#' characters) based on predefined formats.
#'
#' @param f Data frame. Extracted frost data to format
#' @param climate_id Character. Climate ID for error reporting
#'
#' @returns Tibble with properly formatted frost columns
#'
#' @noRd

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

#' Check if station meets WMO standards
#'
#' Determines whether a station meets World Meteorological Organization (WMO)
#' standards by checking for asterisk indicator in station metadata.
#'
#' @param n Character vector. Raw normals data lines
#'
#' @returns Logical. TRUE if station meets WMO standards
#'
#' @noRd

meets_wmo <- function(n) {
  start <- stringr::str_which(n, "STATION_NAME")
  any(stringr::str_detect(n[start:(start + 1)], "\\*"))
}
