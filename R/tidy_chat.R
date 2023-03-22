tidy_chat <- function(prompt = NULL) {
  # Figure a better way to determine if script is being sourced
  if(!is.na(Sys.getenv("RSTUDIO", unset = NA)) && sys.nframe() >= 4) {
    return(invisible())
  }
    comp_text <- openai_get_chat_completion_text(
    prompt = build_prompt(prompt),
    max_tokens = 1000
  )

  rstudioapi::insertText(paste0(comp_text, "\n\n\n"))
}

build_prompt <- function(prompt) {
  c(
    "Use tidyverse, readr, ggplot2, dplyr, tidyr",
    "Expecting only code, no comments please",
    "If the user requests comments, prefix comments with the pound sign"
    #get_loaded_packages(),
    get_data_files(),
    get_data_frames(),
    get_docs_contents(),
  ) %>%
    paste0("- ", ., collapse = " \n") %>%
    paste0("\n --------- \n")
}
