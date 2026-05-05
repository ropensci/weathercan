wc_msg <- function(..., .envir) {
  cli::cli_inform(paste0(..., collapse = ""), .envir = .envir)
}

wc_progress <- function(..., .envir = rlang::caller_env()) {
  if (getOption("weathercan.verbosity") == "verbose") {
    wc_msg(..., .envir = .envir)
  }
}

wc_inform <- function(..., .envir = rlang::caller_env()) {
  if (getOption("weathercan.verbosity") != "quiet") wc_msg(..., .envir = .envir)
}

wc_inform_df <- function(..., df_title, df, .envir = rlang::caller_env()) {
  if (getOption("weathercan.verbosity") != "quiet") {
    wc_msg(..., .envir = .envir)
    cli::cli_text(df_title, .envir = .envir)
    cli::cli_code(utils::capture.output(df))
  }
}

wc_always <- function(..., .envir = rlang::caller_env()) {
  wc_msg(..., .envir = .envir)
}
}
