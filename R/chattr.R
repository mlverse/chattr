#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @inheritParams ch_submit
#' @returns The output of the LLM to the console, document or script.
#' @export
#' @examples
#' library(chattr)
#' chattr_use("test")
#' chattr("hello")
#' chattr("hello", preview = TRUE)
#'
chattr <- function(prompt = NULL,
                   preview = FALSE,
                   prompt_build = TRUE,
                   stream = NULL) {
  ui <- ui_current()
  if (ui == "") ui <- "console"
  defaults <- chattr_defaults(type = ui)

  stream <- stream %||% defaults$stream %||% TRUE

  if (is.null(defaults$provider)) {
    chattr_use()
    defaults <- chattr_defaults(type = ui)
  }

  prompt <- ide_build_prompt(
    prompt = prompt,
    defaults = defaults,
    preview = preview
  )

  if (ui_current() %in% c("markdown", "script")) {
    ch_r_submit(
      prompt = prompt,
      defaults = defaults,
      stream = stream,
      preview = preview,
      prompt_build = prompt_build
    )
    Sys.sleep(0.5)
    ret <- NULL
    while (ch_r_state() == "busy") {
      curr_text <- ch_r_output()
      ret <- c(ret, curr_text)
      ide_paste_text(curr_text)
    }
    error <- ch_r_error()
    if (!is.null(error)) {
      abort(error)
    }
  } else {
    ret <- ch_submit(
      defaults = defaults,
      prompt = prompt,
      stream = stream,
      prompt_build = prompt_build,
      preview = preview
    )
  }

  if (is.null(ret)) {
    invisible()
  }

  if (!stream) {
    cat(ret)
  }

  if (preview) {
    as_ch_request(ret, defaults)
  } else {
    ch_history_append(prompt, ret)
    return(invisible())
  }
}
