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

  td <- tidychat_env$defaults
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

tidychat_history_get <- function() {
  tidychat_env$chat_history
}

tidychat_history_append <- function(user = NULL, assistant = NULL) {
  if (!is.null(user)) {
    user <- list(role = "user", content = user)
  }

  if (!is.null(assistant)) {
    assistant <- list(role = "assistant", content = assistant)
  }

  entry <- list(c(user, assistant))

  tidychat_env$chat_history <- c(
    tidychat_env$chat_history,
    entry
  )
}

tidychat_history_set <- function(x) {
  tidychat_env$chat_history <- x
}

# --------------------------------- Debug --------------------------------------

tidychat_debug_set_true <- function() {
  tidychat_env$debug <- TRUE
}

tidychat_debug_set_false <- function() {
  tidychat_env$debug <- FALSE
}

tidychat_debug_get <- function() {
  tidychat_env$debug <- tidychat_env$debug %||% FALSE
  tidychat_env$debug
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
    c("default", "console", "chat", "notebook"),
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
