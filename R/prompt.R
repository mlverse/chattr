build_prompt_new <- function(prompt = NULL, defaults = tc_defaults()) {
  td <- defaults

  header <- build_header(defaults)
  prompt <- build_null_prompt(prompt)

  if (!is.null(td$system_msg)) {
    system_msg <- list(list(role = "system", content = td$system_msg))
  }

  c(
    system_msg,
    if (td$include_history) tc_history_get(),
    list(
      list(role = "user", content = header),
      list(role = "user", content = prompt)
    )
  )
}

build_prompt_old <- function(prompt = NULL, defaults = tc_defaults()) {
  td <- defaults

  header <- build_header(defaults)
  prompt <- paste0("\n* ", build_null_prompt(prompt))

  paste0(header, prompt, collapse = "")
}

build_header <- function(defaults) {
  td <- defaults

  header <- c(
    process_prompt(td$prompt),
    if (td$include_data_files) context_data_files(),
    if (td$include_data_frames) context_data_frames()
  )

  paste0("* ", header, collapse = " \n")
}

build_null_prompt <- function(prompt) {
  if (is.null(prompt)) {
    selection <- ide_get_selection(TRUE)
    if (nchar(selection) > 0) {
      prompt <- selection
    } else {
      prompt <- context_doc_last_line()
    }
  }
  prompt
}
