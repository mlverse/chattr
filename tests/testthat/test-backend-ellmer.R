test_that("Ellmer init works", {
  test_chat <- list(a = 1)
  chattr_use("test")
  expect_silent(
    ch_ellmer_init(chat = test_chat, chattr_defaults())
  )
  expect_equal(ch_env$ellmer_obj, test_chat)
})

test_that("Ellmer prompt works", {
  chattr_use("test")
  expect_snapshot(
    ch_ellmer_prompt(prompt = "test", defaults = chattr_defaults())
  )
})
