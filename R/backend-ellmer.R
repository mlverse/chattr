#' @export
ch_submit.ch_ellmer <- function(
    defaults,
    prompt = NULL,
    stream = TRUE,
    prompt_build = FALSE,
    preview = FALSE,
    ...) {

  if(preview) {
    return(prompt)
  }

  ch_init_ellmer(defaults)

  stream <- ch_env$ellmer_obj$stream(prompt)
  ret <- NULL
  coro::loop(for (chunk in stream) {
    ret <- paste0(ret, chunk)
    cat(chunk)
  })
  ret
}

ch_init_ellmer <- function(defaults) {
  new_code <- defaults$ellmer
  old_code <- ch_env$ellmer_code %||% ""
  run_code <- FALSE
  if(old_code != new_code) {
    code_expr <- rlang::parse_expr(new_code)
    chat <- rlang::eval_bare(code_expr)
    chat$set_system_prompt(defaults$system_msg)
    ch_env$ellmer_obj <- chat
  }
  invisible()
}
