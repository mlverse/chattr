#' @export
tidychat_submit.tc_provider_open_ai  <- function(defaults,
                                                 prompt = NULL,
                                                 prompt_build = TRUE,
                                                 preview = FALSE,
                                                 r_file_stream = NULL,
                                                 r_file_complete = NULL,
                                                 ...) {
  if(prompt_build) {
    prompt <- build_prompt_new(prompt, defaults)
  } else {
    prompt <- build_null_prompt(prompt)
  }

  ret <- NULL
  if(preview) {
    ret <- prompt
  } else {
    ret <- openai_completion(
      defaults = defaults,
      prompt = prompt,
      r_file_stream = r_file_stream,
      r_file_complete = r_file_complete
    )
  }

  if(is.null(ret)) return(invisible())

  ret
}

openai_completion <- function(defaults, prompt, r_file_stream, r_file_complete) {
  UseMethod("openai_completion")
}

openai_completion.tc_model_gpt_3.5_turbo <- function(defaults,
                                                     prompt,
                                                     r_file_stream,
                                                     r_file_complete
) {
  openai_get_chat_completion_text(
    prompt = prompt,
    model = "gpt-3.5-turbo",
    defaults = defaults,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete
  )
}

openai_completion.tc_model_davinci_3  <- function(defaults,
                                                  prompt,
                                                  r_file_stream,
                                                  r_file_complete
) {
  openai_get_completion_text(
    prompt = prompt,
    model = "text-davinci-003",
    defaults = defaults,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete
  )
}

openai_get_chat_completion_text <- function(prompt = NULL,
                                            model = "gpt-3.5-turbo",
                                            defaults = NULL,
                                            r_file_stream = NULL,
                                            r_file_complete = NULL) {
  req_body <- c(
    list(
      model = model,
      messages = prompt
    ),
    defaults$model_arguments
  )

  ret <- openai_switch(
    endpoint = "chat/completions",
    req_body = req_body,
    defaults = defaults,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete
  )

  if(inherits(ret, "list")) {
    ret <- ret$choices[[1]]$message$content
  }

  ret
}

openai_get_completion_text <- function(prompt = NULL,
                                       model = "text-davinci-003",
                                       defaults = NULL,
                                       r_file_stream = NULL,
                                       r_file_complete = NULL) {
  req_body <- c(
    list(
      model = model,
      prompt = prompt
    ),
    defaults$model_arguments
  )

  ret <- openai_switch(
    endpoint = "completions",
    req_body = req_body,
    defaults = defaults,
    r_file_stream = r_file_stream,
    r_file_complete = r_file_complete
  )

  if(inherits(ret, "list")) {
    ret <- ret$choices[[1]]$text
  }

  ret
}

openai_switch <- function(endpoint,
                          req_body,
                          defaults,
                          r_file_stream,
                          r_file_complete
) {
  ret <- NULL
  stream <- defaults$model_arguments$stream %||% FALSE
  if (stream) {
    if(defaults$type == "chat") {
      ret <- openai_stream_file(
        endpoint = endpoint,
        req_body = req_body,
        r_file_stream = r_file_stream,
        r_file_complete = r_file_complete
      )
    } else {
      openai_stream_ide(endpoint, req_body)
    }
  } else {
    ret <- openai_perform(endpoint, req_body)
  }
  ret
}
