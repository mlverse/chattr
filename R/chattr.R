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
  defaults <- chattr_defaults(type = ui_current("console"))
  if (is.null(defaults$provider)) {
    chattr_use()
    defaults <- chattr_defaults(type = ui_current("console"))
  }

  stream <- stream %||% defaults$stream %||% TRUE

  prompt <- ide_build_prompt(
    prompt = prompt,
    defaults = defaults,
    preview = preview
  )

  ret <- ch_submit(
    defaults = defaults,
    prompt = prompt,
    stream = stream,
    prompt_build = prompt_build,
    preview = preview
  )

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
