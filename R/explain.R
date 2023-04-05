tidychat_explain <- function(x, prompt = "explain these results") {
  out <- paste0(capture.output(x), collapse = "\n")
  out <- paste0(prompt, ": \n", out)
  res <- tidychat_send(
    prompt = list(
      list(role = "user", content = out)
    ),
    prompt_build = FALSE,
    add_to_history = FALSE
  )
  ide_append_to_document(res)
}
