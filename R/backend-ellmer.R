#' @export
ch_submit.ch_ellmer <- function(
    defaults,
    prompt = NULL,
    stream = NULL,
    prompt_build = TRUE,
    preview = FALSE,
    ...) {

  code_raw <- defaults$ellmer
  code_expr <- rlang::parse_expr(code_raw)
  ellmer_obj <- rlang::eval_bare(code_expr)

  stream <- ellmer_obj$stream(prompt)
  coro::loop(for (chunk in stream) {
    cat(chunk)
  })
}
