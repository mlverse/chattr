# -------------------------------- History -------------------------------------

tc_history_get <- function() {
  tc_env$chat_history
}

tc_history_append <- function(user = NULL, assistant = NULL) {
  if (!is.null(user)) {
    tc_env$chat_history <- c(
      tc_env$chat_history,
      list(list(role = "user", content = user))
    )
  }

  if (!is.null(assistant)) {
    tc_env$chat_history <- c(
      tc_env$chat_history,
      list(list(role = "assistant", content = assistant))
    )
  }
}

tc_history_set <- function(x) {
  tc_env$chat_history <- x
}

# --------------------------------- Debug --------------------------------------

tc_debug_set_true <- function() {
  tc_env$debug <- TRUE
}

tc_debug_set_false <- function() {
  tc_env$debug <- FALSE
}

tc_debug_get <- function() {
  tc_env$debug <- tc_env$debug %||% FALSE
  tc_env$debug
}

# ------------------------------ Print Chat ------------------------------------

as_tc_request <- function(x, defaults) {
  class(defaults) <- "list"
  ret <- list(prompt = x, defaults = defaults)
  class(ret) <- "tc_request"
  ret
}

#' @export
print.tc_request <- function(x, ...) {
  cli_h1("tidychat")
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
  cli_colors()
  cli_h3("Prompt:")
  walk(x$prompt, ~ {
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

  if (file_exists(inst_file)) {
    pkg_file <- inst_file
  } else {
    pkg_file <- system.file(default_file, package = "tidychat")
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
