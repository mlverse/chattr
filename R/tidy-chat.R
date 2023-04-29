#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidy_chat <- function(prompt = NULL) {
  tidychat_send(
    prompt = prompt,
    prompt_build = TRUE,
    add_to_history = TRUE
  )
}

tidychat_send <- function(prompt = NULL,
                          prompt_build = TRUE,
                          add_to_history = TRUE,
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
    add_to_history = add_to_history,
    preview = preview
  )
}
