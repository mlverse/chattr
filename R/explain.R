tidychat_explain_prompt <- function(prompt = "explain these results") {
  prompt <- ide_prompt(
    title = "Object explanation",
    message = "Instructions or question about the output to submit",
    default = prompt
  )

  selection <- ide_get_selection()
  x <- eval(rlang::parse_expr(selection$value))

  tidychat_explain(
    x = x,
    prompt = prompt
  )
}

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
