# --------------------------------- Debug --------------------------------------

ch_debug_set_true <- function() {
  ch_env$debug <- TRUE
}

ch_debug_set_false <- function() {
  ch_env$debug <- FALSE
}

ch_debug_get <- function() {
  ch_env$debug <- ch_env$debug %||% FALSE
  ch_env$debug
}

# ------------------------------ Print Chat ------------------------------------

as_ch_request <- function(x, defaults) {
  class(defaults) <- "list"
  ret <- list(prompt = x, defaults = defaults)
  class(ret) <- "ch_request"
  ret
}

#' @export
print.ch_request <- function(x, ...) {
  cli_h1("chattr")
  type <- paste0(
    toupper(substr(x$defaults$type, 1, 1)),
    substr(x$defaults$type, 2, nchar(x$defaults$type))
  )
  cli_colors()
  cli_h3("Preview for: {.val0 {type}}")
  cli_li("Provider: {.val0 {x$defaults$provider}}")
  cli_li("Model: {.val0 {x$defaults$model}}")
  if (!is.null(x$defaults$model_arguments)) {
    iwalk(
      x$defaults$model_arguments,
      ~ cli_li("{.y}: {.val0 {.x}}")
    )
  }
  print_history(x$prompt)
}

#' @export
print.ch_history <- function(x, ...) {
  print_history(x)
}

print_history <- function(x) {
  cli_colors()
  cli_h3("Prompt:")
  walk(x, ~ {
    x <- .x
    x_named <- is_named(x)
    iwalk(x, ~ {
      split_x <- .x %>%
        strsplit("\n") %>%
        unlist()
      if (x_named) {
        title <- glue("{.y}:")
      } else {
        title <- NULL
      }
      if (length(split_x) == 1) {
        cli_text("{title} {.val1 {.x}}")
      } else {
        cli_text("{title}")
        walk(split_x, ~ cli_bullets("{.val1 {.x}}"))
      }
    })
  })
}

# ------------------------------- Utils ----------------------------------------

package_file <- function(...) {
  default_file <- path(...)
  inst_file <- path("inst", default_file)
  pkg_file <- NULL
  if (file_exists(inst_file)) {
    pkg_file <- inst_file
  } else {
    pkg_file <- system.file(default_file, package = "chattr")
  }
  if (!file_exists(pkg_file)) {
    abort(paste0("'", default_file, "' not found"))
  }
  pkg_file
}

cli_colors <- function(envir = parent.frame()) {
  cli_div(
    theme = list(
      span.val0 = list(color = "blue"),
      span.val1 = list(color = "darkgreen")
    ),
    .envir = envir
  )
}
