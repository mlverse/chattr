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

context_doc_contents <- function() {
  cont <- ide_active_document_contents()
  cont_paste <- paste0(cont, collapse = " \n ")
  paste0("Current code: \n ", cont_paste, "\n ------- \n")
}

context_loaded_packages <- function() {
  paste("Loaded libraries:", paste((.packages()), collapse = ", "))
}
