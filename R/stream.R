tidychat_stream_chat <- function(prompt) {
  td <- tidychat_defaults(type = "chat")
  td$prompt <- process_prompt(td$prompt)
  rs <- tidychat_stream_session_start()
  rs$call(
    function(prompt, path, out, defaults) {
      tidychat:::tidychat_stream_path(path)
      res <- tidychat::tidychat_submit(
        defaults = do.call(tidychat::tidychat_defaults, args = defaults),
        prompt = prompt
      )
      saveRDS(res, out)
    },
    args = list(
      prompt = prompt,
      path = tidychat_stream_path(),
      out = tidychat_stream_output(),
      defaults = td
    )
  )
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
  if (!is.null(path)) {
    tidychat_env$app_file <- path
  }
  if (is.null(tidychat_env$app_file)) {
    tidychat_env$app_file <- tempfile()
  }
  tidychat_env$app_file
}

tidychat_stream_output <- function(path = NULL) {
  if (!is.null(path)) {
    tidychat_env$app_out <- path
  }
  if (is.null(tidychat_env$app_out)) {
    tidychat_env$app_out <- tempfile()
  }
  tidychat_env$app_out
}
