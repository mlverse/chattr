#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidy_chat <- function(prompt = NULL) {
  td <- tidychat_defaults()

  if (td$provider == "openai") {
    full_prompt <- build_prompt(prompt)
    comp_text <- openai_get_completion(
      prompt = full_prompt$full,
      model = td$model,
      system_msg = td$system_msg,
      model_arguments = td$model_arguments
    )
    text_output <- paste0("\n\n", comp_text, "\n\n")

    chat_entry <- list(
      list(role = "user", content = full_prompt$prompt),
      list(role = "assistant", content = comp_text)
    )

    tidychat_env$openai_history <- c(tidychat_env$openai_history, chat_entry)
  }

  if (td$provider == "nomicai") {
    if (is.null(prompt)) prompt <- context_doc_last_line()
    text_output <- nomicai_chat(
      prompt = prompt
    )
  }

  ide_paste_text(text_output)
}


build_prompt <- function(prompt = NULL, use_current_mode = TRUE) {
  td <- tidychat_defaults()

  if (is.null(prompt)) {
    prompt <- context_doc_last_line()
  }

  if (!is.null(td$system_msg)) {
    system_msg <- list(list(role = "system", content = td$system_msg))
  }

  header <- c(
    td$prompt,
    if (td$include_data_files) context_data_files(),
    if (td$include_data_frames) context_data_frames(),
    if (td$include_doc_contents & !use_current_mode) context_doc_contents(prompt)
  )

  header <- paste0("* ", header, collapse = " \n")

  if (!td$include_doc_contents & !use_current_mode) {
    header <- paste0(header, "\n ------ \n", prompt)
  }

  if (use_current_mode) {
    full <- c(
      system_msg,
      tidychat_env$openai_history,
      list(
        list(
          role = "user",
          content = header
        ),
        list(
          role = "user",
          content = prompt
        )
      )
    )
  } else {
    full <- c(
      system_msg,
      list(
        list(
          role = "user",
          content = header
        )
      )
    )
  }

  list(
    prompt = prompt,
    full = full
  )
}
