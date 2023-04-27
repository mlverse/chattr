#' @import callr
tidychat_stream_chat <- function(prompt) {
  out <- tempfile()
  rs <- tidychat_stream_session_start()
  rs$call(
    function(prompt, path, out) {
      tidychat:::tidychat_stream(prompt, path, out)
    },
    args = list(
      prompt = prompt,
      path = tidychat_stream_path(),
      out = out
    )
  )
  out
}

tidychat_stream <- function(prompt, path_stream, path_output) {
  tidychat_stream_path(path_stream)
  res <- tidychat_send(prompt = prompt)
  writeLines(res, path_output)
}

tidychat_stream_session_start <- function() {
  tidychat_env$r_session <- r_session$new()
  tidychat_env$r_session
}

tidychat_stream_session_stop <- function() {
  tidychat_env$r_session$close()
}

tidychat_stream_session_get <- function() {
  tidychat_env$r_session
}

tidychat_stream_path <- function(path = NULL) {
  if(!is.null(path)) {
    tidychat_env$app_file <- path
  }
  if(is.null(tidychat_env$app_file)) {
    tidychat_env$app_file <- tempfile()
  }
  tidychat_env$app_file
}
