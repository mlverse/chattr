context_data_files <- function(
    max = NULL,
    file_types = c("csv", "parquet", "xls", "xlsx", "txt"),
    path = ".") {
  if (is.null(max)) {
    files <- get_files(
      path = path,
      file_types = file_types,
      recurse = TRUE
    )
  } else {
    total <- TRUE
    for (i in 2:4) {
      if (total) {
        files <- get_files(
          path = path,
          file_types = file_types,
          recurse = i
        )
        if (length(files) >= max) {
          total <- FALSE
          files <- files[seq_len(max)]
        }
      }
    }
  }

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

get_files <- function(path, file_types, recurse) {
  file_types %>%
    map(~ dir_ls(
      path = path,
      type = "file",
      glob = paste0("*.", .x),
      recurse = recurse
    )) %>%
    reduce(c)
}

context_data_frames <- function(max = NULL) {
  dfs <- ls(envir = .GlobalEnv) %>%
    map(~ mget(.x, .GlobalEnv)) %>%
    keep(~ inherits(.x[[1]], "data.frame"))

  if (length(dfs) > 0) {
    if (!is.null(max)) {
      dfs <- dfs[seq_len(max)]
      dfs <- dfs[!is.na(dfs)]
    }

    dfs <- dfs %>%
      map(~ {
        fields <- .x[[1]] %>%
          imap(~ paste0(.y)) %>%
          paste0(collapse = ", ")
        paste0("|--  ", names(.x), " (", fields, ")")
      })

    data_frames <- dfs %>%
      paste0(collapse = " \n")

    if (length(dfs) > 0) {
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
