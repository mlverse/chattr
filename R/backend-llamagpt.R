# -------------------------------- Submit --------------------------------------
#' @export
ch_submit.ch_llamagpt <- function(
    defaults,
    prompt = NULL,
    stream = NULL,
    prompt_build = TRUE,
    preview = FALSE,
    r_file_stream = NULL,
    r_file_complete = NULL,
    ...) {
  if (ui_current_markdown()) {
    return(invisible())
  }

  prompt <- ide_build_prompt(
    prompt = prompt,
    defaults = defaults,
    preview = preview
  )

  if (prompt_build) {
    new_prompt <- paste0(prompt, "(", defaults$prompt[[1]], ")")
  } else {
    new_prompt <- prompt
  }

  ret <- NULL
  if (preview) {
    ret <- as_ch_request(new_prompt, defaults)
  } else {
    ch_llamagpt_session(defaults, r_file_stream, r_file_complete)

    ch_llamagpt_prompt(new_prompt)

    if (defaults$type == "default") {
      ui <- ui_current()
    } else {
      ui <- defaults$type
    }

    ret <- ch_llamagpt_output(ui, r_file_stream, r_file_complete)
  }

  ret
}

# ----------------------------- Session ----------------------------------------

ch_llamagpt_session <- function(
    defaults = chattr_defaults(),
    r_file_stream = NULL,
    r_file_complete = NULL,
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
      ch_llamagpt_printout(defaults, r_file_stream)
    }
  }
  ch_env$llamagpt$session
}

ch_llamagpt_prompt <- function(prompt) {
  prompt <- paste0(prompt, "\n")
  ch_env$llamagpt$session$write_input(prompt)
}

ch_llamagpt_output <- function(
    stream_to,
    stream_file = NULL,
    output_file = NULL,
    timeout = 1000,
    output = NULL) {
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
    all_output <- paste0(all_output, output)

    if (stream_to == "console") cat(output)
    if (stream_to == "script") ide_paste_text(output)
    if (stream_to == "chat") saveRDS(all_output, stream_file, compress = FALSE)

    output <- NULL

    if (stop_stream) {
      if (stream_to == "chat") {
        if (!is.null(output_file)) saveRDS(all_output, output_file, compress = FALSE)
        file_delete(stream_file)
        return(NULL)
      } else {
        return(NULL)
      }
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

ch_llamagpt_printout <- function(
    defaults,
    r_file_stream = NULL,
    output = NULL) {
  if (defaults$type == "chat") {
    ch_llamagpt_output("chat", r_file_stream)
  } else {
    cli_h2("chattr")
    cli_h3("Initializing model")
    ch_llamagpt_output("console", output = output)
  }
}
