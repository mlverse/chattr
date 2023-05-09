#' @export
tc_submit.tc_provider_open_ai <- function(defaults,
                                          prompt = NULL,
                                          stream = NULL,
                                          prompt_build = TRUE,
                                          preview = FALSE,
                                          r_file_stream = NULL,
                                          r_file_complete = NULL,
                                          ...) {
  prompt <- ide_build_prompt(prompt, defaults)

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
  header <- build_header(defaults)

  if (!is.null(defaults$system_msg)) {
    system_msg <- list(list(role = "system", content = defaults$system_msg))
  }

  if (defaults$include_history) {
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

openai_prompt.tc_model_davinci_3 <- function(defaults, prompt) {
  header <- build_header(defaults)
  prompt <- paste("\n *", prompt)
  ret <- paste0(header, prompt)
  ret
}

build_header <- function(defaults) {
  header <- c(
    process_prompt(defaults$prompt),
    if (defaults$include_data_files) context_data_files(),
    if (defaults$include_data_frames) context_data_frames()
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

openai_completion.tc_model_gpt_3.5_turbo <- function(defaults,
                                                     prompt,
                                                     new_prompt,
                                                     r_file_stream,
                                                     r_file_complete) {
  req_body <- c(
    list(
      model = "gpt-3.5-turbo",
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

openai_completion.tc_model_davinci_3 <- function(defaults,
                                                 prompt,
                                                 new_prompt,
                                                 r_file_stream,
                                                 r_file_complete) {
  req_body <- c(
    list(
      model = "text-davinci-003",
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
    tc_history_append(prompt, ret)
  }

  if (!return_result) {
    ret <- NULL
  }

  ret
}
