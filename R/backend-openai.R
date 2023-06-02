#' @export
ch_submit.ch_open_ai_chat_completions <- function(defaults,
                                                  prompt = NULL,
                                                  stream = NULL,
                                                  prompt_build = TRUE,
                                                  preview = FALSE,
                                                  r_file_stream = NULL,
                                                  r_file_complete = NULL,
                                                  ...) {
  ch_submit_open_ai(
    defaults = defaults,
    prompt = prompt,
    stream = stream,
    prompt_build = prompt_build,
    preview = preview,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete,
    ... = ...
  )
}

#' @export
ch_submit.ch_open_ai_completions <- function(defaults,
                                             prompt = NULL,
                                             stream = NULL,
                                             prompt_build = TRUE,
                                             preview = FALSE,
                                             r_file_stream = NULL,
                                             r_file_complete = NULL,
                                             ...) {
  ch_submit_open_ai(
    defaults = defaults,
    prompt = prompt,
    stream = stream,
    prompt_build = prompt_build,
    preview = preview,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete,
    ... = ...
  )
}


ch_submit_open_ai <- function(defaults,
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

  st <- stream %||% defaults$stream

  if (!is.null(st)) {
    ma <- defaults$model_arguments
    ma$stream <- st
    defaults$model_arguments <- ma
  }

  if (prompt_build) {
    new_prompt <- openai_prompt(defaults, prompt)
  } else {
    new_prompt <- prompt
  }

  ret <- NULL
  if (preview) {
    ret <- as_ch_request(new_prompt, defaults)
    if (!is.null(r_file_complete)) {
      saveRDS(ret, r_file_complete)
    }
  } else {
    ret <- openai_completion(
      defaults = defaults,
      prompt = prompt,
      new_prompt = new_prompt,
      r_file_stream = r_file_stream,
      r_file_complete = r_file_complete
    )
  }

  if (is.null(ret)) {
    return(invisible())
  }

  ret
}

#-------------------------------- Prompt ---------------------------------------

openai_prompt <- function(defaults, prompt) {
  UseMethod("openai_prompt")
}

openai_prompt.ch_open_ai_chat_completions <- function(defaults, prompt) {
  header <- build_header(defaults)

  if (!is.null(defaults$system_msg)) {
    system_msg <- list(list(role = "system", content = defaults$system_msg))
  }

  if (defaults$include_history) {
    history <- ch_history()
  } else {
    history <- NULL
  }

  ret <- c(
    system_msg,
    history,
    list(list(role = "user", content = paste0(header, "\n", prompt)))
  )

  ret
}

openai_prompt.ch_open_ai_completions <- function(defaults, prompt) {
  header <- build_header(defaults)
  prompt <- paste("\n *", prompt)
  ret <- paste0(header, prompt)
  ret
}

build_header <- function(defaults) {
  header <- c(
    process_prompt(defaults$prompt),
    ch_context_data_files(defaults$max_data_files),
    ch_context_data_frames(defaults$max_data_frames)
  )

  paste0("* ", header, collapse = " \n")
}

#--------------------------- Completion ----------------------------------------

openai_completion <- function(defaults,
                              prompt,
                              new_prompt,
                              r_file_stream,
                              r_file_complete,
                              stream) {
  UseMethod("openai_completion")
}

openai_completion.ch_open_ai_chat_completions <- function(defaults,
                                                          prompt,
                                                          new_prompt,
                                                          r_file_stream,
                                                          r_file_complete) {
  req_body <- c(
    list(
      model = defaults$model,
      messages = new_prompt
    ),
    defaults$model_arguments
  )

  ret <- openai_switch(
    prompt = prompt,
    req_body = req_body,
    defaults = defaults,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete
  )

  if (ch_debug_get()) {
    return(ret)
  }

  if (inherits(ret, "list")) {
    ret <- ret$choices[[1]]$message$content
  }

  ret
}

openai_completion.ch_open_ai_completions <- function(defaults,
                                                     prompt,
                                                     new_prompt,
                                                     r_file_stream,
                                                     r_file_complete) {
  req_body <- c(
    list(
      model = defaults$model,
      prompt = new_prompt
    ),
    defaults$model_arguments
  )

  ret <- openai_switch(
    prompt = prompt,
    req_body = req_body,
    defaults = defaults,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete
  )

  if (ch_debug_get()) {
    return(ret)
  }

  if (inherits(ret, "list")) {
    ret <- ret$choices[[1]]$text
  }

  ret
}

openai_switch <- function(prompt,
                          req_body,
                          defaults,
                          r_file_stream,
                          r_file_complete) {
  ret <- NULL
  stream <- defaults$model_arguments$stream %||% FALSE
  return_result <- TRUE
  if (stream) {
    if (defaults$type == "chat") {
      ret <- openai_stream_file(
        defaults = defaults,
        req_body = req_body,
        r_file_stream = r_file_stream,
        r_file_complete = r_file_complete
      )
    } else {
      return_result <- FALSE
      ret <- openai_stream_ide(defaults, req_body)
    }
  } else {
    ret <- openai_perform(defaults, req_body)
  }

  if (defaults$include_history %||% FALSE) {
    ch_history_append(prompt, ret)
  }

  if (!return_result) {
    ret <- NULL
  }
  ret
}

app_init_message.ch_open_ai_completions <- function(defaults) {
  app_init_openai(defaults)
}

app_init_message.ch_open_ai_chat_completions <- function(defaults) {
  app_init_openai(defaults)
}

app_init_openai <- function(defaults) {
  print_provider(defaults)
  if(defaults$max_data_files > 0) {
    cli_alert_warning(
      paste0(
        "A list of the top {defaults$max_data_files} files will ",
        "be sent externally to OpenAI with every request\n",
        "To avoid this, set the number of files to be sent to 0 ",
        "using {.run chattr::chattr_defaults(max_data_files = 0)}"
        )
      )
  }

  if(defaults$max_data_frames > 0) {
    cli_alert_warning(
      paste0(
        "A list of the top {defaults$max_data_frames} data.frames ",
        "currently in your R session will be sent externally to ",
        "OpenAI with every request\n To avoid this, set the number ",
        "of data.frames to be sent to 0 using ",
        "{.run chattr::chattr_defaults(max_data_frames = 0)}"
      )
    )
  }
}
