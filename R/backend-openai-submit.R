#' @export
ch_submit.ch_openai <- function(
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

openai_prompt.ch_openai_completions <- function(defaults, prompt) {
  header <- build_header(defaults)
  prompt <- paste("\n *", prompt)
  ret <- paste0(header, prompt)
  ret
}

openai_prompt.ch_openai <- function(defaults, prompt) {
  header <- build_header(defaults)

  system_msg <- defaults$system_msg
  if (!is.null(system_msg)) {
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

build_header <- function(defaults) {
  header <- c(
    process_prompt(defaults$prompt),
    ch_context_data_files(defaults$max_data_files),
    ch_context_data_frames(defaults$max_data_frames)
  )
  paste0("* ", header, collapse = " \n")
}

#--------------------------- Completion ----------------------------------------

openai_completion <- function(
    defaults,
    prompt,
    new_prompt,
    r_file_stream,
    r_file_complete,
    stream) {
  UseMethod("openai_completion")
}

openai_completion.ch_openai_chat_completions <- function(
    defaults,
    prompt,
    new_prompt,
    r_file_stream,
    r_file_complete) {
  pb <- list(messages = new_prompt)
  if (!is.null(defaults$model)) {
    pb$model <- defaults$model
  }
  req_body <- c(pb, defaults$model_arguments)

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

openai_completion.ch_openai_copilot_chat <- function(
    defaults,
    prompt,
    new_prompt,
    r_file_stream,
    r_file_complete) {
  req_body <- c(
    list(messages = new_prompt),
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

openai_completion.ch_openai_completions <- function(
    defaults,
    prompt,
    new_prompt,
    r_file_stream,
    r_file_complete) {
  pb <- list(prompt = new_prompt)
  if (!is.null(defaults$model)) {
    pb$model <- defaults$model
  }
  req_body <- c(pb, defaults$model_arguments)

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
