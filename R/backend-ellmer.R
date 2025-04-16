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
  ch_ellmer_init(defaults)
  prompt <- ch_ellmer_prompt(prompt, defaults)
  stream <- ch_env$ellmer_obj$stream(prompt)
  ret <- NULL
  coro::loop(for (chunk in stream) {
    ret <- paste0(ret, chunk)
    cat(chunk)
  })
  ret
}

ch_ellmer_init <- function(defaults) {
  new_code <- defaults$ellmer
  old_code <- ch_env$ellmer_code %||% ""
  run_code <- FALSE
  if(old_code != new_code) {
    code_expr <- rlang::parse_expr(new_code)
    chat <- rlang::eval_bare(code_expr)
    system_msg <- process_prompt(defaults$system_msg)
    system_msg <- paste0("* ", system_msg, collapse = " \n")
    chat$set_system_prompt(system_msg)
    ch_env$ellmer_obj <- chat
  }
  invisible()
}

ch_ellmer_prompt <- function(prompt, defaults) {
  out <- c(
    process_prompt(defaults$prompt),
    ch_context_data_files(defaults$max_data_files),
    ch_context_data_frames(defaults$max_data_frames),
    prompt
  )
  paste0("* ", out, collapse = " \n")
}
