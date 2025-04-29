#' Sets the LLM model to use in your session
#' @param x The label of the LLM model to use, or the path of a valid YAML
#' default file, or an `ellmer` chat object. Valid values are 'gpt4', 'gpt35',
#' 'llamagpt', databricks-dbrx', 'databricks-meta-llama3-70b',
#' 'databricks-mixtral8x7b', and 'ollama'.
#' The value 'test' is also acceptable, but it is meant for package examples,
#' and internal testing.
#' @param ... Default values to modify.
#' @details
#' If the error "No model setup found" was returned, that is because none of the
#' expected setup for Copilot, OpenAI or LLama was automatically detected. Here
#' is how to setup a model:
#'
#' * OpenAI - The main thing `chattr` checks is the presence of the R user's
#' OpenAI PAT (Personal Access Token). It looks for it in the 'OPENAI_API_KEY'
#' environment variable. Get a PAT from the OpenAI website, and save it to that
#' environment variable. Then restart R, and try again.
#'
#' * GitHub Copilot - Setup GitHub Copilot in your RStudio IDE, and restart
#' R. `chattr` will look for the default location where RStudio saves the
#' Copilot authentication information.
#'
#' * Databricks - `chattr` checks for presence of R user's Databricks host and
#'  token ('DATABRICKS_HOST' and 'DATABRICKS TOKEN' environment variables).
#'
#' Use the 'CHATTR_MODEL' environment variable to set it for the
#' R session, or create a YAML file named 'chattr.yml' in your working directory
#' to control the model, and the defaults it will use to communicate with such
#' model.
#' @returns It returns console messages to allow the user select the model to
#' use.
#' @export
chattr_use <- function(x = NULL, ...) {
  curr_x <- x
  opt_chat <- getOption(".chattr_chat")
  if (is.null(curr_x) && !is.null(opt_chat)) {
    curr_x <- opt_chat
  }
  if (inherits(curr_x, "Chat")) {
    model <- curr_x$get_model()
    use_switch(
      .file = ch_package_file("ellmer"),
      model = model,
      provider = "ellmer",
      label = model,
      ...
    )
    ch_ellmer_init(chat = curr_x)
    return(invisible())
  }
  if (is_interactive() && is.null(curr_x)) {
    curr_x <- ch_get_ymls(x = x)
  }
  if (is_file(curr_x)) {
    curr_x <- path_expand(curr_x)
  } else {
    curr_x <- ch_package_file(curr_x)
  }
  use_switch(.file = curr_x, ...)
  invisible()
}

ch_get_ymls <- function(menu = TRUE, x = NULL) {
  files <- package_file("configs") %>%
    dir_ls() %>%
    discard(~ grepl("ellmer.yml", .x))

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

  gpt_token <- ch_openai_token(fail = FALSE)
  if(is.null(gpt_token)) {
    prep_files <- prep_files %>%
      discard(~ grepl("OpenAI", .x[1]))
  }

  dbrx_token <- ch_databricks_token(fail = FALSE)
  dbrx_host <- ch_databricks_host(fail = FALSE)
  if(is.null(dbrx_token) | is.null(dbrx_host)) {
    prep_files <- prep_files %>%
      discard(~ grepl("Databricks", .x[1]))
  }

  if(!ch_ollama_check()) {
    prep_files <- prep_files %>%
      discard(~ grepl("Ollama", .x[1]))
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

use_switch <- function(..., .file) {
  ch_env$defaults <- NULL
  ch_env$chat_history <- NULL

  label <- .file %>%
    path_file() %>%
    path_ext_remove()

  chattr_defaults(
    type = "default",
    yaml_file = .file,
    force = TRUE
  )

  walk(
    ch_env$valid_uis,
    ~ {
      chattr_defaults(
        type = .x,
        yaml_file = .file
      )
    }
  )

  chattr_defaults_set(list(mode = label), "default")

  cli_div(theme = cli_colors())
  cli_h3("chattr")
  print_provider(chattr_defaults(...))
}

ch_package_file <- function(x) {
  if (is.na(x)) {
    return(NULL)
  }
  env_folder <- ifelse(x == "test", "apptest", "configs")
  package_file(env_folder, path_ext_set(x, "yml"))
}
