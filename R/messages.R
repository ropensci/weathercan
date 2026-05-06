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

wc_msg <- function(..., add = FALSE, .envir) {
  cli_fun <- if (add) cli::cli_li else cli::cli_inform
  cli_fun(paste0(..., collapse = ""), .envir = .envir)
}

wc_progress <- function(..., add = FALSE, .envir = rlang::caller_env()) {
  if (wc_noise("verbose")) {
    wc_msg(..., add = add, .envir = .envir)
  }
}

wc_inform <- function(..., add = FALSE, .envir = rlang::caller_env()) {
  if (wc_noise("noisy")) wc_msg(..., add = add, .envir = .envir)
}

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

wc_warn <- function(..., .envir = rlang::caller_env()) {
  cli::cli_warn(paste0(..., collapse = ""), .envir = .envir)
}

wc_stop <- function(..., .envir = rlang::caller_env()) {
  cli::cli_abort(paste0(..., collapse = ""), .envir = .envir, )
}
