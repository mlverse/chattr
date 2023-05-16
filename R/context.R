# Functions that retrieve the current values of the environment and document
# being worked on

context_data_files <- function() {
  all_files <- dir_ls(recurse = TRUE)
  csv <- all_files[grepl(".csv", all_files)]
  parquet <- all_files[grepl(".parquet", all_files)]
  files <- c(csv, parquet)
  ret <- NULL
  if (length(files)) {
    ret <- paste(
      "Data files available: \n",
      paste("|-", files, collapse = "\n")
    )
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

        paste0("|--  ", names(.x), " (", fields, ")")
      }) %>%
      paste0(collapse = " \n")

    ret <- paste0("Data frames currently in R memory (and columns): \n", ret)
  }

  ret
}
