#' @export
ch_submit.ch_ellmer <- function(
    defaults,
    prompt = NULL,
    stream = TRUE,
    prompt_build = FALSE,
    preview = FALSE,
    ...) {

  code_raw <- defaults$ellmer
  code_expr <- rlang::parse_expr(code_raw)
  ellmer_obj <- rlang::eval_bare(code_expr)

  if (prompt_build) {
    # re-use OpenAI prompt
    prompt <- ch_openai_prompt(defaults, prompt)
  }

  if(preview) {
    return(prompt)
  }

  stream <- ellmer_obj$stream(prompt)
  ret <- NULL
  coro::loop(for (chunk in stream) {
    ret <- paste0(ret, chunk)
    cat(chunk)
  })
  ret
}
