#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @inheritParams ch_submit
#' @export
chattr <- function(prompt = NULL,
                   preview = FALSE,
                   prompt_build = TRUE,
                   stream = NULL) {
  ui <- ui_current()
  if(ui == "") ui <- "console"
  ret <- ch_submit(
    defaults = chattr_defaults(type = ui),
    prompt = prompt,
    stream = stream,
    prompt_build = prompt_build,
    preview = preview
  )
  if (is.null(ret)) {
    invisible()
  } else {
    return(ret)
  }
}
