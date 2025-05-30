#' Default arguments to use when making requests to the LLM
#' @details The idea is that because we will use addin shortcut to execute the
#' request, all of the other arguments can be controlled via this function. By
#' default, it will try to load defaults from a `config` YAML file, if none are
#' found, then the defaults for GPT 3.5 will be used. The defaults can be
#' modified by calling this function, even after the interactive session has
#' started.
#' @export
#' @param max_data_files Sets the maximum number of data files to send to the
#' model. It defaults to 20. To send all, set to NULL
#' @param max_data_frames Sets the maximum number of data frames loaded in the
#' current R session to send to the model. It defaults to 20. To send all,
#' set to NULL
#' @param include_doc_contents Send the current code in the document
#' @param include_history Indicates whether to include the chat history when
#' every time a new prompt is submitted
#' @param provider The name of the provider of the LLM. Today, only "openai" is
#' is available
#' @param path The location of the model. It could be an URL or a file path.
#' @param model The name or path to the model to use.
#' @param system_msg For OpenAI GPT 3.5 or above, the system message to send as
#' part of the request
#' @param yaml_file The path to a valid `config` YAML file that contains the
#' defaults to use in a session
#' @param model_arguments Additional arguments to pass to the model as part of
#' the request, it requires a list. Examples of arguments: temperature, top_p,
#' max_tokens
#' @param type Entry point to interact with the model. Accepted values:
#' 'notebook', chat'
#' @param force Re-process the base and any work space level file defaults
#' @param label Label to display in the Shiny app, and other locations
#' @param ... Additional model arguments that are not standard for all
#' models/backends
#' @returns An 'ch_model' object that contains the current defaults that will be
#' used to communicate with the LLM.
#' @inheritParams chattr

chattr_defaults <- function(type = "default",
                            prompt = NULL,
                            max_data_files = NULL,
                            max_data_frames = NULL,
                            include_doc_contents = NULL,
                            include_history = NULL,
                            provider = NULL,
                            path = NULL,
                            model = NULL,
                            model_arguments = NULL,
                            system_msg = NULL,
                            yaml_file = "chattr.yml",
                            force = FALSE,
                            label = NULL,
                            ...) {
  function_args <- c(as.list(environment()), ...)

  if (type == "default") {
    all_def <- function_args
    all_def$type == "all"
    chattr_defaults_set(arguments = function_args, type = "all")
  }

  sys_type <- Sys.getenv("CHATTR_TYPE", NA)
  if (!is.na(sys_type)) {
    type <- sys_type
  }

  if (is.null(type)) {
    if (!is_interactive()) {
      type <- "console"
    } else {
      type <- ui_current()
    }
  }

  if (type == "markdown") type <- "notebook"

  if (force) {
    ch_env$defaults <- NULL
  }
  env_model <- NULL
  check_files <- NULL
  if (is.null(chattr_defaults_get(type))) {
    # Overrides environment variable if YAML file is present
    if (file_exists(yaml_file)) {
      check_files <- yaml_file
    } else {
      env_use <- Sys.getenv("CHATTR_USE", unset = NA)
      if (!is.na(env_use)) {
        if (is_file(env_use)) {
          check_files <- path_expand(env_use)
        } else {
          check_files <- ch_package_file(env_use)
        }
      }
    }
    env_model <- Sys.getenv("CHATTR_MODEL", unset = NA)
    if (is.na(env_model)) {
      env_model <- NULL
    }
    for (j in seq_along(check_files)) {
      td_defaults <- read_yaml(file = check_files[j])
      loaded_default <- chattr_defaults_get(type = "default")
      td_defaults$default <- loaded_default %||% td_defaults$default
      td_defaults$default[["model"]] <- env_model %||% td_defaults$default[["model"]]
      check_defaults <- c("default", type)
      for (i in seq_along(check_defaults)) {
        td <- td_defaults[[check_defaults[i]]]
        if (!is.null(td)) {
          if (length(td$prompt) > 0 && any(grepl("\n", td$prompt))) {
            td$prompt <- unlist(strsplit(td$prompt, split = "\n"))
          }
          if (length(td$system_msg) > 0 && any(grepl("\n", td$system_msg))) {
            td$system_msg <- unlist(strsplit(td$system_msg, split = "\n"))
          }
          chattr_defaults_set(
            arguments = td,
            type = type
          )
        }
      }
    }
  }

  chattr_defaults_set(
    arguments = chattr_defaults_get("all"),
    type = type
  )

  ret <- chattr_defaults_get(type)
  as_ch_model(ret, type)
}

