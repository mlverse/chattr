#' Sets the LLM model to use in your session
#' @param model_label The label of the LLM model to use. Valid values are
#' gpt35, davinci, and llamagpt.
#' @details Use the 'CHATTR_MODEL' environment variable to set it for the
#' R session.
#' @export
chattr_use <- function(model_label = NULL) {
  if (is_interactive() && is.null(model_label)) {
    prep_files <- ch_get_ymls()
    model_no <- readline("Select the number of the model you would like to use: ")
    model_label <- names(prep_files[as.integer(model_no)])
  }

  if (is.null(model_label)) {
    model_label <- "gpt35"
  }

  use_switch("configs", path_ext_set(model_label, "yml"))
}

ch_get_ymls <- function() {
  files <- package_file("configs") %>%
    dir_ls()

  prep_files <- files %>%
    map(read_yaml) %>%
    imap(~ {
      name <- .y %>%
        path_file() %>%
        path_ext_remove()
      c(.x$default$provider, .x$default$model_label, name)
    }) %>%
    set_names(seq_along(files)) %>%
    imap(~ {
      if (.x[[1]] == .x[[2]]) {
        x <- .x[[1]]
      } else {
        x <- paste(.x[[1]], "-", .x[[2]])
      }
      paste0(trimws(.y), ": ", x, " (", .x[[3]], ") \n")
    }) %>%
    set_names(
      files %>%
        path_file() %>%
        path_ext_remove()
    )

  cli_h3("chattr - Available models")
  cli_text()
  prep_files %>%
    as.character() %>%
    cli_code()
  cli_text()

  prep_files
}
