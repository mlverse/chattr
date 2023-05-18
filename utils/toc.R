library(rstudioapi)

toc <- function() {
  ac <- getActiveDocumentContext()
  content <- ac$contents

  is_title <- substr(content, 1, 1) == "#" & substr(content, 2, 2) != "|"

  title <- content[is_title]

  toc_start <- "<!-- toc: start -->"
  toc_end <- "<!-- toc: end -->"

  toc <- NULL
  for(i in seq_along(title)) {
    current_title <- title[i]
    if(substr(current_title, 1, 4) == "### ") {
      new_title <- substr(current_title, 5, nchar(current_title))
      spacing <- "    - "
    }
    if(substr(current_title, 1, 3) == "## ") {
      new_title <- substr(current_title, 4, nchar(current_title))
      spacing <- "- "
    }
    if(grepl("\\{", new_title)) {
      split_title <- unlist(strsplit(new_title, " "))
      new_title <- paste0(split_title[1:(length(split_title) - 1)], collapse = " ")
    }
    new_link <- tolower(new_title)
    new_link <- gsub(" ", "-", new_link)
    ret <- paste0(spacing, "[", new_title, "](#", new_link, ")")
    toc <- c(toc, ret)
  }

  toc <- paste0(toc_start, "\n",
                paste0(toc, collapse = "\n"),
                "\n\n", toc_end)

  pos_start <- as.document_position(c(which(content == toc_start), 1))
  pos_end <- as.document_position(c(which(content == toc_end), nchar(toc_end) + 1))

  pos_range <- document_range(pos_start, pos_end)

  modifyRange(pos_range, toc)

}
