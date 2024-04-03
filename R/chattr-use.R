#' Sets the LLM model to use in your session
#' @param model_label The label of the LLM model to use. Valid values are
#' 'copilot', 'gpt4', 'gpt35', and 'llamagpt'. The value 'test' is also
#' acceptable, but it is meant for package examples, and internal testin.
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
  if (interactive_label) {
    model_label <- ch_get_ymls()
  }
  if (model_label == "test") {
    env_folder <- "apptest"
  } else {
    env_folder <- "configs"
  }
  use_switch(env_folder, path_ext_set(model_label, "yml"))
}

ch_get_ymls <- function(menu = TRUE) {
  files <- package_file("configs") %>%
    dir_ls()

  copilot_defaults <- "configs/copilot.yml" %>%
    package_file() %>%
    read_yaml()

  copilot_token <- ch_gh_token(
    defaults = copilot_defaults$default,
    fail = FALSE
  )
  copilot_exists <- !is.null(copilot_token)

  gpt_token <- ch_openai_token(fail = FALSE)
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

  if (!copilot_exists) {
    prep_files$copilot <- NULL
  }

  if (!gpt_exists) {
    prep_files$gpt35 <- NULL
    prep_files$gpt4 <- NULL
  }

  if (!llama_exists) {
    prep_files$llamagpt <- NULL
  }

  if (length(prep_files) == 0) {
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
      paste0(x, " (", .x[[3]], ") \n")
    }) %>%
    set_names(orig_names)

  if (menu) {
    cli_h3("chattr - Available models")
    cli_text("Select the number of the model you would like to use: ")
    model_no <- menu(prep_files)
    model_label <- names(prep_files[as.integer(model_no)])
    model_label
  } else {
    prep_files
  }
}

use_switch <- function(...) {
  ch_env$defaults <- NULL
  ch_env$chat_history <- NULL
  file <- package_file(...)

  label <- file %>%
    path_file() %>%
    path_ext_remove()

  Sys.setenv("CHATTR_MODEL" = label)

  chattr_defaults(
    type = "default",
    yaml_file = file,
    force = TRUE
  )

  walk(
    ch_env$valid_uis,
    ~ {
      chattr_defaults(
        type = .x,
        yaml_file = file
      )
    }
  )

  chattr_defaults_set(list(mode = label), "default")

  cli_div(theme = cli_colors())
  cli_h3("chattr")
  print_provider(chattr_defaults())
}
