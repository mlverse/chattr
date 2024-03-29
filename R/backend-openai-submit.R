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
    prompt <- ch_openai_prompt(defaults, prompt)
  }
  ret <- NULL
  if (preview) {
    ret <- prompt
  } else {
    ret <- ch_openai_complete(
      prompt = prompt,
      defaults = defaults
      )
  }
  ret
}

ch_openai_prompt <- function(defaults, prompt) {
  header <- c(
    process_prompt(defaults$prompt),
    ch_context_data_files(defaults$max_data_files),
    ch_context_data_frames(defaults$max_data_frames)
  )
  header <-  paste0("* ", header, collapse = " \n")
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

  if(is_copilot(defaults)) {
    token <- ch_gh_token(defaults)
  } else {
    token <- ch_openai_token(defaults)
  }

  req_result <- defaults$path %>%
    request() %>%
    req_auth_bearer_token(token) %>%
    req_body_json(req_body)

  if(is_copilot(defaults)) {
    req_result <- req_headers(req_result, "Editor-Version" = "vscode/9.9.9")
  }

  req_result <- req_result %>%
    req_perform_stream(
      function(x) {
        char_x <- rawToChar(x)
        ret <<- paste0(ret, char_x)
        cat(ch_openai_parse(char_x, defaults))
        TRUE
      },
      buffer_kb = 0.05, round = "line"
    )
  ret <- ch_openai_parse(ret, defaults)
  if(req_result$status_code != 200) {
    cli_alert_warning(ret)
    abort(req_result)
  }
  ret
}
