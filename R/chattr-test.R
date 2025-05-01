#' Confirms connectivity to LLM interface
#' @inheritParams ch_submit
#' @returns It returns console massages with the status of the test.
#' @export
chattr_test <- function(defaults = NULL) {
  if (is.null(defaults)) defaults <- chattr_defaults()
  ch_test(defaults)
}

#' @rdname chattr_test
#' @export
ch_test <- function(defaults = NULL) {
  UseMethod("ch_test")
}

#' @export
ch_test.ch_ellmer <- function(defaults = NULL) {
  if (ch_debug_get()) {
    prompt <- "TEST"
    out <- "TEST"
  } else {
    prompt <- "Hi!"
    out <- try(capture.output(chattr(prompt)), silent = TRUE)
    if(inherits(out, "try-error")) {
      out <- ""
    }
  }

  if (is.null(out)) out <- ""

  cli_div(theme = cli_colors())
  cli_h3("Testing chattr")
  print_provider(defaults)
  out <- paste0(out, collapse = "\n")
  if (nchar(out) > 0) {
    cli_alert_success("Connection to {defaults[['model']]} cofirmed")
    cli_text("|--Prompt: {.val2 {prompt}}")
    cli_text("|--Response: {.val1 {out}}")
  } else {
    cli_alert_danger("Connection to {defaults[['model']]} failed")
  }
}

#' @export
ch_submit.ch_test_backend <- function(
    defaults,
    prompt = NULL,
    stream = NULL,
    prompt_build = TRUE,
    preview = FALSE,
    ...) {
  is_test <- unlist(options("chattr-shiny-test")) %||% FALSE
  if (stream && !is_test) {
    for (i in seq_len(nchar(prompt))) {
      cat(substr(prompt, i, i))
      Sys.sleep(0.1)
    }
  }
  if (is_test) {
    invisible()
  } else {
    prompt
  }
}
