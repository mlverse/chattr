#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidychat <- function(prompt = NULL) {
  ret <- tidychat_send(
    prompt = prompt,
    prompt_build = TRUE
  )
  if(is.null(ret)) {
    invisible()
  } else {
   return(ret)
  }
}

tidychat_send <- function(prompt = NULL,
                          prompt_build = TRUE,
                          type = NULL,
                          preview = FALSE) {
  tidychat_submit(
    defaults = tidychat_defaults(type = type),
    prompt = prompt,
    prompt_build = prompt_build,
    preview = preview
  )
}
