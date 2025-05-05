test_that("Missing token returns error", {
  withr::with_envvar(
    new = c("DATABRICKS_TOKEN" = NA),
    expect_error(ch_databricks_token(d))
  )
})

test_that("Missing host returns error", {
  withr::with_envvar(
    new = c("DATABRICKS_HOST" = NA),
    expect_error(ch_databricks_host(d))
  )
})


test_that("Init messages work", {
  def <- test_simulate_model("databricks-mixtral8x7b.yml")
  def$max_data_files <- 10
  def$max_data_frames <- 10
  expect_snapshot(app_init_message(def))
})
