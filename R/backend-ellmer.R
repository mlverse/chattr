#' @export
ch_submit.ch_ellmer <- function(
  defaults,
  prompt = NULL,
  stream = TRUE,
  prompt_build = TRUE,
  preview = FALSE,
  shiny = FALSE,
  ...
) {
  if (preview) {
    return(prompt)
  }
  ch_ellmer_init(defaults)
  if (prompt_build) {
    prompt <- ch_ellmer_prompt(prompt, defaults)
  }
  ret <- NULL
  if (!shiny) {
    chat <- ch_env$ellmer_obj$stream(prompt)
    coro::loop(for (chunk in chat) {
      ret <- paste0(ret, chunk)
      if (stream) {
        ide_paste_text(chunk)
      }
    })
  } else {
    ch_app_output(reset = TRUE)
    stream <- ch_env$ellmer_obj$stream_async(prompt)
    coro::async(function() {
      ch_app_status("busy")
      for (chunk in coro::await_each(stream)) {
        ch_app_output(append = chunk)
      }
      ch_app_status("idle")
    })()
  }
  ret
}

ch_ellmer_init <- function(defaults = NULL, chat = NULL) {
  if (!is.null(chat)) {
    ch_env$ellmer_obj <- chat$clone()$set_turns(list())
  }
  if (!is.null(defaults)) {
    new_code <- defaults$ellmer
    system_msg <- defaults$system_msg
    if (!is.null(new_code)) {
      old_code <- ch_env$ellmer_code %||% ""
      run_code <- FALSE
      if (old_code != new_code) {
        code_expr <- rlang::parse_expr(new_code)
        ch_env$ellmer_obj <- rlang::eval_bare(code_expr)
      }
    }
  } else {
    system_msg <- NULL
  }
  if (!is.null(system_msg)) {
    system_msg <- bulleted_list(system_msg)
    ch_env$ellmer_obj$set_system_prompt(system_msg)
  }
  invisible()
}

ch_ellmer_prompt <- function(prompt, defaults) {
  bulleted_list(
    c(
      process_prompt(defaults$prompt),
      ch_context_data_files(defaults$max_data_files),
      ch_context_data_frames(defaults$max_data_frames),
      prompt
    )
  )
}

ch_ellmer_history <- function(x) {
  defaults <- chattr_defaults()
  if (defaults$mode %||% "" == "ellmer" &&
    inherits(x, c("list", "ch_history"))
  ) {
    new_history <- map(
      x,
      \(.x) {
        ellmer::Turn(
          role = .x$role,
          contents = list(ellmer::ContentText(.x$content)),
          tokens = .x$tokens %||% c(0, 0, 0)
        )
      }
    )
    ch_env$ellmer_obj$set_turns(new_history)
  }
  invisible()
}
