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
  cli_div(theme = cli_colors())
  cli_h1("chattr")
  type <- paste0(
    toupper(substr(x$defaults$type, 1, 1)),
    substr(x$defaults$type, 2, nchar(x$defaults$type))
  )
  cli_h3("Preview for: {.val1 {type}}")
  print_provider(x$defaults)
  if (!is.null(x$defaults$model_arguments)) {
    iwalk(
      x$defaults$model_arguments,
      ~ {
        cli_div(theme = cli_colors())
        cli_li("{.y}: {.val1 {.x}}")
      }
    )
  }
  print_history(x$prompt)
}

print_history <- function(x) {
  cli_colors()
  cli_h3("Prompt:")
  walk(x, ~ {
    x <- .x
    x_named <- is_named(x)
    iwalk(x, ~ {
      if (.y %in% c("role", "content")) {
        split_x <- .x |>
          strsplit("\n") |>
          unlist()
        if (x_named) {
          title <- glue("{.y}:")
        } else {
          title <- NULL
        }
        if (length(split_x) == 1) {
          cli_text("{title} {.val2 {.x}}")
        } else {
          cli_text("{title}")
          walk(split_x, ~ cli_bullets("{.val2 {.x}}"))
        }
      }
    })
  })
}

# ------------------------------- Utils ----------------------------------------

package_file <- function(..., .fail = TRUE) {
  default_file <- path(...)
  inst_file <- path("inst", default_file)
  pkg_file <- NULL
  if (file_exists(inst_file)) {
    pkg_file <- inst_file
  } else {
    pkg_file <- system.file(default_file, package = "chattr")
  }
  if (!file_exists(pkg_file)) {
    if (.fail) {
      abort(paste0("'", default_file, "' not found"))
    } else {
      return(NULL)
    }
  }
  pkg_file
}

cli_colors <- function(envir = parent.frame()) {
  list(
    span.val0 = list(color = "black"),
    span.val1 = list(color = "blue"),
    span.val2 = list(color = "darkgreen")
  )
}

ui_validate <- function(x) {
  if (!(x %in% ch_env$valid_uis)) {
    valid <- paste0(ch_env$valid_uis, collapse = ", ")
    abort(
      paste0("'", x, "' is not a valid type. Acceptable values are: ", valid)
    )
  }
}

print_provider <- function(x) {
  cli_div(theme = cli_colors())
  cli_li("{.val0 Provider:} {.val1 {x[['provider']]}}")
  cli_li("{.val0 Model:} {.val1 {x[['model']]}}")
  if (x[["label"]] != x[["model"]]) {
    cli_li("{.val0 Label:} {.val1 {x[['label']]}}")
  }
}

# ------------------------ Determine OS ----------------------------------------
os_get <- function() {
  if (.Platform$OS.type == "windows") {
    "win"
  } else if (Sys.info()["sysname"] == "Darwin") {
    "mac"
  } else {
    "unix"
  }
}

os_win <- function() {
  ifelse(os_get() == "win", TRUE, FALSE)
}

os_mac <- function() {
  ifelse(os_get() == "mac", TRUE, FALSE)
}

# ----------------------- Test? -----------------------------------------------
is_test <- function() {
  unlist(options("chattr-shiny-test")) %||% FALSE
}
