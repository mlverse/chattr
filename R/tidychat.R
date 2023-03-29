#' Debugging functions
#'
#' @inheritParams tidy_chat
#' @export
tidychat_prompt <- function(prompt = NULL) {
  cat(build_prompt(prompt))
}

#' @rdname tidychat_prompt
#' @export
tidychat_debug_set_true <- function() {
  tidychat_env$debug <- TRUE
}

#' @rdname tidychat_prompt
#' @export
tidychat_debug_set_false <- function() {
  tidychat_env$debug <- FALSE
}

#' @rdname tidychat_prompt
#' @export
tidychat_debug_get <- function() {
  debug <- tidychat_env$debug
  if (is.null(debug)) debug <- FALSE
  tidychat_env$debug <- debug
  debug
}
