# Functions that retrieve the current values of the environment and document
# being worked on

context_data_files <- function() {
  all_files <- fs::dir_ls(recurse = TRUE)
  csv <- all_files[grepl(".csv", all_files)]
  parquet <- all_files[grepl(".parquet", all_files)]
  files <- c(csv, parquet)
  ret <- NULL
  if (length(files)) {
    ret <- paste("Data files available: ", paste(files, collapse = ", "))
  }
  ret
}

context_data_frames <- function() {
  env_vars <- map(ls(envir = .GlobalEnv), ~ mget(.x, .GlobalEnv))

  env_dfs <- map_lgl(env_vars, ~ any(class(.x[[1]]) == "data.frame"))

  dfs <- env_vars[env_dfs]

  ret <- NULL
  if (length(dfs)) {
    ret <- dfs %>%
      map(~ {
        fields <- .x[[1]] %>%
          imap(~ paste0(.y))

        fields <- paste0(fields, collapse = ", ")

        paste0("  * ", names(.x), " (", fields, ")")
      }) %>%
      paste0(collapse = " \n")

    ret <- paste0("Data frames currently in R memory (and columns): \n", ret)
  }

  ret
}

context_doc_contents <- function(prompt = NULL) {
  content <- ide_active_document_contents()

  current_ui <- ui_current()
  ret <- NULL

  if (current_ui == "markdown") {
    # assuming rmarkdown or quarto removes frontmatter
    fm_locations <- which(content == "---")
    if (length(fm_locations) == 2) {
      content <- content[(fm_locations[2] + 1):length(content)]
    }

    ln <- content[length(content)]

    # Extracting code chunks
    code_tags <- which(grepl("```", content))

    content <- code_tags %>%
      matrix(nrow = 2) %>%
      as.data.frame() %>%
      map(~ content[.x[1]:.x[2]]) %>%
      purrr::flatten() %>%
      as.character()

    content <- content[!grepl("#\\|", content)]

    if (prompt == ln) {
      content <- c(
        content,
        "--------",
        ln
      )
    }

    cont_paste <- paste0(content, collapse = " \n ")
    ret <- paste0("Current code: \n ", cont_paste)
  }

  if (current_ui == "console") {
    ret <- paste0(
      "Output is for console, do not encase code in code chunks",
      "\n--------\n",
      prompt
    )
  }

  ret
}

context_doc_last_line <- function() {
  cont <- ide_active_document_contents()
  ln <- NULL

  if(length(cont)) {
    ln <- cont[length(cont)]
    if (substr(ln, 1, 2) == "# ") ln <- substr(ln, 3, nchar(ln))
    if (substr(ln, 1, 1) == "#") ln <- substr(ln, 2, nchar(ln))
  }

  ln
}

context_loaded_packages <- function() {
  paste("Loaded libraries:", paste((.packages()), collapse = ", "))
}
