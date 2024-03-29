ch_use_openai_gpt35 <- function() {
  use_switch("configs", "gpt35.yml")
}

ch_use_openai_davinci <- function() {
  use_switch("configs", "davinci.yml")
}

ch_use_llamagpt <- function() {
  use_switch("configs", "llamagpt.yml")
}

use_switch <- function(...) {
  ch_env$defaults <- NULL
  ch_env$chat_history <- NULL
  file <- package_file(...)

  label <- file %>%
    path_file() %>%
    path_ext_remove()

  Sys.setenv("CHATTR_MODEL" = label)

  chattr_defaults(
    type = "default",
    yaml_file = file,
    force = TRUE
  )

  walk(
    ch_env$valid_uis,
    ~ {
      chattr_defaults(
        type = .x,
        yaml_file = file
      )
    }
  )

  chattr_defaults_set(list(mode = label), "default")

  cli_div(theme = cli_colors())
  cli_h3("chattr")
  print_provider(chattr_defaults())
}
