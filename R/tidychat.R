# --------------------------------- YAML ---------------------------------------
#' Creates
#' @param overwrite If there's an existing "config.yml", should it be replaced?
#' @export
tidychat_yaml_copy <- function(path = "config.yml",
                               overwrite = FALSE) {
  notebook <- tidychat_defaults(type = "notebook")
  notebook$prompt <- paste0(notebook$prompt, collapse = "\n")

  chat <- tidychat_defaults(type = "chat")
  chat$prompt <- paste0(chat$prompt, collapse = "\n")

  temp <- tempfile()
  x <- list(
    default = list(
      tidychat = list(
        notebook = notebook,
        chat = chat
      )
    )
  )

  yaml::write_yaml(x = x, file = temp)
  fs::file_copy(temp, path, overwrite = overwrite)
}

# ------------------------------- App File -------------------------------------

tidychat_env_app <- function(path = NULL) {
  if(!is.null(path)) {
    tidychat_env$app_file <- path
  }
  if(is.null(tidychat_env$app_file)) {
    tidychat_env$app_file <- tempfile()
  }
  tidychat_env$app_file
}

# -------------------------------- History -------------------------------------

tidychat_history_get <- function() {
  tidychat_env$chat_history
}

tidychat_history_append <- function(entry) {
  tidychat_env$chat_history <- c(tidychat_env$chat_history, entry)
}

tidychat_history_set <- function(x) {
  tidychat_env$chat_history <- x
}

# --------------------------------- Debug --------------------------------------

tidychat_debug_set_true <- function() {
  tidychat_env$debug <- TRUE
}

tidychat_debug_set_false <- function() {
  tidychat_env$debug <- FALSE
}

tidychat_debug_get <- function() {
  tidychat_env$debug <- tidychat_env$debug %||% FALSE
  tidychat_env$debug
}

# ---------------------------------- Use ---------------------------------------

tidychat_use_openai_gpt35 <- function() {
  tidychat_defaults(
    yaml_file = system.file("configs/gpt3.5.yml", package = "tidychat")
  )
}

tidychat_use_openai_davinci <- function() {
  tidychat_defaults(
    yaml_file = system.file("configs/davinci.yml", package = "tidychat")
  )
}
