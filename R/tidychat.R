#' Debugging functions
#'
#' @inheritParams tidy_chat
#' @export
tidychat_prompt <- function(prompt = NULL) {
  full <- build_prompt(prompt)$full
  if (is.list(full)) {
    print(full)
  } else {
    cat(full)
  }
}

#' @rdname tidychat_prompt
#' @export
tidychat_debug_set_true <- function() {
  tidychat_env$debug <- TRUE
}

#' @rdname tidychat_prompt
#' @export
tidychat_debug_set_false <- function() {
  tidychat_env$debug <- FALSE
}

#' @rdname tidychat_prompt
#' @export
tidychat_debug_get <- function() {
  debug <- tidychat_env$debug
  if (is.null(debug)) debug <- FALSE
  tidychat_env$debug <- debug
  debug
}

#' @rdname tidychat_prompt
#' @export
tidychat_history <- function() {
  hist <- tidychat_env$openai_history
  if (!is.null(hist)) {
    hist_chr <- map(
      hist,
      ~ {
        paste0("role: ", .x$role, "\ncontent:\n", .x$content, "\n")
      }
    )
    cat(paste0(hist_chr, collapse = "----------------------------\n"))
  }
}


#' Copies the base version of defaults used for tidychat
#' @param overwrite If there's an existing "config.yml", should it be replaced?
#' @export
tidychat_base_yaml <- function(overwrite = FALSE) {
  from <- system.file("configs/gpt3.5.yml", package = "tidychat")
  fs::file_copy(from, "config.yml", overwrite = overwrite)
}
