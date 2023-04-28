#' Submits prompt to LLM
#' @param prompt Request to send to LLM. Defaults to NULL
#' @export
tidy_chat <- function(prompt = NULL) {
  out <- tidychat_send(
    prompt = prompt,
    prompt_build = TRUE,
    add_to_history = TRUE
  )
  ide_paste_text(out)
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

build_prompt <- function(prompt = NULL, use_current_mode = TRUE, defaults) {
  td <- defaults

  if (is.null(prompt)) {
    prompt <- context_doc_last_line()
  }

  if (!is.null(td$system_msg)) {
    system_msg <- list(list(role = "system", content = td$system_msg))
  }

  header <- c(
    td$prompt,
    if (td$include_data_files) context_data_files(),
    if (td$include_data_frames) context_data_frames(),
    if (td$include_doc_contents & !use_current_mode) context_doc_contents(prompt)
  )

  header <- paste0("* ", header, collapse = " \n")

  if (!td$include_doc_contents & !use_current_mode) {
    header <- paste0(header, "\n ------ \n", prompt)
  }

  if (use_current_mode) {
    full <- c(
      system_msg,
      tidychat_history_get(),
      list(
        list(
          role = "user",
          content = header
        ),
        list(
          role = "user",
          content = prompt
        )
      )
    )
  } else {
    full <- c(
      system_msg,
      list(
        list(
          role = "user",
          content = header
        )
      )
    )
  }

  list(
    prompt = prompt,
    full = full
  )
}
