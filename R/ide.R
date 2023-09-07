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
  if (ch_debug_get()) {
    return(TRUE)
  }
  check_rstudio <- try(RStudio.Version(), silent = TRUE)
  !inherits(check_rstudio, "try-error")
}

globalVariables("RStudio.Version")

# -------------------------- UI Identification ---------------------------------

ui_current <- function() {
  ret <- ""
  if (ide_is_rstudio()) {
    cont <- rstudio_active_contents()
    if (cont$id == "#console") {
      ret <- "console"
    }
    if (ret == "") {
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

ide_paste_text <- function(x) {
  if (ide_is_rstudio()) {
    insertText(text = x)
  }
  invisible()
}

ide_comment_selection <- function() {
  prompt <- ""
  if (ide_is_rstudio()) {
    active_doc <- rstudio_active_contents()

    text_range <- active_doc$selection[[1]]$range
    start_row <- text_range$start[[1]]
    start_col <- text_range$start[[2]]
    end_row <- text_range$end[[1]]
    end_col <- text_range$end[[2]]

    selected <- active_doc$contents[start_row:end_row]
    end_size <- nchar(selected[length(selected)])

    if(end_size == 0) return("")

    first_letter <- substr(selected, 1, 1)
    commented <- first_letter == "#"

    selected[commented] <- substr(selected[commented], 2, nchar(selected[commented]))

    original <- paste0(selected, collapse = "\n")

    prompt <- trimws(original)

    prefix <- ifelse(commented, "", "# ")

    replacement <- paste0(prefix, selected, collapse = "\n")

    new_line <- paste0(replacement, "\n")

    if (!ch_debug_get()) {
      doc_range <- document_range(
        document_position(start_row, 1),
        document_position(end_row, end_size + 1)
      )

      modifyRange(
        location = doc_range,
        text = new_line
      )
    }
  }
  prompt
}

# ------------------------------ Utils -----------------------------------------

ide_build_prompt <- function(prompt = NULL,
                             defaults = chattr_defaults(),
                             preview = FALSE) {

  if (is.null(prompt)) {
    prompt <- ide_comment_selection()
  }

  if(prompt == "" && preview) {
    prompt <- "[Your future prompt goes here]"
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


rstudio_active_contents <- function() {
  if (ch_debug_get()) {
    readRDS(package_file("tests", "rstudio-script.rds"))
  } else {
    getActiveDocumentContext()
  }
}
