#' @export
ch_submit.ch_openai <- function(
    defaults,
    prompt = NULL,
    stream = NULL,
    prompt_build = TRUE,
    preview = FALSE,
    ...) {

  prompt <- ide_build_prompt(
    prompt = prompt,
    defaults = defaults,
    preview = preview
  )

  if (prompt_build) {
    new_prompt <- openai_prompt(defaults, prompt)
  } else {
    new_prompt <- prompt
  }

  ret <- NULL
  if (preview) {
    ret <- as_ch_request(new_prompt, defaults)
  } else {
    ret <- ch_openai_complete(
      prompt = new_prompt,
      defaults = defaults
      )
  }
  ret
}


#-------------------------------- Prompt ---------------------------------------

openai_prompt <- function(defaults, prompt) {
  UseMethod("openai_prompt")
}

#' @export
openai_prompt.ch_openai_completions <- function(defaults, prompt) {
  header <- build_header(defaults)
  prompt <- paste("\n *", prompt)
  ret <- paste0(header, prompt)
  ret
}

#' @export
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
    new_prompt) {
  UseMethod("openai_completion")
}

#' @export
openai_completion.ch_openai_chat_completions <- function(
    defaults,
    prompt,
    new_prompt) {
  pb <- list(messages = new_prompt)
  if (!is.null(defaults$model)) {
    pb$model <- defaults$model
  }
  req_body <- c(pb, defaults$model_arguments)

  ret <- openai_switch(
    prompt = prompt,
    req_body = req_body,
    defaults = defaults
  )

  if (ch_debug_get()) {
    return(ret)
  }

  if (inherits(ret, "list")) {
    ret <- ret$choices[[1]]$message$content
  }

  ret
}

#' @export
openai_completion.ch_openai_github_copilot_chat <- function(
    defaults,
    prompt,
    new_prompt) {
  req_body <- c(
    list(messages = new_prompt),
    defaults$model_arguments
  )

  ret <- openai_switch(
    prompt = prompt,
    req_body = req_body,
    defaults = defaults
  )

  if (ch_debug_get()) {
    return(ret)
  }

  if (inherits(ret, "list")) {
    ret <- ret$choices[[1]]$message$content
  }

  ret
}

#' @export
openai_completion.ch_openai_completions <- function(
    defaults,
    prompt,
    new_prompt) {
  pb <- list(prompt = new_prompt)
  if (!is.null(defaults$model)) {
    pb$model <- defaults$model
  }
  req_body <- c(pb, defaults$model_arguments)

  ret <- openai_switch(
    prompt = prompt,
    req_body = req_body,
    defaults = defaults
  )

  if (ch_debug_get()) {
    return(ret)
  }

  if (inherits(ret, "list")) {
    ret <- ret$choices[[1]]$text
  }

  ret
}


ch_openai_complete <- function(prompt, defaults, stream = TRUE) {
  ret <- NULL
  if (ch_debug_get()) {
    return(req_body)
  }
  req_body <- c(
    list(messages = prompt),
    model = defaults$model,
    defaults$model_arguments
  )
  req_result <- openai_request(defaults, req_body) %>%
    req_perform_stream(
      function(x) {
        char_x <- rawToChar(x)
        ret <<- paste0(ret, char_x)
        cat(openai_stream_parse(char_x, defaults))
        TRUE
      },
      buffer_kb = 0.05, round = "line"
    )
  ret <- openai_stream_parse(ret, defaults)
  if(req_result$status_code != 200) {
    cli_alert_warning(ret)
    abort(req_result)
  }
  ret
}
