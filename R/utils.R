#' Saves the current defaults in a yaml file that is compatible with
#' the config package
#' @param path Path to the file to save the configuration to
#' @param overwrite Indicates to replace the file if it exists
#' @param type The type of UI to save the defaults for. It defaults to NULL which
#' will save whatever types had been used during the current R session
#' @export
tidychat_defaults_save <- function(path = "config.yml",
                                   overwrite = FALSE,
                                   type = NULL
                                   ) {

  tidychat_defaults(type = "default")

  temp <- tempfile()

  x <- list(
    default = list(
      tidychat = list(
        tidychat_env$defaults
      )
    )
  )

  yaml::write_yaml(x = x, file = temp)

  fs::file_copy(temp, path, overwrite = overwrite)
}

# -------------------------------- History -------------------------------------

tidychat_history_get <- function() {
  tidychat_env$chat_history
}

tidychat_history_append <- function(user = NULL, assistant = NULL) {
  if (!is.null(user)) {
    user <- list(role = "user", content = user)
  }

  if (!is.null(assistant)) {
    assistant <- list(role = "assistant", content = assistant)
  }

  entry <- list(c(user, assistant))

  tidychat_env$chat_history <- c(
    tidychat_env$chat_history,
    entry
  )
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
