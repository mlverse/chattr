#' Sets the LLM model to use in your session
#' @param x A pre-determined provider/model name, an `ellmer` `Chat` object,
#' or the path to a YAML file that contains a valid `chattr` model specification.
#' The value 'test' is also acceptable, but it is meant for package examples,
#' and internal testing. See 'Details' for more information.
#' @param ... Default values to modify.
#' @details
#'
#' The valid pre-determined provider/models values are: 'databricks-dbrx',
#' 'databricks-meta-llama31-70b', 'databricks-mixtral8x7b', 'gpt41-mini',
#' 'gpt41-nano', 'gpt41', 'gpt4o', and 'ollama'.
#'
#' If you need a provider, or model, not available as a pre-determined value,
#' create an `ellmer` chat object and pass that to `chattr_use()`. The list of
#' valid models are found here: https://ellmer.tidyverse.org/index.html#providers
#'
#' ## Set a default
#'
#' You can setup an R `option` to designate a default provider/model connection.
#' To do this, pass an `ellmer` connection command you wish to use
#' in the `.chattr_chat` option, for example: `options(.chattr_chat = ellmer::chat_claude())`.
#' If you add that code to  your *.Rprofile*, `chattr` will use that as the default
#' model and settings to use every time you start an R session. Use the
#' `usethis::edit_r_profile()` command to easily edit your *.Rprofile*.
#'
#'
#' @returns It returns console messages to allow the user select the model to
#' use.
#'
#' @examples
#'
#' \dontrun{
#'
#' # Use a valid provider/model label
#' chattr_use("gpt41-mini")
#'
#' # Pass an `ellmer` object
#' my_chat <- ellmer::chat_claude()
#' chattr_use(my_chat)
#'
#' }
#'
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
  if (is.null(gpt_token)) {
    prep_files <- prep_files %>%
      discard(~ grepl("OpenAI", .x[1]))
  }

  dbrx_token <- ch_databricks_token(fail = FALSE)
  dbrx_host <- ch_databricks_host(fail = FALSE)
  if (is.null(dbrx_token) | is.null(dbrx_host)) {
    prep_files <- prep_files %>%
      discard(~ grepl("Databricks", .x[1]))
  }

  if (!ch_ollama_check()) {
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
  out <- package_file(env_folder, path_ext_set(x, "yml"), .fail = FALSE)
  if(is.null(out)) {
    abort(glue("'{x}' is not acceptable, it may be deprecated."), call = NULL)
  }
  out
}
