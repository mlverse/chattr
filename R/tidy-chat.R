#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidy_chat <- function(prompt = NULL) {
  comp_text <- openai_get_chat_completion_text(
    prompt = build_prompt(prompt),
    max_tokens = 1000
  )

  ide_paste_text(paste0(comp_text, "\n\n\n"))
}

#' Previews the prompt
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidychat_prompt <- function(prompt = NULL) {
  cat(build_prompt())
}

build_prompt <- function(prompt = NULL) {
  doc_contents <- context_doc_contents()

  if(is.null(prompt)) {
    prompt <- context_doc_last_line()
  }

  c(
    "Use tidyverse, readr, ggplot2, dplyr, tidyr",
    "Expecting only code, no comments please",
    "If the user requests comments, prefix comments with the pound sign",
    context_data_files(),
    context_data_frames(),
    doc_contents
  ) %>%
    paste0("- ", ., collapse = " \n") %>%
    paste0("\n---------\n") %>%
    paste0(prompt)
}
