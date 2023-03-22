ide_current <- function() {
  ret <- NULL
  if(!is.na(Sys.getenv("RSTUDIO", unset = NA))) ret <- "rstudio"
  ret
}

ide_paste_text <- function(x) {
  if(ide_current == "rstudio") {
    rstudioapi::insertText(x)
  }
  invisible()
}

ide_active_document_contents <- function() {
  cont <- NULL
  if(ide_current == "rstudio") {
    ad <- rstudioapi::getActiveDocumentContext()
    cont <- ad$contents
  }
  cont
}
