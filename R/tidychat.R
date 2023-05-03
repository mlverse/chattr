#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidychat <- function(prompt = NULL) {
  ret <- tc_submit(
    defaults = tc_defaults(),
    prompt = prompt,
    preview = FALSE
  )
  if (is.null(ret)) {
    invisible()
  } else {
    return(ret)
  }
}
