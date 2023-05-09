#' @export
tc_submit.tc_provider_open_ai <- function(defaults,
                                          prompt = NULL,
                                          stream = NULL,
                                          prompt_build = TRUE,
                                          preview = FALSE,
                                          r_file_stream = NULL,
                                          r_file_complete = NULL,
                                          ...) {
  prompt <- build_null_prompt(prompt, defaults)

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
    ret <- as_tc_request(new_prompt, defaults)
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

openai_prompt.tc_model_gpt_3.5_turbo <- function(defaults, prompt) {
  build_prompt_history(prompt, defaults)
}

openai_prompt.tc_model_davinci_3 <- function(defaults, prompt) {
  build_prompt_simple(prompt, defaults)
}

build_prompt_history <- function(prompt = NULL, defaults) {
  td <- defaults

  header <- build_header(defaults)

  if (!is.null(td$system_msg)) {
    system_msg <- list(list(role = "system", content = td$system_msg))
  }

  if (td$include_history) {
    history <- tc_history_get()
  } else {
    history <- NULL
  }

  ret <- c(
    system_msg,
    history,
    list(list(role = "user", content = header)),
    list(list(role = "user", content = prompt))
  )

  ret
}

build_prompt_simple <- function(prompt = NULL, defaults) {
  header <- build_header(defaults)
  prompt <- paste("\n *", prompt)
  ret <- paste0(header, prompt)
  ret
}

build_header <- function(defaults) {
  td <- defaults
  header <- c(
    process_prompt(td$prompt),
    if (td$include_data_files) context_data_files(),
    if (td$include_data_frames) context_data_frames()
  )

  paste0("* ", header, collapse = " \n")
}

build_null_prompt <- function(prompt = NULL,
                              defaults = tc_defaults()) {
  if (is.null(prompt)) {
    if (defaults$type == "notebook") {
      prompt <- ide_quarto_selection()
      if (is.null(prompt)) {
        prompt <- ide_quarto_last_line()
      }
    } else {
      selection <- ide_get_selection(TRUE)
      if (nchar(selection) > 0) {
        prompt <- selection
      } else {
        prompt <- context_doc_last_line()
      }
    }
  }
  err <- paste(
    "No 'prompt' provided, and no prompt cannot",
    "be infered from the current document"
  )
  err_flag <- FALSE
  if (is.null(prompt)) {
    err_flag <- TRUE
  } else if (nchar(prompt) == 0) {
    err_flag <- TRUE
  }

  if (err_flag) rlang::abort(err)

  prompt
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

openai_completion.tc_model_gpt_3.5_turbo <- function(defaults,
                                                     prompt,
                                                     new_prompt,
                                                     r_file_stream,
                                                     r_file_complete) {
  openai_get_chat_completion_text(
    prompt = prompt,
    new_prompt = new_prompt,
    model = "gpt-3.5-turbo",
    defaults = defaults,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete
  )
}

openai_completion.tc_model_davinci_3 <- function(defaults,
                                                 prompt,
                                                 new_prompt,
                                                 r_file_stream,
                                                 r_file_complete) {
  openai_get_completion_text(
    prompt = prompt,
    new_prompt = new_prompt,
    model = "text-davinci-003",
    defaults = defaults,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete
  )
}

openai_get_chat_completion_text <- function(prompt = NULL,
                                            new_prompt = NULL,
                                            model = "gpt-3.5-turbo",
                                            defaults = NULL,
                                            r_file_stream = NULL,
                                            r_file_complete = NULL) {
  req_body <- c(
    list(
      model = model,
      messages = new_prompt
    ),
    defaults$model_arguments
  )

  ret <- openai_switch(
    prompt = prompt,
    endpoint = "chat/completions",
    req_body = req_body,
    defaults = defaults,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete
  )

  if (tidychat_debug_get()) {
    return(ret)
  }

  if (inherits(ret, "list")) {
    ret <- ret$choices[[1]]$message$content
  }

  ret
}

openai_get_completion_text <- function(prompt = NULL,
                                       new_prompt = NULL,
                                       model = "text-davinci-003",
                                       defaults = NULL,
                                       r_file_stream = NULL,
                                       r_file_complete = NULL) {
  req_body <- c(
    list(
      model = model,
      prompt = new_prompt
    ),
    defaults$model_arguments
  )

  ret <- openai_switch(
    prompt = prompt,
    endpoint = "completions",
    req_body = req_body,
    defaults = defaults,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete
  )

  if (inherits(ret, "list")) {
    ret <- ret$choices[[1]]$text
  }

  ret
}

openai_switch <- function(prompt,
                          endpoint,
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
        endpoint = endpoint,
        req_body = req_body,
        r_file_stream = r_file_stream,
        r_file_complete = r_file_complete
      )
    } else {
      return_result <- FALSE
      ret <- openai_stream_ide(endpoint, req_body)
    }
  } else {
    ret <- openai_perform(endpoint, req_body)
  }

  if (defaults$include_history) {
    tc_history_append(
      user = prompt,
      assistant = ret
    )
  }

  if (!return_result) {
    ret <- NULL
  }

  ret
}
