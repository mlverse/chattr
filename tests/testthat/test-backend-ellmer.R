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

test_that("Ellmer history works", {
  local_mocked_bindings(
    chattr_defaults = function(...) list(mode = "ellmer")
  )
  test_chat <- list(
    clone = function(...) {
      list(set_turns = function(...) {
        list(set_turns = function(x) list(x))
      })
    },
    set_turns = function(...) list()
  )
  test_model_backend()
  ch_ellmer_init(chat = test_chat, chattr_defaults())
  expect_silent(
    ch_ellmer_history(
      list(
        list(role = "user", contents = "this is a test")
      )
    )
  )
})
