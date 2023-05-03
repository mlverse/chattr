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
    ret <- gpt_completion(
      defaults = defaults,
      prompt = prompt,
      r_file_stream = r_file_stream,
      r_file_complete = r_file_complete
    )
  }

  if(is.null(ret)) return(invisible())

  ret
}

gpt_completion <- function(defaults, prompt, r_file_stream, r_file_complete) {
  UseMethod("gpt_completion")
}

gpt_completion.tc_model_gpt_3.5_turbo <- function(defaults,
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

gpt_completion.tc_model_davinci_3  <- function(defaults,
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
