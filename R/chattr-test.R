#' Confirms conectivity to LLM interface
#' @inheritParams ch_submit
#' @export
chattr_test <- function(defaults = NULL) {
  if(is.null(defaults)) defaults <- chattr_defaults()
  ch_test(defaults)
}

#' @rdname chattr_test
#' @export
ch_test <- function(defaults = NULL) {
  UseMethod("ch_test")
}

# ------------------------------ OpenAI ----------------------------------------
#' @export
ch_test.ch_open_ai_chat_completions <- function(defaults = NULL) {
  ch_test_open_ai(defaults = defaults)
}

#' @export
ch_test.ch_open_ai_completions <- function(defaults = NULL) {
  ch_test_open_ai(defaults = defaults)
}

ch_test_open_ai <- function(defaults = NULL) {

  if(ch_debug_get()) {
    prompt <- "TEST"
    out <- "TEST"
  } else {
    prompt <- "Hi!"
    out <- capture.output(chattr(prompt))
  }

  if(is.null(out)) out <- ""

  cli_div(theme = cli_colors())
  cli_h3("Testing chattr")
  print_provider(defaults)

  if (nchar(out) > 0) {
    cli_alert_success("Connection with OpenAI cofirmed")
    cli_text("|--Prompt: {.val2 {prompt}}")
    cli_text("|--Response: {.val1 {out}}")
  } else {
    cli_alert_danger("Connection with OpenAI failed")
  }
}

# ----------------------------- LlamaGPT ---------------------------------------

#' @export
ch_test.ch_llamagpt <- function(defaults = NULL) {
  ch_llamagpt_session(defaults = defaults, testing = TRUE)
  session <- ch_llamagpt_session()
  Sys.sleep(0.1)
  error <- session$read_error()

  cli_div(theme = cli_colors())
  cli_h3("Testing chattr")
  print_provider(defaults)

  if (error == "") {
    cli_alert_success("Model started sucessfully")
  } else {
    cli_text(error)
    cli_alert_danger("Errors loading model")
  }
  x <- ch_llamagpt_stop()
  if (x) {
    cli_alert_success("Model session closed sucessfully")
  } else {
    cli_alert_danger("Errors closing model session")
  }
  invisible()
}


