# --------------------------- IDE Identification -------------------------------

ide_current <- function() {
  ret <- ""
  if (is_interactive()) {
    if (!is.na(Sys.getenv("RSTUDIO", unset = NA))) {
      ret <- "rstudio"
    }
  }
  ret
}

ide_is_rstudio <- function() {
  ide_current() == "rstudio"
}

# -------------------------- UI Identification ---------------------------------

ui_current <- function() {
  ret <- NULL
  if (ide_is_rstudio()) {
    cont <- getActiveDocumentContext()
    if (cont$id == "#console") ret <- "console"
    if (is.null(ret)) {
      if (cont$contents[1] == "---") {
        ret <- "markdown"
      } else {
        ret <- "script"
      }
    }
  } else {
    ret <- "console"
  }
  ret
}

ui_current_console <- function() {
  ui_current() == "console"
}

ui_current_markdown <- function() {
  ui_current() == "markdown"
}

# -------------------------- Document contents ---------------------------------

ide_paste_text <- function(x, loc = NULL) {
  if (ide_is_rstudio()) {
    if (is.null(loc)) {
      insertText(text = x)
    } else {
      loc <- document_range(c(loc, 0), c(loc, 0))
      insertText(text = x, location = loc)
    }
  }
  invisible()
}

ide_active_document_contents <- function(remove_blanks = TRUE) {
  cont <- NULL
  if (ide_is_rstudio()) {
    ad <- getActiveDocumentContext()
    cont <- ad$contents
    if (remove_blanks) cont <- cont[cont != ""]
  }
  cont
}

ide_comment_selection <- function() {
  prompt <- NULL
  if (ide_is_rstudio()) {
    active_doc <- getActiveDocumentContext()

    text_range <- active_doc$selection[[1]]$range
    start_row <- text_range$start[[1]]
    start_col <- text_range$start[[2]]
    end_row <- text_range$end[[1]]
    end_col <- text_range$end[[2]]

    selected <- active_doc$contents[start_row:end_row]
    end_size <- nchar(selected[length(selected)])

    doc_range <- document_range(
      document_position(start_row, 1),
      document_position(end_row, end_size + 1)
    )

    first_letter <- substr(selected, 1, 1)
    commented <- first_letter == "#"

    original <- paste0(selected, collapse = "\n")
    original[commented] <- substr(original[commented], 2, nchar(original[commented]))
    prompt <- trimws(original)

    prefix <- ifelse(commented, "", "# ")

    replacement <- paste0(prefix, selected, collapse = "\n")

    new_line <- paste0(replacement, "\n")

    modifyRange(
      location = doc_range,
      text = new_line
    )
  }
  prompt
}

# ------------------------------ Utils -----------------------------------------

ide_build_prompt <- function(prompt = NULL,
                             defaults = tc_defaults(),
                             preview = FALSE) {
  if (preview & is.null(prompt)) {
    prompt <- "[Your future prompt goes here]"
  }


  if (is.null(prompt)) {
    prompt <- ide_comment_selection()
  }

  err <- paste(
    "No 'prompt' provided, and no prompt cannot",
    "be infered from the current document"
  )

  err_flag <- FALSE
  if (is.null(prompt)) {
    err_flag <- TRUE
  } else if (nchar(prompt) == 0) {
    err_flag <- TRUE
  }

  if (err_flag) abort(err)

  prompt
}
