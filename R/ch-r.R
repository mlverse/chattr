ch_r_start <- function() {
  if (is.null(ch_env$r_session)) {
    opts <- r_session_options()
    opts$stdout <- "|"
    opts$stderr <- "|"
    ch_env$r_session <- r_session$new(options = opts)
  }
}

ch_r_state <- function() {
  ch_r_start()
  ch_env$r_session$get_state()
}

ch_r_submit <- function(
    prompt,
    defaults,
    stream = TRUE,
    preview = FALSE,
    prompt_build = TRUE) {
  ch_r_start()
  ch_env$r_session$call(
    func = function(prompt, defaults, stream, preview, prompt_build) {
      chattr::ch_submit(
        defaults = defaults,
        prompt = prompt,
        stream = stream,
        preview = preview,
        prompt_build = prompt_build
      )
    },
    args = list(
      prompt = prompt,
      defaults = defaults,
      stream = stream,
      preview = preview,
      prompt_build = prompt_build
    )
  )
}

ch_r_output <- function() {
  x <- ch_env$r_session$read()
  ch_env$r_session$read_output()
}

ch_r_error <- function() {
  out <- NULL
  err <- ch_env$r_session$read_error()
  if (err != "") {
    error_marker <- "! {error}"
    if (substr(err, 1, nchar(error_marker)) == error_marker) {
      err <- substr(err, nchar(error_marker) + 1, nchar(err))
    }
    out <- err
  }
  out
}
