#' Saves the current defaults in a yaml file that is compatible with
#' the config package
#' @param path Path to the file to save the configuration to
#' @param overwrite Indicates to replace the file if it exists
#' @param type The type of UI to save the defaults for. It defaults to NULL
#' which will save whatever types had been used during the current R session
#' @returns It creates a YAML file with the defaults set in the current R
#' session.
#' @export
chattr_defaults_save <- function(path = "chattr.yml",
                                 overwrite = FALSE,
                                 type = NULL) {
  invisible(chattr_defaults(type = "default"))

  temp <- tempfile()

  td <- ch_env$defaults
  td_names <- names(td)
  td_other <- td_names[td_names != "default"]
  td_default <- td$default

  other <- map(
    td[td_other],
    ~ {
      match <- imap_lgl(
        .x,
        ~ {
          y <- td_default[[.y]]
          x <- .x
          if (!is.null(y) && !is.null(x)) {
            if (!inherits(x, "list")) {
              if (inherits(x, "character")) {
                x <- paste0(x, collapse = "")
                y <- paste0(y, collapse = "")
              }
              x != y
            } else {
              ma <- imap_lgl(x, ~ .x == y[[.y]])
              !all(ma)
            }
          } else {
            FALSE
          }
        }
      )
      .x[match]
    }
  ) %>%
    keep(~ length(.x) > 0)

  td_all <- list(default = td_default)
  if (length(other) > 0) td_all <- c(td_all, other)

  write_yaml(x = td_all, file = temp)

  file_copy(temp, path, overwrite = overwrite)
}
