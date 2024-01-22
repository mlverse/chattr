test_that("Init messages work", {
  expect_snapshot(chattr_use("gpt35"))
  chattr_defaults(max_data_files = 10, max_data_frames = 10)
  expect_snapshot(app_init_openai(chattr_defaults()))
  expect_snapshot(chattr_use("llamagpt"))
  expect_snapshot(app_init_openai(chattr_defaults()))
})
