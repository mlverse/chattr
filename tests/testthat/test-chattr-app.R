test_that("chattr_app() runs", {
  local_mocked_bindings(
    rstudioapi_jobRunScript = function(...) invisible(),
    rstudioapi_viewer = function(...) 0
  )
  chattr_use("test")
  expect_length(chattr_app(as_job = TRUE), 1)
})