as_ch_model <- function(x, type) {
  x$type <- type
  provider <- tolower(x$provider)
  sp_provider <- unlist(strsplit(provider, " - "))
  if (length(sp_provider) > 1) {
    first_cl <- paste0("ch_", prep_class_name(sp_provider[[1]]))
  } else {
    first_cl <- NULL
  }
  x_mode <- x$mode %||% ""
  if (x_mode == "ellmer") {
    ch_ellmer <- "ch_ellmer"
  } else {
    ch_ellmer <- NULL
  }
  class(x) <- c(
    ch_ellmer,
    paste0("ch_", prep_class_name(provider)),
    first_cl,
    "ch_model"
  )
  x
}

prep_class_name <- function(x) {
  x <- tolower(x)
  look_for <- c(" - ", "-", " \\(", " ", "\\(", "\\) ", "\\)")
  for (item in look_for) {
    x <- gsub(item, "_", x)
  }
  x
}

chattr_defaults_get <- function(type = "notebook") {
  ch_env$defaults[[type]]
}

#' @export
print.ch_model <- function(x, ...) {
  cli_div(theme = cli_colors())

  cli_h1("chattr")
  type <- paste0(
    toupper(substr(x$type, 1, 1)),
    substr(x$type, 2, nchar(x$type))
  )
  cli_h2("Defaults for: {.val1 {type}}")
  cli_h3("Prompt:")

  prompt <- gsub("\\{", "\\{\\{", x$prompt)
  prompt <- gsub("\\}", "\\}\\}", prompt)

  walk(prompt, ~ cli_li("{.val2 {.x}}"))
  cli_colors()
  cli_h3("Model")
  print_provider(x)

  if (!is.null(x$model_arguments)) {
    cli_h3("Model Arguments:")
    iwalk(
      x$model_arguments,
      ~ cli_li("{.y}: {.val1 {.x}}")
    )
  }
  cli_h3("Context:")
  cli_text("Max Data Files: {.val1 {x$max_data_files}}")
  cli_text("Max Data Frames: {.val1 {x$max_data_frames}}")
  print_include(x$include_history, "Chat History")
  print_include(x$include_doc_contents, "Document contents")
  cli_end()
}

print_include <- function(x, label) {
  if (!is.null(x)) {
    if (x) {
      cli_alert_success(label)
    } else {
      cli_alert_danger(label)
    }
  }
}

chattr_defaults_set <- function(arguments = list(),
                                type = NULL) {
  td <- chattr_defaults_get(type)

  if (!is.null(td)) {
    for (i in seq_along(td)) {
      ctd <- td[[i]]
      name_ctd <- names(td[i])
      if (inherits(ctd, "list")) {
        args_list <- arguments[[name_ctd]]
        for (j in seq_along(ctd)) {
          ct <- ctd[j]
          args_list[[names(ct)]] <- args_list[[names(ct)]] %||% ct[[1]]
        }
        arguments[[name_ctd]] <- args_list
      } else {
        arguments[[name_ctd]] <- arguments[[name_ctd]] %||% ctd
      }
    }
  }

  arguments$type <- NULL
  arguments$yaml_file <- NULL
  arguments$force <- NULL

  ch_env$defaults[[type]] <- arguments
}

bulleted_list <- function(x) {
  if (length(x) == 1) {
    x <- unlist(strsplit(x, split = "\n"))
  }
  x <- process_prompt(x)
  paste0("* ", x, collapse = " \n")
}

process_prompt <- function(x) {
  if (is.null(x)) {
    return(x)
  }
  x %>%
    map(~ glue(.x)) %>%
    reduce(c)
}
