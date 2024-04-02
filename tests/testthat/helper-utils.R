test_simulate_model <- function(file, type = "console") {
  defaults <- package_file("configs", file) %>%
    yaml::read_yaml()
  as_ch_model(defaults$default, type)
}

test_model_backend <- function() {
  chattr_use("gpt4")
  chattr_defaults("chat", provider = "test backend")
  chattr_defaults("console", provider = "test backend")
  chattr_defaults("script", provider = "test backend")
}
