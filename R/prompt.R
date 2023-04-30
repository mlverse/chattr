build_prompt <- function(prompt = NULL, use_current_mode = TRUE, defaults) {
  td <- defaults

  if (is.null(prompt)) {
    prompt <- context_doc_last_line()
  }

  if (!is.null(td$system_msg)) {
    system_msg <- list(list(role = "system", content = td$system_msg))
  }

  header <- c(
    process_prompt(td$prompt),
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
      if(td$include_history) tidychat_history_get(),
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
