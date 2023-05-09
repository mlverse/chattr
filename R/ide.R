# Functions to handle the integration with the different IDE's
# currently only handles RStudio

ide_current <- function() {
  ret <- NULL
  if (!is.na(Sys.getenv("RSTUDIO", unset = NA))) {
    ret <- "rstudio"
  }
  ret
}

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

ide_is_rstudio <- function() {
  ide_current() == "rstudio"
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
  if (ide_is_rstudio()) {
    ad <- getActiveDocumentContext()
    cont <- ad$contents
    if (remove_blanks) cont <- cont[cont != ""]
  }
  cont
}

ide_prompt <- function(title = "", message = "", default = NULL) {
  cont <- NULL
  if (ide_is_rstudio()) {
    cont <- showPrompt(
      title = title,
      message = message,
      default = default
    )
  }
  cont
}

ide_get_selection <- function(unhighlight = FALSE) {
  cont <- NULL
  if (ide_is_rstudio()) {
    cont <- selectionGet()
    cont <- cont$value

    if (unhighlight & cont != "") {
      ac <- getActiveDocumentContext()
      setCursorPosition(as.vector(ac$selection[[1]]$range$end))
    }
  }
  cont
}

ide_quarto_selection <- function() {
  ret <- NULL
  if (ide_is_rstudio()) {
    active_doc <- getActiveDocumentContext()
    contents <- active_doc$contents
    text_range <- active_doc$selection[[1]]$range
    start_row <- text_range$start[[1]]
    start_col <- text_range$start[[2]]
    end_row <- text_range$end[[1]]
    end_col <- text_range$end[[2]]
    if (start_row != end_row | start_col != end_col) {
      text <- contents[start_row:end_row]
      ide_quarto_div(
        x = text,
        start = start_row,
        end = end_row
      )
      ret <- paste0(text, collapse = "\n")
    }
  }
  ret
}

ide_quarto_last_line <- function() {
  ret <- NULL
  if (ide_is_rstudio()) {
    active_doc <- getActiveDocumentContext()
    contents <- active_doc$contents
    no_empties <- contents[contents != ""]
    last_line <- no_empties[length(no_empties)]
    match_last <- which(contents == last_line)
    last_match <- match_last[length(match_last)]
    ide_quarto_div(
      x = last_line,
      start = last_match
    )
    ret <- last_line
  }
  ret
}

ide_quarto_div <- function(x, start, end = NULL) {
  if (ide_is_rstudio()) {
    if (is.null(end)) {
      end <- start
    }
    if (length(x) == 1) {
      commented_x <- paste0("#> Prompt: ", x)
      xp <- 1
    } else {
      commented_x <- paste0(
        "#> Prompt:\n",
        paste0("#>  ", x, collapse = "\n")
      )
      xp <- 2
    }
    with_div <- paste0(
      "::: {.content-hidden .llm-response}\n",
      commented_x,
      "\n\n:::\n\n"
    )
    modifyRange(
      location = document_range(
        document_position(start, 1),
        document_position(end, (nchar(x[length(x)]) + 1))
      ),
      text = paste(with_div)
    )
    setCursorPosition(
      document_position((start + length(x) + xp), 1)
    )
  }
}

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
  }
  ret
}

ui_current_console <- function() {
  ui_current() == "console"
}

ui_current_markdown <- function() {
  ui_current() == "markdown"
}

