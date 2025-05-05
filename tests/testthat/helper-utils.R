test_simulate_model <- function(file, type = "console") {
  defaults <- package_file("configs", file) %>%
    yaml::read_yaml()
  as_ch_model(defaults$default, type)
}

test_model_backend <- function() {
  use_switch(.file = package_file("apptest/test.yml"), .silent = TRUE)
}
