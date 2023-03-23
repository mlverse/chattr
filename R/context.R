context_data_files <- function() {
  all_files <- fs::dir_ls(recurse = TRUE)
  csv <- all_files[grepl(".csv", all_files)]
  parquet <- all_files[grepl(".parquet", all_files)]
  ret <- c(csv, parquet)
  paste("Data files available:", paste(ret, collapse = ", "))
}

context_data_frames <- function() {
  env_vars <- map(ls(envir = .GlobalEnv), ~ mget(.x, .GlobalEnv))

  env_dfs <- map_lgl(env_vars, ~ any(class(.x[[1]]) == "data.frame"))

  dfs <- env_vars[env_dfs]

  if (length(dfs)) {
    dfs <- dfs %>%
      map_chr(~ {
        fields <- paste(colnames(.x[[1]]), collapse = ", ")
        paste(" - Data:", names(.x), ";", "Fields:", fields)
      }) %>%
      paste(separator = " \n ") %>%
      paste(collapse = "") %>%
      paste0(
        "Data frames currently in R memory: \n ", .
      )
  } else {
    dfs <- NULL
  }
  dfs
}

context_doc_contents <- function(prompt = NULL) {
  content <- ide_active_document_contents()

  current_ui <- ui_current()

  if(current_ui == "markdown") {
    # assuming rmarkdown or quarto removes frontmatter
    fm_locations <- which(content == "---")
    if(length(fm_locations) == 2) {
      content <- content[(fm_locations[2] + 1):length(content)]
    }
  }

  if(is.null(prompt)) {
    ln <- content[length(content)]
    content <- c(
      content[1:(length(content) - 1)],
      "----",
      ln
    )
  }

  cont_paste <- paste0(content, collapse = " \n ")
  paste0("Current code: \n ", cont_paste)
}

context_doc_last_line <- function() {
  cont <- ide_active_document_contents()
  ln <- cont[length(cont)]
  if(substr(ln, 1, 2) == "# ") ln <- substr(ln, 3, nchar(ln))
  if(substr(ln, 1, 1) == "#") ln <- substr(ln, 2, nchar(ln))
  ln
}

context_loaded_packages <- function() {
  paste("Loaded libraries:", paste((.packages()), collapse = ", "))
}
