# -------------------------------- Submit --------------------------------------
#' @export
ch_submit.ch_llamagpt <- function(
    defaults,
    prompt = NULL,
    stream = NULL,
    prompt_build = TRUE,
    preview = FALSE,
    ...) {
  if (prompt_build) {
    new_prompt <- paste0(prompt, "(", defaults$prompt[[1]], ")")
  } else {
    new_prompt <- prompt
  }
  ret <- NULL
  if (preview) {
    ret <- new_prompt
  } else {
    ch_llamagpt_session(defaults)
    ch_llamagpt_prompt(new_prompt)
    ret <- ch_llamagpt_output(stream = stream)
  }
  ret
}

# ----------------------------- Session ----------------------------------------

ch_llamagpt_session <- function(
    defaults = chattr_defaults(),
    testing = FALSE) {
  init_session <- FALSE
  if (is.null(ch_env$llamagpt$session)) {
    init_session <- TRUE
  } else {
    if (!ch_env$llamagpt$session$is_alive()) {
      init_session <- TRUE
    }
  }
  if (init_session) {
    args <- ch_llamagpt_args(defaults)
    chat_path <- path_expand(defaults$path)
    ch_env$llamagpt$session <- process$new(
      chat_path,
      args = args,
      stdout = "|",
      stderr = "|",
      stdin = "|"
    )
    if (!testing) {
      ch_llamagpt_printout(defaults)
    }
  }
  ch_env$llamagpt$session
}

ch_llamagpt_prompt <- function(prompt) {
  prompt <- paste0(prompt, "\n")
  ch_env$llamagpt$session$write_input(prompt)
}

ch_llamagpt_output <- function(
    output = NULL,
    stream = FALSE,
    timeout = 1000) {
  all_output <- NULL
  stop_stream <- FALSE
  timeout <- timeout / 0.01
  for (j in 1:timeout) {
    Sys.sleep(0.01)
    if (is.null(output)) {
      x <- ch_env$llamagpt$session$read_output()
    } else {
      x <- output
    }
    output <- cli::ansi_strip(x)
    last_chars <- substr(output, nchar(output) - 2, nchar(output))
    if (last_chars == "\n> ") {
      output <- substr(output, 1, nchar(output) - 2)
      stop_stream <- TRUE
    }
    if (stream) {
      cat(output)
    }
    all_output <- paste0(all_output, output)
    output <- NULL
    if (stop_stream) {
      return(all_output)
    }
  }
}

ch_llamagpt_stop <- function() {
  if (!is.null(ch_env$llamagpt$session)) {
    ch_env$llamagpt$session$kill()
  } else {
    FALSE
  }
}

ch_llamagpt_args <- function(defaults) {
  args <- defaults$model_arguments
  args$model <- path_expand(defaults$model)
  imap(
    args,
    ~ c(paste0("--", .y), .x)
  ) %>%
    reduce(c)
}

ch_llamagpt_printout <- function(defaults, output = NULL) {
  if (defaults$type == "chat") {
    ch_llamagpt_output()
  } else {
    cli_h2("chattr")
    cli_h3("Initializing model")
    cat(ch_llamagpt_output(output))
  }
}
