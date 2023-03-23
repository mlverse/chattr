#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidy_chat <- function(prompt = NULL) {
  comp_text <- openai_get_chat_completion_text(
    prompt = build_prompt(prompt),
    max_tokens = 1000
  )

  # if(ui_current() == "markdown") {
  #   comp_text <- paste0(
  #     "```{r}\n", comp_text, "\n```"
  #   )
  # }

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
  c(
    "Use tidyverse, readr, ggplot2, dplyr, tidyr",
    "Expecting only code, avoid comments please",
    "If comments are necessary, prefix comments with the pound sign",
    context_data_files(),
    context_data_frames(),
    context_doc_contents(prompt)
  ) %>%
    paste0("- ", ., collapse = " \n")
}
