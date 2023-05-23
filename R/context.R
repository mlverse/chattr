context_data_files <- function(max = "{Inf}",
                               file_types = c("csv", "parquet", "xls", "xlsx", "txt")
                               ) {
  all_files <- dir_ls(recurse = TRUE)

  files <- file_types %>%
    map(~ {
      all_files[path_ext(all_files) == .x]
    }) %>%
    reduce(c) %>%
    head(glue(max))

  if (length(files) > 0) {
    ret <- paste0(
      "Data files available: \n",
      paste("|-", files, collapse = "\n")
    )
  } else {
    ret <- NULL
  }

  ret
}

context_data_frames <- function(max = "{Inf}") {

  dfs <- ls(envir = .GlobalEnv) %>%
    map(~ mget(.x, .GlobalEnv)) %>%
    keep(~ inherits(.x[[1]], "data.frame"))

  if (length(dfs) > 0) {
    dfs <- dfs %>%
      map(~ {
        fields <- .x[[1]] %>%
          imap(~ paste0(.y)) %>%
          paste0(collapse = ", ")

        paste0("|--  ", names(.x), " (", fields, ")")
      }) %>%
      head(glue(max))

    data_frames <- dfs %>%
      paste0(collapse = " \n")

    if(length(dfs) > 0) {
      ret <- paste0(
        "Data frames currently in R memory (and columns): \n",
        data_frames
      )
    } else {
      ret <- NULL
    }

  } else {
    ret <- NULL
  }

  ret
}
