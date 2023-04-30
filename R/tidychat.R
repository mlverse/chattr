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
                          type = "notebook",
                          preview = FALSE) {
  td <- tidychat_defaults(type = type)

  if (is.null(prompt)) {
    selection <- ide_get_selection(TRUE)
    if (nchar(selection) > 0) {
      prompt <- selection
    }
  }

  tidychat_submit(
    defaults = td,
    prompt = prompt,
    prompt_build = prompt_build,
    preview = preview
  )
}
