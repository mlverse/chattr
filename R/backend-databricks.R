ch_databricks_token <- function(defaults, fail = TRUE) {
  env_key <- Sys.getenv("DATABRICKS_TOKEN", unset = NA)
  ret <- NULL
  if (!is.na(env_key)) {
    ret <- env_key
  }
  if (is.null(ret) && file_exists(Sys.getenv("R_CONFIG_FILE", "config.yml"))) {
    ret <- config::get("databricks-token")
  }
  if (is.null(ret) && fail) {
    abort(
      "No token found
    - Add your key to the \"DATABRICKS_TOKEN\" environment variable
    - or - Add  \"databricks-token\" to a `config` YAML file"
    )
  }
  ret
}

ch_databricks_host <- function(defaults, fail = TRUE) {
  env_key <- Sys.getenv("DATABRICKS_HOST", unset = NA)
  ret <- NULL
  if (!is.na(env_key)) {
    ret <- env_key
  }
  if (is.null(ret) && file_exists(Sys.getenv("R_CONFIG_FILE", "config.yml"))) {
    ret <- config::get("databricks-host")
  }
  if (is.null(ret) && fail) {
    abort(
      "No host found
    - Add your workspace url to the \"DATABRICKS_HOST\" environment variable
    - or - Add  \"databricks-host\" to a `config` YAML file"
    )
  }
  ret
}

#' @export
app_init_message.ch_databricks <- function(defaults) {
  print_provider(defaults)
  if (defaults$max_data_files > 0) {
    cli_alert_warning(
      paste0(
        "A list of the top {defaults$max_data_files} files will ",
        "be sent externally to Databricks with every request\n",
        "To avoid this, set the number of files to be sent to 0 ",
        "using {.run chattr::chattr_defaults(max_data_files = 0)}"
      )
    )
  }

  if (defaults$max_data_frames > 0) {
    cli_alert_warning(
      paste0(
        "A list of the top {defaults$max_data_frames} data.frames ",
        "currently in your R session will be sent externally to ",
        "Databricks with every request\n To avoid this, set the number ",
        "of data.frames to be sent to 0 using ",
        "{.run chattr::chattr_defaults(max_data_frames = 0)}"
      )
    )
  }
}
