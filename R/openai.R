#' @export
tidychat_submit.tc_model_gpt_3.5_turbo  <- function(defaults,
                                                    prompt = NULL,
                                                    prompt_build = TRUE,
                                                    preview = FALSE,
                                                    ...) {
  if(prompt_build) {
    prompt <- build_prompt_new(prompt, defaults)
  } else {
    prompt <- build_null_prompt(prompt)
  }

  if(preview) {
    ret <- prompt
  } else {
    ret <- openai_get_chat_completion_text(
      prompt = prompt,
      model = "gpt-3.5-turbo",
      defaults = defaults
    )
  }

  if(is.null(ret)) return(invisible())

  ret
}

#' @export
tidychat_submit.tc_model_davinci_3  <- function(defaults,
                                                prompt = NULL,
                                                prompt_build = TRUE,
                                                preview = FALSE,
                                                ...) {
  if(prompt_build) {
    prompt <- build_prompt_old(prompt, defaults)
  } else {
    prompt <- build_null_prompt(prompt)
  }

  if(preview) {
    ret <- prompt
  } else {
    ret <- openai_get_completion_text(
      prompt = prompt,
      model = "text-davinci-003",
      defaults = defaults
    )
  }

  if(is.null(ret)) return(invisible())

  ret
}

openai_get_chat <- function(prompt = NULL,
                            model = "",
                            defaults = NULL,
                            endpoint = ""
                            ) {
  req_body <- c(
    list(
      model = model,
      messages = prompt
    ),
    defaults$model_arguments
  )

  ret <- NULL
  stream <- defaults$model_arguments$stream %||% FALSE
  if (stream) {
    if(defaults$type == "chat") {
      ret <- openai_stream_file(endpoint, req_body)
    } else {
      openai_stream_ide(endpoint, req_body)
    }
  } else {
    ret <- openai_perform(endpoint, req_body)
  }

  ret
}

openai_get_completion.tc_model_davinci_3 <- function(defaults,
                                                     prompt = NULL) {
  openai_get_completion_text(
    prompt = prompt,
    model = "text-davinci-003",
    model_arguments = defaults$model_arguments
  )
}
