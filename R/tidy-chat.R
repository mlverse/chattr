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

build_prompt <- function(prompt = NULL) {
  td <- tidychat_get_defaults()

  ret <- c(
    td$prompt,
    if (td$include_data_files) context_data_files(),
    if (td$include_data_frames) context_data_frames(),
    if (td$include_doc_contents) {
      context_doc_contents(prompt)
    } else {
      prompt
    }
  ) %>%
    paste0("- ", ., collapse = " \n")

  ret
}
