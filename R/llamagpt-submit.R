#' @export
ch_submit.ch_provider_llamagpt <- function(defaults,
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
  x <- ch_llamagpt_session()

  ch_llamagpt_prompt(prompt)

  if(ui_current_console()) {
    ch_llamagpt_output("console")
  }

  if(ui_current() == "script") {
    ch_llamagpt_output("script")
  }

  NULL
}

#' @import processx
ch_llamagpt_session <- function(silent = FALSE) {
  init_session <- FALSE
  if(is.null(ch_env$llamagpt$session)) {
    init_session <- TRUE
  } else {
    if(!ch_env$llamagpt$session$is_alive()) {
      init_session <- TRUE
    }
  }
  if(init_session) {
    ch <- ch_defaults()
    args <- ch$model_arguments
    chat_path <- path_expand(args$chat_path)
    args$model <- path_expand(args$model)
    args <- args[names(args) != "chat_path"]
    args <- imap(
      args,
      ~ c(paste0("--", .y), .x)
    ) %>%
      reduce(c)

    ch_env$llamagpt$session <- process$new(
      chat_path,
      args = args,
      stdout = "|",
      stderr = "|",
      stdin = "|"
    )
    ch_env$llamagpt$session
    cli_h2("chattr")
    cli_h3("Initializing model")
    ch_llamagpt_output("console")
  }
  ch_env$llamagpt$session
}

ch_llamagpt_prompt <- function(prompt) {
  prompt <- paste0(prompt, "\n")
  ch_env$llamagpt$session$write_input(prompt)
}

ch_llamagpt_output <- function(stream_to) {
  all_output <- NULL
  stop_stream <- FALSE
  for(j in 1:1000) {
    Sys.sleep(0.01)
    output <- cli::ansi_strip(ch_env$llamagpt$session$read_output())
    last_chars <- substr(output, nchar(output) - 2, nchar(output))
    if(last_chars == "\n> ") {
      output <- substr(output, 1, nchar(output) - 2)
      stop_stream <- TRUE
    }
    if(stream_to == "console") cat(output)
    if(stream_to == "script") ide_paste_text(output)
    all_output <- paste0(all_output, output)
    if(stop_stream) {
      return(all_output)
    }
  }
  all_output
}

ch_llamagpt_stop <- function() {
  if(is.null(ch_env$llamagpt$session)) {
    ch_env$llamagpt$session$kill()
  } else {
    TRUE
  }
}
