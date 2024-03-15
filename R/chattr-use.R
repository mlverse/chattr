#' Sets the LLM model to use in your session
#' @param model_label The label of the LLM model to use. Valid values are
#' 'copilot', 'gpt4', 'gpt35', 'davinci', and 'llamagpt'.
#' @details
#' If the error "No model setup found" was returned, that is because none of the
#' expected setup for Copilot, OpenIA or LLama was automatically detected. Here
#' is how to setup a model:
#'
#' * OpenIA - The main thing `chattr` checks is the prescence of the R user's
#' OpenAI PAT (Personal Access Token). It looks for it in the 'OPENAI_API_KEY'
#' environment variable. Get a PAT from the OpenAI website, and save it to that
#' environment variable. Then restart R, and try again.
#'
#' * GitHub Copilot - Setup GitHub Copilot in your RStudio IDE, and restart
#' R. `chattr` will look for the default location where RStudio saves the
#' Copilot authentication information.
#'
#' Use the 'CHATTR_MODEL' environment variable to set it for the
#' R session, or create a YAML file named 'chattr.yml' in your working directory
#' to control the model, and the defaults it will use to communicate with such
#' model.
#' @returns It returns console messages to allow the user select the model to
#' use.
#' @export
chattr_use <- function(model_label = NULL) {
  interactive_label <- is_interactive() && is.null(model_label)
  overwrite <- FALSE
  if (interactive_label) {
    model_label <- ch_get_ymls()
  }
  use_switch("configs", path_ext_set(model_label, "yml"))
  if (interactive_label) {
    cli_text()
    cli_inform(paste0(
      "Would you like to make this the default by creating a",
      " new 'chattr.yml' file in your working folder?"
    ))
    save_yaml <- menu(c("Yes", "No"))
    if(save_yaml == 1) {
      if(file_exists("chattr.yml")) {
        cli_text()
        cli_inform(
          "'chattr.yml' already exists, replace?"
        )
        replace <- menu(c("Yes", "No"))
        overwrite <- replace == 1
        if(!overwrite) {
          return(invisible())
        }
      }
      chattr_defaults_save(overwrite = overwrite)
    }
  }
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

  if(length(prep_files) == 0) {
    abort(
      "No model setup found. Please use `?chattr_use` to get started",
      call = NULL
      )
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
