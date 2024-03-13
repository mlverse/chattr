#' Sets the LLM model to use in your session
#' @param model_label The label of the LLM model to use. Valid values are
#' gpt35, davinci, and llamagpt.
#' @details Use the 'CHATTR_MODEL' environment variable to set it for the
#' R session.
#' @export
chattr_use <- function(model_label = NULL) {
  if (is_interactive() && is.null(model_label)) {
    model_label <- ch_get_ymls()
  }

  if (is.null(model_label)) {
    model_label <- "gpt4"
  }

  use_switch("configs", path_ext_set(model_label, "yml"))
}

ch_get_ymls <- function(menu = TRUE) {
  files <- package_file("configs") %>%
    dir_ls()

  copilot_defaults <- "configs/copilot.yml" %>%
    package_file() %>%
    read_yaml()

  copilot_token <- openai_token_copilot(
    defaults = copilot_defaults$default,
    fail = FALSE
    )
  copilot_exists <- !is.null(copilot_token)

  gpt_token <- openai_token_chat(fail = FALSE)
  gpt_exists <- !is.null(gpt_token)

  llama_defaults <- "configs/llamagpt.yml" %>%
    package_file() %>%
    read_yaml()

  llama_exists <- file_exists(llama_defaults$default$path) &&
  file_exists(llama_defaults$default$model)

  prep_files <- files %>%
    map(read_yaml) %>%
    imap(~ {
      name <- .y %>%
        path_file() %>%
        path_ext_remove()
      model <- .x$default[["model"]] %||% ""
      provider <- .x$default[["provider"]] %||% ""
      c(provider, model, name)
    }) %>%
    set_names(
      files %>%
        path_file() %>%
        path_ext_remove()
    )

  if(!copilot_exists) {
    prep_files$copilot <- NULL
  }

  if(!gpt_exists) {
    prep_files$gpt35 <- NULL
    prep_files$gpt4 <- NULL
    prep_files$davinci <- NULL
  }

  if(!llama_exists) {
    prep_files$llamagpt <- NULL
  }

  orig_names <- names(prep_files)

  prep_files <- prep_files %>%
    set_names(seq_along(prep_files)) %>%
    imap(~ {
      if (.x[[1]] == .x[[2]] | is.logical(.x[[2]])) {
        x <- .x[[1]]
      } else {
        x <- paste(.x[[1]], "-", .x[[2]])
      }
      paste0(trimws(.y), ": ", x, " (", .x[[3]], ") \n")
    }) %>%
    set_names(orig_names)

  if(menu) {
    cli_h3("chattr - Available models")
    cli_text()
    prep_files %>%
      as.character() %>%
      cli_code()
    cli_text()
    model_no <- readline("Select the number of the model you would like to use: ")
    model_label <- names(prep_files[as.integer(model_no)])
    model_label
  } else {
    prep_files
  }

}
