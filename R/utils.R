#' Saves the current defaults in a yaml file that is compatible with
#' the config package
#' @param path Path to the file to save the configuration to
#' @param overwrite Indicates to replace the file if it exists
#' @param type The type of UI to save the defaults for. It defaults to NULL which
#' will save whatever types had been used during the current R session
#' @export
tc_defaults_save <- function(path = "tidychat.yml",
                             overwrite = FALSE,
                             type = NULL) {
  invisible(tc_defaults(type = "default"))

  temp <- tempfile()

  td <- tc_env$defaults
  td_names <- names(td)
  td_other <- td_names[td_names != "default"]
  td_default <- td$default

  other <- map(
    td[td_other],
    ~ {
      match <- purrr::imap_lgl(
        .x,
        ~ {
          y <- td_default[[.y]]
          x <- .x
          if (!inherits(x, "list")) {
            if (inherits(x, "character")) {
              x <- paste0(x, collapse = "")
              y <- paste0(y, collapse = "")
            }
            x != y
          } else {
            ma <- purrr::imap_lgl(x, ~ .x == y[[.y]])
            !all(ma)
          }
        }
      )
      .x[match]
    }
  ) %>%
    purrr::keep(~ length(.x) > 0)

  td_all <- list(default = td_default)
  if (length(other) > 0) td_all <- c(td_all, other)

  write_yaml(x = td_all, file = temp)

  file_copy(temp, path, overwrite = overwrite)
}

# -------------------------------- History -------------------------------------

tc_history_get <- function() {
  tc_env$chat_history
}

tc_history_append <- function(user = NULL, assistant = NULL) {
  if (!is.null(user)) {
    user <- list(role = "user", content = user)
  }

  if (!is.null(assistant)) {
    assistant <- list(role = "assistant", content = assistant)
  }

  entry <- list(c(user, assistant))

  tc_env$chat_history <- c(
    tc_env$chat_history,
    entry
  )
}

tc_history_set <- function(x) {
  tc_env$chat_history <- x
}

# --------------------------------- Debug --------------------------------------

tidychat_debug_set_true <- function() {
  tc_env$debug <- TRUE
}

tidychat_debug_set_false <- function() {
  tc_env$debug <- FALSE
}

tidychat_debug_get <- function() {
  tc_env$debug <- tc_env$debug %||% FALSE
  tc_env$debug
}

# ---------------------------------- Use ---------------------------------------

tidychat_use_openai_gpt35 <- function() {
  use_switch("configs", "default.yml")
}

tidychat_use_openai_davinci <- function() {
  use_switch("configs", "davinci.yml")
}

use_switch <- function(...) {
  file <- package_file(...)
  walk(
    c("default", "console", "chat", "notebook", "script"),
    ~ {
      tc_defaults(
        type = .x,
        yaml_file = file,
        force = TRUE
      )
    }
  )
}

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
  cli_div(theme = list(
    span.val0 = list(color = "blue"),
    span.val1 = list(color = "darkgray")
  ))
  cli_h2("Preview for: {.val0 {type}}")
  cli_h3("Model")
  cli_li("Provider: {.val0 {x$defaults$provider}}")
  cli_li("Model: {.val0 {x$defaults$model}}")
  if (!is.null(x$defaults$model_arguments)) {
    cli_h3("Model Arguments:")
    iwalk(
      x$defaults$model_arguments,
      ~ cli_li("{.y}: {.val0 {.x}}")
    )
  }
  cli_div(theme = list(
    span.val0 = list(color = "blue"),
    span.val1 = list(color = "darkgray")
  ))
  cli_h3("Prompt:")
  walk(x$prompt, ~ {
    x <- .x
    x_named <- rlang::is_named(x)
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
        cli_text("{title} {.val0 {.x}}")
      } else {
        cli_text("{title}")
        walk(split_x, ~ cli_bullets("{.val0 {.x}}"))
      }
    })
  })
}
