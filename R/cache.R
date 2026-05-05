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
    dir.create(cache_dir(), recursive = TRUE)
    if (dir.exists(cache_dir())) {
      wc_inform("Cache successfully created")
    } else {
      wc_stop("Cache could not be created")
    }
  }
  okay
}
