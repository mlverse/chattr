#' Default arguments to use when making requests to the LLM
#' @details The idea is that because we will use addin shortcut to execute the
#' request, all of the other arguments can be controlled via this function. By
#' default, it will try to load defaults from a `config` YAML file, if none are
#' found, then the defaults for GPT 3.5 will be used. The defaults can be modified
#' by calling this function, even after the interactive session has started.
#' @export
#' @param include_data_files Send the list of data files found in the working
#' directory? Defaults to NULL
#' @param include_data_frames Send the list of data.frames currently in the R
#' environment? Defaults to NULL
#' @param include_doc_contents Send the current code in the document
#' @param include_history Indicates weather to include the chat history when
#' everytime a new prompt is submitted
#' @param provider The name of the provider of the LLM. Today, only "openai" is
#' is available
#' @param model The name of the model to use, based on the provider
#' @param system_msg For GPT 3.5 or above, the system message to send as part of
#' the request
#' @param yaml_file The path to a valid `config` YAML file that contains the
#' defaults to use in a session
#' @param model_arguments Additional arguments to pass to the model as part of the
#' request, it requires a list. Examples of arguments: temperature, top_p,
#' max_tokens
#' @param type Entry point to interact with the model. Accepted values: 'notebook',
#' 'chat'
#' @inheritParams tidychat
tidychat_defaults <- function(prompt = NULL,
                              include_data_files = NULL,
                              include_data_frames = NULL,
                              include_doc_contents = NULL,
                              include_history = NULL,
                              provider = NULL,
                              model = NULL,
                              model_arguments = NULL,
                              system_msg = NULL,
                              yaml_file = "tidychat.yml",
                              type = NULL
                              ) {
  function_args <- as.list(environment())

  if(is.null(type)) {
    type <- ui_current()
    if(type == "markdown") type <- "notebook"
  }

  if (is.null(tidychat_get_defaults(type)$provider)) {

    default_file <- path("configs", "default.yml")
    inst_file <- path("inst", default_file)
    check_files <- NULL

    if(file_exists(inst_file)) {
      pkg_file <- inst_file
    } else {
      pkg_file <- system.file(default_file, package = "tidychat")
    }
    check_files <- pkg_file

    if (file_exists(yaml_file)) {
      check_files <- c(check_files, yaml_file)
    }

    for(j in seq_along(check_files)) {
      td_defaults <- read_yaml(file = check_files[j])
      check_defaults <- c("default", type)
      for(i in seq_along(check_defaults)) {
        td <- td_defaults[[check_defaults[i]]]
        if (!is.null(td)) {

          if (length(td$prompt) > 0) {
            td$prompt <- strsplit(td$prompt, split = "\n")[[1]]
          }
          td$type <- NULL

          tidychat_set_defaults(
            arguments = td,
            type = type
          )
        }
      }
    }
  }

  tidychat_set_defaults(
    arguments = function_args,
    type = type
  )

  ret <- tidychat_get_defaults(type)
  ret$type <- type

  class(ret) <- c(
    "tc_model",
    paste0("tc_provider_", prep_class_name(ret$provider)),
    paste0("tc_model_", prep_class_name(ret$model))
  )

  ret
}

prep_class_name <- function(x) {
  x <- tolower(x)
  x <- gsub(" \\(", "_", x)
  x <- gsub(" ", "_", x)
  x <- gsub("\\(", "_", x)
  x <- gsub("\\) ", "_", x)
  x <- gsub("\\)", "_", x)
  x
}

tidychat_get_defaults <- function(type = "notebook") {
  tidychat_env$defaults[[type]]
}

#' @export
print.tc_model <- function(x) {
  cli_div(theme = list(
    span.val0 = list(color = "blue"),
    span.val1 = list(color = "darkgray")
  ))
  cli_h1("tidychat")
  type <- paste0(
    toupper(substr(x$type, 1, 1)),
    substr(x$type, 2, nchar(x$type))
  )
  cli_h2("Defaults for: {.val0 {type}}")
  cli_h3("Prompt:")
  prompt <- process_prompt(x$prompt)
  walk(paste0("{.val1 ", prompt, "}"), cli_text)
  cli_h3("Model")
  cli_li("Provider: {.val0 {x$provider}}")
  cli_li("Model: {.val0 {x$model}}")
  if(!is.null(x$model_arguments)) {
    cli_h3("Model Arguments:")
    iwalk(
      x$model_arguments,
      ~ cli_li("{.y}: {.val0 {.x}}")
    )
  }
  cli_h3("Context:")
  print_include(x$include_history, "Chat History")
  print_include(x$include_data_files, "Data Files")
  print_include(x$include_data_frames, "Data Frames")
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

tidychat_set_defaults <- function(arguments = list(),
                                  type = NULL) {
  td <- tidychat_get_defaults(type)

  if(!is.null(td)) {
    for(i in seq_along(td)) {
      arguments[[names(td[i])]] <- arguments[[names(td[i])]] %||% td[[i]]
    }
  }

  tidychat_env$defaults[[type]] <- arguments

  tidychat_env$defaults[[type]]$type <- NULL
  tidychat_env$defaults[[type]]$yaml_file <- NULL
}

tidychat_openai_gpt3_base <- function() {
  c(
  "Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference",
  "Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference",
  "Use tidyverse packages: readr, ggplot2, dplyr, tidyr",
  "skimr and janitor can also be used if needed",
  "For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom",
  "Expecting only code, avoid comments unless requested by user"
  )
}

process_prompt <- function(x) {
  x %>%
    map(glue) %>%
    reduce(c)
}
