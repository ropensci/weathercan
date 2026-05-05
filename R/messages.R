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

wc_msg <- function(..., .envir) {
  cli::cli_inform(paste0(..., collapse = ""), .envir = .envir)
}

wc_progress <- function(..., .envir = rlang::caller_env()) {
  if (wc_noise("verbose")) wc_msg(..., .envir = .envir)
}

wc_inform <- function(..., .envir = rlang::caller_env()) {
  if (wc_noise("noisy")) wc_msg(..., .envir = .envir)
}

wc_inform_df <- function(..., df_title, df, .envir = rlang::caller_env()) {
  if (wc_noise("noisy")) {
    wc_msg(..., .envir = .envir)
    cli::cli_text(df_title, .envir = .envir)
    cli::cli_code(utils::capture.output(df))
  }
}

wc_always <- function(..., .envir = rlang::caller_env()) {
  wc_msg(..., .envir = .envir)
}

wc_warn <- function(..., .envir = rlang::caller_env()) {
  cli::cli_warn(paste0(..., collapse = ""), .envir = .envir)
}

wc_stop <- function(..., .envir = rlang::caller_env()) {
  cli::cli_abort(paste0(..., collapse = ""), .envir = .envir)
}
