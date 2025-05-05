test_that("chattr_app() runs", {
  local_mocked_bindings(
    rstudioapi_jobRunScript = function(...) invisible(),
    rstudioapi_viewer = function(...) 0
  )
  withr::with_options(list("chattr-shiny-test" = TRUE), {
    test_model_backend()
    expect_length(chattr_app(as_job = TRUE), 1)
  })
})
