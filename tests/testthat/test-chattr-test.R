test_that("Test function works for GPT 4.1", {
  ch_debug_set_true()
  expect_true(ch_debug_get())
  expect_snapshot(chattr_use("gpt41"))
  expect_snapshot(chattr_test())
  ch_debug_set_false()
  expect_false(ch_debug_get())
})

test_that("chattr_app() runs", {
  local_mocked_bindings(
    chattr = function(x) return(x)
  )
  td <- test_simulate_model("gpt41.yml")
  expect_snapshot(chattr_test(td))
})
