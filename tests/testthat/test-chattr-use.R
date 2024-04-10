test_that("Request submission works", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "test"),
    {
      out <- ch_get_ymls(menu = FALSE)
      expect_equal(class(out), "list")
      expect_snapshot(out$gpt35)
      expect_snapshot(out$gpt4)
    }
  )
})

test_that("Menu works", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "test"),
    {
      local_mocked_bindings(
        menu = function(...) {
          return(1)
        }
      )
      expect_true(
        ch_get_ymls(menu = TRUE) %in% c("gpt35", "gpt4")
      )
    }
  )
})


test_that("Menu works", {
  withr::with_envvar(
    new = c(
      "CHATTR_USE" = "llamagpt",
      "CHATTR_MODEL" = "test/path"
      ),
    expect_snapshot(chattr_defaults(force = TRUE))
  )
})
