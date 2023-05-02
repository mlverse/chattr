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

