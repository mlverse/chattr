# Functions to handle the integration with the different IDE's
# currently only handles RStudio

ide_current <- function() {
  ret <- NULL
  if (!is.na(Sys.getenv("RSTUDIO", unset = NA))) ret <- "rstudio"
  ret
}

ide_paste_text <- function(x, loc = NULL) {
  if (ide_current() == "rstudio") {
    if (is.null(loc)) {
      rstudioapi::insertText(text = x)
    } else {
      loc <- rstudioapi::document_range(c(loc, 0), c(loc, 0))
      rstudioapi::insertText(text = x, location = loc)
    }
  }
  invisible()
}

ide_append_to_document <- function(x, width = 81) {
  current <- ide_active_document_contents(remove_blanks = FALSE)

  x %>%
    strwrap(width = width) %>%
    paste0(collapse = "\n") %>%
    ide_paste_text(loc = length(current))
}

ide_active_document_contents <- function(remove_blanks = TRUE) {
  cont <- NULL
  if (ide_current() == "rstudio") {
    ad <- rstudioapi::getActiveDocumentContext()
    cont <- ad$contents
    if (remove_blanks) cont <- cont[cont != ""]
  }
  cont
}

ide_prompt <- function(title = "", message = "", default = NULL) {
  cont <- NULL
  if (ide_current() == "rstudio") {
    cont <- rstudioapi::showPrompt(
      title = title,
      message = message,
      default = default
    )
  }
  cont
}

ide_get_selection <- function(unhighlight = FALSE) {
  cont <- NULL
  if (ide_current() == "rstudio") {
    cont <- rstudioapi::selectionGet()
    cont <- cont$value

    if (unhighlight) {
      ac <- rstudioapi::getActiveDocumentContext()
      rstudioapi::setCursorPosition(as.vector(ac$selection[[1]]$range$end))
    }
  }
  cont
}

ui_current <- function() {
  ret <- NULL
  current_ide <- ide_current()
  if (current_ide == "rstudio") {
    cont <- rstudioapi::getActiveDocumentContext()
    if (cont$id == "#console") ret <- "console"
    if (is.null(ret)) {
      if (cont$contents[1] == "---") {
        ret <- "markdown"
      } else {
        ret <- "script"
      }
    }
  }
  ret
}
