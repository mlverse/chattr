test_simulate_model <- function(file, type = "console") {
  defaults <- package_file("configs", file) %>%
    yaml::read_yaml()
  as_ch_model(defaults$default, type)
}

test_model_backend <- function() {
  chattr_use("test")
  chattr_defaults(provider = "test backend")
}
