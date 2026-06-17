#' Check verbosity setting
#'
#' Returns the current verbosity setting or checks if it matches a specific level.
#'
#' @param check Character. Optional check for specific verbosity level ("quiet",
#'   "verbose", or "noisy"). "noisy" checks if not quiet.
#'
#' @returns Logical or character. Current verbosity setting, or TRUE/FALSE if
#'   check is specified.
#'
#' @noRd
#' @examples
#' wc_noise()
#' wc_noise("standard")
#' wc_noise("quiet")
#' wc_noise("noisy")

wc_noise <- function(check = NULL) {
  v <- getOption("weathercan.verbosity")
  if (!is.null(check)) {
    if (check == "noisy") {
      v <- v != "quiet"
    } else {
      v <- v == check
    }
  }
  v
}

#' Basic message function
#'
#' Wrapper around cli functions for displaying messages.
#'
#' @param ... Character. Message components to paste together
#' @param add Logical. If TRUE, uses cli_li, otherwise cli_inform
#' @param .envir Environment for message interpolation
#'
#' @returns Nothing, called for side effects (displays message)
#'
#' @noRd
#' @examples
#' wc_msg("Hello world")
#' wc_msg("Value: ", 42)

wc_msg <- function(..., add = FALSE, .envir) {
  cli_fun <- if (add) cli::cli_li else cli::cli_inform
  cli_fun(paste0(..., collapse = ""), .envir = .envir)
}

#' Display progress message
#'
#' Displays a message only if verbosity is set to "verbose".
#'
#' @param ... Character. Message components to paste together
#' @param add Logical. If `TRUE`, uses [cli_li()], otherwise [cli_inform()]
#' @param .envir Environment for message interpolation
#'
#' @returns Nothing, called for side effects (displays message if verbose)
#'
#' @noRd
#' @examples
#' withr::with_options(list(weathercan.verbosity = "verbose"), {
#'   wc_progress("Processing data...")
#'   wc_progress("Downloaded ", 100, " records")
#' })

wc_progress <- function(..., add = FALSE, .envir = rlang::caller_env()) {
  if (wc_noise("verbose")) {
    wc_msg(..., add = add, .envir = .envir)
  }
}

#' Display informational message
#'
#' Displays a message unless verbosity is set to "quiet".
#'
#' @param ... Character. Message components to paste together
#' @param add Logical. If `TRUE`, uses [cli_li()], otherwise [cli_inform()]
#' @param .envir Environment for message interpolation
#'
#' @returns Nothing, called for side effects (displays message if not quiet)
#'
#' @noRd
#' @examples
#' wc_inform("Data downloaded successfully")
#' wc_inform("Found ", 5, " stations")

wc_inform <- function(..., add = FALSE, .envir = rlang::caller_env()) {
  if (wc_noise("noisy")) wc_msg(..., add = add, .envir = .envir)
}

#' Display data frame message
#'
#' Displays a formatted data frame with optional title and message, respecting
#' verbosity settings.
#'
#' @param df_title Character. Title for the data frame display
#' @param df Data frame. Data to display
#' @param when Character. Verbosity level required to display ("quiet",
#'   "verbose", or "noisy")
#' @param title Character. Optional header title
#' @param message Character. Optional message before data frame
#' @param .envir Environment for message interpolation
#'
#' @returns Nothing, called for side effects (displays data frame)
#'
#' @noRd
#' @examples
#' wc_msg_df("Sample data:", head(mtcars, 3))
#' wc_msg_df("Results", data.frame(x = 1:3), title = "Analysis")

wc_msg_df <- function(
  df_title,
  df,
  when = "noisy",
  title = NULL,
  message = NULL,
  .envir = rlang::caller_env()
) {
  if (wc_noise(when)) {
    if (!is.null(title)) {
      cli::cli_h3(title, .envir = .envir)
    }
    if (!is.null(message)) {
      cli::cli_inform(message, .envir = .envir)
    }
    cli::cli_text(df_title, .envir = .envir)
    cli::cli_code(utils::capture.output(df))
  }
}

#' Display warning message
#'
#' Wrapper around [cli_warn()] for displaying warnings.
#'
#' @param ... Character. Warning message components to paste together
#' @param .envir Environment for message interpolation
#' @param call Environment for call context in warning
#'
#' @returns Nothing, called for side effects (displays warning)
#'
#' @noRd
#' @examples
#' wc_warn("This is a warning")
#' wc_warn("Value ", 42, " may be incorrect")

wc_warn <- function(..., .envir = rlang::caller_env(), call = .envir) {
  cli::cli_warn(paste0(..., collapse = ""), .envir = .envir, call = call)
}

#' Stop with error message
#'
#' Wrapper around [cli_abort()] for stopping with an error.
#'
#' @param ... Character. Error message components to paste together
#' @param .envir Environment for message interpolation
#' @param call Environment for call context in error
#'
#' @returns Nothing, stops execution with error
#'
#' @noRd
#' @examples
#' wc_stop("An error occurred")
#' wc_stop("Invalid value: ", 42)

wc_stop <- function(..., .envir = rlang::caller_env(), call = .envir) {
  cli::cli_abort(paste0(..., collapse = ""), .envir = .envir, call = call)
}
