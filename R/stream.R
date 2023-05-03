tidychat_stream_chat <- function(prompt,
                                 r_file_stream = tempfile(),
                                 r_file_complete = tempfile(),
                                 defaults = tidychat_defaults(type = "chat")
                                 ) {
  defaults$prompt <- process_prompt(defaults$prompt)
  rs <- tidychat_stream_session_start()
  rs$call(
    function(prompt, r_file_stream, r_file_complete, defaults) {
      res <- tidychat::tidychat_submit(
        defaults = do.call(tidychat::tidychat_defaults, args = defaults),
        prompt = prompt,
        r_file_stream = r_file_stream,
        r_file_complete = r_file_complete
      )
    },
    args = list(
      prompt = prompt,
      r_file_stream = r_file_stream,
      r_file_complete = r_file_complete,
      defaults = defaults
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
