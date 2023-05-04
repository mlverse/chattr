#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @inheritParams tc_submit
#' @export
tidychat <- function(prompt = NULL, preview = FALSE, stream = NULL) {
  ret <- tc_submit(
    defaults = tc_defaults(),
    prompt = prompt,
    stream = stream,
    preview = preview
  )
  if (is.null(ret)) {
    invisible()
  } else {
    return(ret)
  }
}
