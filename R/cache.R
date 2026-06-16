#' Cache Directory
#'
#' Location of weathercan cache (or where the cache will be if created).
#'
#' @returns Directory path
#'
#' @export
#' @examples
#' cache_dir()

cache_dir <- function() {
  rappdirs::user_data_dir("weathercan")
}

#' Remove cached directory and contents
#'
#' This is a helper function to remove weathercan's cache directory.
#' This folder contains updated stations inventory lists and the full dataset of
#' Climate normals for 1991-2010.
#'
#' @returns nothing but removes directory
#'
#' @export
#' @examplesIf interactive()
#' cache_remove()

cache_remove <- function() {
  if (interactive()) {
    remove <- utils::askYesNo(
      paste0(
        "This will remove the weathercan cache directory and it's contents:\n",
        cache_dir(),
        "\nOkay to proceed?"
      )
    )
    if (is.na(remove)) {
      wc_inform("Cancelling cache removal")
      return(invisible())
    }
  } else {
    remove <- TRUE
  }

  if (remove) {
    unlink(cache_dir(), recursive = TRUE)
  }

  if (!dir.exists(cache_dir())) {
    wc_inform("Cache successfully removed")
  } else {
    wc_stop("Cache could not be removed")
  }
}

#' Check for cache dir and create if non-existant
#'
#' Checks for the cache dir and creates it if it doesn't exist. If interactive
#' and dir doesn't exist, asks to create. If non-interactive and dir doesn't
#' exist it's created.
#'
#' @returns Logical. TRUE if cache dir exists or was created, FALSE otherwise
#'
#' @noRd
#' @examples
#' cache_check()

cache_check <- function() {
  okay <- TRUE
  if (!dir.exists(cache_dir())) {
    if (interactive()) {
      okay <- utils::askYesNo(
        paste0(
          "weathercan would like to create a cache directory.\n",
          "This is for storing stations and cached normals data:\n",
          cache_dir(),
          "\nOkay to proceed?"
        )
      )
    }
    if (is.na(okay) || !okay) {
      wc_stop("Cannot proceed without a cache directory")
    }

    dir.create(cache_dir(), recursive = TRUE)
    if (dir.exists(cache_dir())) {
      wc_inform("Cache successfully created")
    } else {
      wc_stop("Cache could not be created")
    }
  }
  okay
}

#' Check when stations last updated and inform user
#'
#' If it's been more than a month, remind user to update.
#'
#' @returns Nothing. Message if it's been a while.
#'
#' @noRd
#' @examples
#' cache_stations_check()

cache_stations_check <- function() {
  cache_check()
  if (!file.exists(stations_file()) || !file.exists(stations_meta_file())) {
    if (interactive()) {
      dl <- utils::askYesNo("No stations data frame found, download?")
    } else {
      dl <- TRUE
    }

    if (is.na(dl) || !dl) {
      wc_stop("Need download stations data first")
    }

    stations_dl()
  }

  time_since_update <- difftime(
    Sys.Date(),
    stations_meta()$weathercan_modified,
    units = "days"
  )
  if (time_since_update > 28) {
    if (!identical(Sys.getenv("TESTTHAT"), "true")) {
      wc_warn(
        "The stations data frame hasn't been updated in over 4 weeks. ",
        "Consider running `stations_dl()`"
      )
    }
  }
}
