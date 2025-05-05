library(fs)
library(yaml)
library(purrr)

models <- function() {
  models_start <- "<!-- models: start -->"
  models_end <- "<!-- models: end -->"

  configs <- dir_ls("inst/configs/")

  configs <- configs[path_file(configs) != "ellmer.yml"]

  full_configs <- map(configs, read_yaml)

  text_configs <- full_configs |>
    imap(\(x, y)paste0("|", x$default$label, "| `", path_ext_remove(path_file(y)), "`|")) |>
    paste0(collapse = "\n")

  quarto_tbl <- paste0(
    models_start, "\n",
    "|Model & Provider| Use value|\n|----|----|\n",
    text_configs, "\n",
    models_end
  )

  ac <- getActiveDocumentContext()
  content <- ac$contents

  pos_start <- as.document_position(c(which(content == models_start), 1))
  pos_end <- as.document_position(c(which(content == models_end), nchar(models_end) + 1))
  pos_range <- document_range(pos_start, pos_end)
  modifyRange(pos_range, quarto_tbl)
}


