library(gh)
library(purrr)
library(glue)
library(fs)

repo <- "mlverse/chattr"
workflow <- "R-CMD-check"

action_runs <- gh(glue("GET /repos/{repo}/actions/runs"))

latest_r_check <- action_runs$workflow_runs |>
  keep(\(x) x$name == workflow) |>
  head(1)

temp_file <- tempfile(fileext = ".zip")

gh(
  endpoint = glue("GET /repos/{repo}/actions/runs/{latest_r_check[[1]]$id}/logs"),
  .destfile = temp_file
)

temp_dir <- tempdir()
unzip(temp_file, exdir = temp_dir)

files <- dir_ls(temp_dir, glob = "*.txt")

get_line <- function(path) {
  job_log <- readLines(path)
  version_line <- job_log[substr(job_log, 30, 39) == " version  "]
  version_line <- substr(version_line, 40, nchar(version_line))
  system_line <- job_log[substr(job_log, 30, 39) == " system   "]
  system_line <- substr(system_line, 40, nchar(system_line))
  os_line <- job_log[substr(job_log, 30, 39) == " os       "]
  os_line <- substr(os_line, 40, nchar(os_line))
  glue("- {os_line} ({system_line}) {version_line}")
}

map_chr(files, get_line) |>
  paste0("\n") |>
  walk(cat)


dir_delete(temp_dir)
