test_that("Missing token returns error", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = NA),
    expect_snapshot_error(ch_openai_token(d))
  )
})

test_that("Init messages work", {
  def <- test_simulate_model("gpt41.yml")
  def$max_data_files <- 10
  def$max_data_frames <- 10
  expect_snapshot(app_init_message(def))
})
