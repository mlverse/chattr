#' Method to easily integrate to new LLM's
#' @param defaults Defaults object, generally puled from `chattr_defaults()`
#' @param prompt The prompt to send to the LLM
#' @param stream To output the response from the LLM as it happens, or wait until
#' the response is complete. Defaults to TRUE.
#' @param prompt_build Include the context and additional prompt as part of the
#' request
#' @param preview Primarily used for debugging. It indicates if it should send
#' the prompt to the LLM (FALSE), or if it should print out the resulting
#' prompt (TRUE)
#' @param r_file_stream (Optional) Path to save the output of the current stream
#' from the LLM
#' @param r_file_complete (Optional) Path to save the completed output of the
#' stream, or response from the LLM
#' @param ... Optional arguments; currently unused.
#' @keywords internal
#' @export
ch_submit <- function(defaults,
                      prompt = NULL,
                      stream = NULL,
                      prompt_build = TRUE,
                      preview = FALSE,
                      r_file_stream = NULL,
                      r_file_complete = NULL,
                      ...) {
  ui_validate(defaults$type)
  UseMethod("ch_submit")
}

#' @export
#' @rdname ch_submit
ch_submit_job <- function(prompt,
                          stream = NULL,
                          prompt_build = TRUE,
                          r_file_stream = tempfile(),
                          r_file_complete = tempfile(),
                          defaults = chattr_defaults(type = "chat")) {
  defaults$prompt <- process_prompt(defaults$prompt)
  rs <- r_session_start()
  rs$call(
    function(prompt,
             stream,
             r_file_stream,
             r_file_complete,
             prompt_build,
             defaults,
             ch_history,
             preview) {
      chattr::ch_history(ch_history)
      chattr::ch_submit(
        defaults = do.call(
          what = chattr::chattr_defaults,
          args = defaults
        ),
        prompt = prompt,
        stream = stream,
        prompt_build = prompt_build,
        r_file_stream = r_file_stream,
        r_file_complete = r_file_complete,
        preview = preview
      )
    },
    args = list(
      prompt = prompt,
      r_file_stream = r_file_stream,
      r_file_complete = r_file_complete,
      prompt_build = prompt_build,
      defaults = defaults,
      stream = stream,
      ch_history = ch_history(),
      preview = ch_debug_get()
    )
  )
}

#' @export
#' @rdname ch_submit
ch_submit_job_stop <- function() {
  ch_env$r_session$close()
  invisible()
}

r_session_start <- function() {
  if (is.null(ch_env$r_session)) {
    ch_env$r_session <- r_session$new()
  }
  ch_env$r_session
}

r_session_error <- function() {
  out <- NULL
  if (!is.null(ch_env$r_session)) {
    read_session <- ch_env$r_session$read()
    if (!is.null(read_session)) {
      out <- read_session$error
    }
  }
  out
}

r_session_get <- function() {
  ch_env$r_session
}
