weather_arrange <- function(w) {
  dplyr::relocate(w, dplyr::any_of(names(m_names)))
}


weather_trim <- function(w, format, trim, trim_by_stn) {
  if (!trim || !format || nrow(w) == 0) {
    return(w)
  }

  wc_progress("Trimming missing values before and after")

  if (trim_by_stn) {
    temp <- dplyr::group_split(w, .data$station_id)
  } else {
    temp <- list(w)
  }

  w <- purrr::map(temp, \(x) {
    trimable <- dplyr::select(
      x,
      -dplyr::any_of(c(
        names(m_names),
        "date",
        "time",
        "year",
        "month",
        "day",
        "hour",
        "qual"
      ))
    )

    keep <- x$date[which(
      rowSums(is.na(trimable) | trimable == "") != ncol(trimable)
    )]

    if (!length(keep)) {
      return(dplyr::tibble())
    }

    x <- x[x$date >= min(keep) & x$date <= max(keep), ]
  }) |>
    purrr::list_rbind()

  w
}

weather_format <- function(
  w,
  station_id,
  tz,
  interval = "hour",
  start,
  end,
  string_as = "NA",
  time_disp = NULL
) {
  w <- dplyr::select(
    w,
    -dplyr::any_of(c("Station Name", "Climate ID")),
    -dplyr::contains("Latitude"),
    -dplyr::contains("Longitude")
  )

  ## Get names from stored name list
  n <- w_names[[interval]]

  ## Trim to match names in data
  n <- n[n %in% names(w)]

  w <- dplyr::rename(w, !!n)

  if (interval == "day") {
    w <- dplyr::mutate(w, date = as.Date(.data$date))
  }
  if (interval == "month") {
    w <- dplyr::mutate(w, date = as.Date(paste0(.data$date, "-01")))
  }

  ## Get correct timezone
  if (interval == "hour") {
    w <- dplyr::mutate(w, time = as.POSIXct(.data$time, tz = "UTC"))
    if (time_disp == "UTC") {
      w <- dplyr::mutate(w, time = .data$time + lubridate::hours(tz_hours(tz)))
    }
    w <- dplyr::mutate(w, date = lubridate::as_date(.data$time))
  }

  ## Replace some flagged values with NA
  w <- w |>
    tidyr::gather(
      key = "variable",
      value = "value",
      names(w)[
        !(names(w) %in%
          c("date", "year", "month", "day", "hour", "time", "qual", "weather"))
      ]
    ) |>
    tidyr::separate(
      "variable",
      into = c("variable", "type"),
      sep = "_flag",
      fill = "right"
    ) |>
    dplyr::mutate(
      type = replace(.data$type, .data$type == "", "flag"),
      type = replace(.data$type, is.na(.data$type), "value")
    ) |>
    tidyr::spread("type", "value") |>
    dplyr::mutate(
      value = replace(.data$value, .data$value == "", NA), ## No data
      value = replace(.data$value, .data$flag == "M", NA)
    ) ## Missing

  if ("qual" %in% names(w)) {
    w <- dplyr::mutate(
      w,
      # Convert to ascii
      qual = stringi::stri_escape_unicode(.data$qual),
      qual = replace(
        .data$qual,
        .data$qual == "\\u2020",
        "Only preliminary quality checking"
      ),
      qual = replace(
        .data$qual,
        .data$qual == "\\u2021",
        paste0(
          "Partner data that is not subject",
          " to review by the National ",
          "Climate Archives"
        )
      )
    )
  }

  w <- w |>
    tidyr::gather(key = "type", value = "value", "flag", "value") |>
    dplyr::mutate(
      variable = replace(
        .data$variable,
        .data$type == "flag",
        paste0(.data$variable[.data$type == "flag"], "_flag")
      )
    ) |>
    dplyr::select("date", dplyr::everything(), -"type") |>
    tidyr::spread("variable", "value")

  ## Can we convert to numeric?
  #w$wind_spd[c(54, 89, 92)] <- c(">3", ">5", ">10")

  num <- apply(
    dplyr::select(
      w,
      -dplyr::any_of(c(
        "date",
        "year",
        "month",
        "day",
        "hour",
        "time",
        "qual",
        "weather",
        grep("flag", names(w), value = TRUE)
      ))
    ),
    MARGIN = 2,
    FUN = function(x) tryCatch(as.numeric(x), warning = function(w) w)
  )

  warn <- vapply(
    num,
    FUN = function(x) methods::is(x, "warning"),
    FUN.VALUE = TRUE
  )

  if (any(warn)) {
    m <- paste0(names(num)[warn], collapse = ", ")
    non_num <- dplyr::tibble(
      station_id = .env$station_id,
      col = names(num)[warn]
    )
    for (i in names(num)[warn]) {
      problems <- w[
        grep("<|>|\\)|\\(", w[[i]]),
        names(w) %in% c("date", "year", "month", "day", "hour", "time", i)
      ]
      if (nrow(problems) > 20) {
        rows <- 20
      } else {
        rows <- nrow(problems)
      }
      non_num$problems <- list(problems[1:rows, ])
    }
    if (!is.null(string_as)) {
      non_num$replace <- string_as
      suppressWarnings({
        valid_cols <- c(
          "date",
          "year",
          "month",
          "day",
          "hour",
          "time",
          "qual",
          "weather",
          grep("flag", names(w), value = TRUE)
        )

        replacement <- apply(
          dplyr::select(w, -dplyr::any_of(valid_cols)),
          MARGIN = 2,
          FUN = as.numeric
        )

        w[!(names(w) %in% valid_cols)] <- as.data.frame(replacement)
      })
    } else {
      m <- paste0(names(num)[warn], collapse = ", ")

      non_num <- dplyr::mutate(non_num, replace = "no_replace")

      replace <- c(
        "date",
        "year",
        "month",
        "day",
        "hour",
        "time",
        "qual",
        "weather",
        grep("flag", names(w), value = TRUE),
        names(num)[warn]
      )

      w[!(names(w) %in% replace)] <- as.data.frame(num[!warn])
    }
  } else {
    non_num <- data.frame()
    w[
      !(names(w) %in%
        c(
          "date",
          "year",
          "month",
          "day",
          "hour",
          "time",
          "qual",
          "weather",
          grep("flag", names(w), value = TRUE)
        ))
    ] <- as.data.frame(num)
  }

  ## Trim to match date range
  w <- dplyr::filter(w, .data$date >= start & .data$date <= end)

  list(data = w, msg = non_num)
}

weather_list_cols <- function(w, interval, list_col, format) {
  if (!list_col || !format) {
    return(w)
  }

  int_col <- dplyr::case_when(
    interval == "hour" ~ "date",
    interval == "day" ~ "month",
    interval == "month" ~ "year"
  )

  tidyr::nest(w, data = -dplyr::any_of(c(names(m_names), int_col)))
}
