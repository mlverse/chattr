#' Displays the current session' chat history
#' @param x An list object that contains chat history. Use this argument to
#' override the current history.
#' @keywords internal
#' @export
ch_history <- function(x = NULL) {
  if (!is.null(x)) {
    ch_env$chat_history <- x
  }
  if (!is.null(ch_env$chat_history)) {
    class(ch_env$chat_history) <- "ch_history"
  }
  ch_env$chat_history
}

ch_history_append <- function(user = NULL, assistant = NULL) {
  if (!is.null(user)) {
    ch_env$chat_history <- c(
      ch_env$chat_history,
      list(list(role = "user", content = user))
    )
  }

  if (!is.null(assistant)) {
    ch_env$chat_history <- c(
      ch_env$chat_history,
      list(list(role = "assistant", content = assistant))
    )
  }
}

ch_history_set <- function(x) {
  ch_env$chat_history <- x
}

#' @export
print.ch_history <- function(x, ...) {
  cli_div(theme = cli_colors())
  print_history(x)
}
