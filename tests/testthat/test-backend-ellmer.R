test_that("Ellmer init works", {
  test_chat <- list(
    clone = function(...) {
      list(set_turns = function(...) {
        list()
      })
    }
  )
  test_model_backend()
  expect_silent(
    ch_ellmer_init(chat = test_chat, chattr_defaults())
  )
  expect_equal(ch_env$ellmer_obj, test_chat$clone()$set_turns())

  td <- chattr_defaults()
  td$ellmer <- "list()"
  ch_ellmer_init(td)
  expect_type(ch_env$ellmer_obj, "list")
})

test_that("Ellmer prompt works", {
  test_model_backend()
  expect_snapshot(
    ch_ellmer_prompt(prompt = "test", defaults = chattr_defaults())
  )
})

chat <- list(clone = function(...) {
  list(set_turns = function(...) {})
})
chat$clone()$set_turns(list())
