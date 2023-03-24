# Functions to handle the integration with the different IDE's
# currently only handles RStudio

ide_current <- function() {
  ret <- NULL
  if (!is.na(Sys.getenv("RSTUDIO", unset = NA))) ret <- "rstudio"
  ret
}

ide_paste_text <- function(x) {
  if (ide_current() == "rstudio") {
    rstudioapi::insertText(x)
  }
  invisible()
}

ide_active_document_contents <- function() {
  cont <- NULL
  if (ide_current() == "rstudio") {
    ad <- rstudioapi::getActiveDocumentContext()
    cont <- ad$contents
    cont <- cont[cont != ""]
  }
  cont
}

ui_current <- function() {
  ret <- NULL
  current_ide <- ide_current()
  if (current_ide == "rstudio") {
    if (sys.nframe() > 0) {
      cont <- ide_active_document_contents()
      if (cont[1] == "---") {
        ret <- "markdown"
      } else {
        ret <- "script"
      }
    }
  }
  ret
}
