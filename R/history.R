#' Displays the current session' chat history
#' @param x An list object that contains chat history. Use this argument to
#' override the current history.
#' @export
tc_history <- function(x = NULL) {
  if (!is.null(x)) {
    tc_env$chat_history <- x
  }
  if (!is.null(tc_env$chat_history)) {
    class(tc_env$chat_history) <- "tc_history"
  }
  tc_env$chat_history
}

tc_history_append <- function(user = NULL, assistant = NULL) {
  if (!is.null(user)) {
    tc_env$chat_history <- c(
      tc_env$chat_history,
      list(list(role = "user", content = user))
    )
  }

  if (!is.null(assistant)) {
    tc_env$chat_history <- c(
      tc_env$chat_history,
      list(list(role = "assistant", content = assistant))
    )
  }
}

tc_history_set <- function(x) {
  tc_env$chat_history <- x
}
