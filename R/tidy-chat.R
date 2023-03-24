#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidy_chat <- function(prompt = NULL) {

  td <- tidychat_defaults()

  prompt <- build_prompt(prompt)

  if (td$provider == "openai") {
    comp_text <- openai_get_completion(
      prompt = prompt,
      model = td$model,
      max_tokens = 1000
    )
  }

  text_output <- paste0("\n\n", comp_text, "\n\n")

  ide_paste_text(text_output)
}

#' Previews the prompt
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidychat_prompt <- function(prompt = NULL) {
  cat(build_prompt())
}

tidychat_env <- new.env()


#' @export
tidychat_defaults <- function(prompt = NULL,
                              include_data_files = NULL,
                              include_data_frames = NULL,
                              include_doc_contents = NULL,
                              provider = NULL,
                              model = NULL) {

  td <- tidychat_get_defaults()

  if (is.null(model) & is.null(td$model)) {
    tidychat_use_openai_35_turbo()
  } else {
    tidychat_set_defaults(
      prompt = prompt,
      include_data_files = include_data_files,
      include_data_frames = include_data_frames,
      include_doc_contents = include_doc_contents,
      provider = provider,
      model = model
    )
  }

  tidychat_get_defaults()
}

tidychat_get_defaults <- function() {
  tidychat_env$model_defaults
}

tidychat_set_defaults <- function(prompt = NULL,
                                  include_data_files = NULL,
                                  include_data_frames = NULL,
                                  include_doc_contents = NULL,
                                  provider = NULL,
                                  model = NULL) {

  td <- tidychat_get_defaults()

  tidychat_env$model_defaults <- list(
    prompt = prompt %||% td$prompt,
    include_data_files = include_data_files %||% td$include_data_files,
    include_data_frames = include_data_frames %||% td$include_data_frames,
    include_doc_contents = include_doc_contents %||% td$include_doc_contents,
    provider = provider %||% td$provider,
    model = model %||% td$model
  )
}

#' @export
tidychat_use_openai_35_turbo <- function() {
  tidychat_set_defaults(
    prompt = c(
      "Use tidyverse, readr, ggplot2, dplyr, tidyr",
      "Expecting only code, avoid comments unless requested by user"
    ),
    include_data_files = TRUE,
    include_data_frames = TRUE,
    include_doc_contents = TRUE,
    provider = "openai",
    model = "gpt-3.5-turbo"
  )
}

#' @export
tidychat_use_openai_davinci_3 <- function() {
  tidychat_set_defaults(
    prompt = c(
      "Use tidyverse, readr, ggplot2, dplyr, tidyr",
      "Expecting only code, avoid comments unless requested by user"
    ),
    include_data_files = TRUE,
    include_data_frames = TRUE,
    include_doc_contents = TRUE,
    provider = "openai",
    model = "text-davinci-003"
  )
}

build_prompt <- function(prompt = NULL) {

  td <- tidychat_get_defaults()

  ret <- c(
    td$prompt,
    if(td$include_data_files) context_data_files(),
    if(td$include_data_frames) context_data_frames(),
    if(td$include_doc_contents) {
      context_doc_contents(prompt)
    } else {
      prompt
    }
  ) %>%
    paste0("- ", ., collapse = " \n")

  ret
}
