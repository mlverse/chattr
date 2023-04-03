#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidy_chat <- function(prompt = NULL) {
  td <- tidychat_defaults()

  if (td$provider == "openai") {
    full_prompt <- build_prompt(prompt)
    comp_text <- openai_get_completion(
      prompt = full_prompt$prompt2,
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


build_prompt <- function(prompt = NULL) {
  td <- tidychat_defaults()

  header <- c(
    td$prompt,
    if (td$include_data_files) context_data_files(),
    if (td$include_data_frames) context_data_frames(),
    if (td$include_doc_contents) context_doc_contents(prompt)
  )

  header <- paste0("* ", header, collapse = " \n")

  if (is.null(prompt)) {
    prompt <- context_doc_last_line()
  }

  if (!td$include_doc_contents) {
    header <- paste0(header, "\n ------ \n", prompt)
  }

  prompt2 <- NULL

  if (!is.null(td$system_msg)) {
    prompt2 <- list(role = "system", contents = td$system_msg)
  }

  header2 <- c(
    td$prompt,
    if (td$include_data_files) context_data_files(),
    if (td$include_data_frames) context_data_frames()
  )

  header2 <- paste0("* ", header2, collapse = " \n")

  prompt2 <- c(
    list(prompt2),
    tidychat_env$openai_history,
    list(
      list(
        role = "user",
        content = header2
      ),
      list(
        role = "user",
        content = prompt
      )
    )
  )

  x <<- prompt2
  stop("hahahah")

  list(
    prompt = prompt,
    prompt2 = prompt2,
    full = header
  )
}
