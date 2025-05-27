#' Displays and sets the current session' chat history
#' @param x An list object that contains chat history. Use this argument to
#' override the current history.
#' @keywords internal
#' @returns A list object with the current chat history
#' @examples
#' library(chattr)
#'
#' chattr_use("test", stream = FALSE)
#'
#' chattr("hello")
#'
#' # View history
#' ch_history()
#'
#' # Save history to a file
#' chat_file <- tempfile()
#' saveRDS(ch_history(), chat_file)
#'
#' # Reset history
#' ch_history(list())
#'
#' # Re-load history
#' ch_history(readRDS(chat_file))
#'
#' @export
ch_history <- function(x = NULL) {
  if (!is.null(x)) {
    if(inherits(x, c("list", "ch_history"))) {
      ch_env$chat_history <- x
    } else {
      abort("Only list objects are acceptable as history")
    }
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
