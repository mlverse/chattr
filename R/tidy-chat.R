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
      system_msg = td$system_msg,
      model_arguments = td$model_arguments
    )
  }

  text_output <- paste0("\n\n", comp_text, "\n\n")

  ide_paste_text(text_output)
}


build_prompt <- function(prompt = NULL) {
  td <- tidychat_defaults()

  ret <- c(
    td$prompt,
    if (td$include_data_files) context_data_files(),
    if (td$include_data_frames) context_data_frames(),
    if (td$include_doc_contents) context_doc_contents(prompt)
  )

  ret <- paste0("- ", ret, collapse = " \n")

  if (!td$include_doc_contents) {
    if (is.null(prompt)) {
      prompt <- context_doc_last_line()
    }
    ret <- paste0(ret, "\n ------ \n", prompt)
  }

  ret
}
