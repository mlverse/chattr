#' Copies the base version of defaults used for tidychat
#' @param overwrite If there's an existing "config.yml", should it be replaced?
#' @export
tidychat_base_yaml <- function(overwrite = FALSE) {
  from <- system.file("configs/gpt3.5.yml", package = "tidychat")
  fs::file_copy(from, "config.yml", overwrite = overwrite)
}

tidychat_history_get <- function() {
  tidychat_env$openai_history
}

tidychat_history_reset <- function() {
  tidychat_env$openai_history <- NULL
}

tidychat_debug_set_true <- function() {
  tidychat_env$debug <- TRUE
}

tidychat_debug_set_false <- function() {
  tidychat_env$debug <- FALSE
}

tidychat_debug_get <- function() {
  debug <- tidychat_env$debug
  if (is.null(debug)) debug <- FALSE
  tidychat_env$debug <- debug
  debug
}
