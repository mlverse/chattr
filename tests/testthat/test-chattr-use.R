test_that("Request submission works", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "test"),
    {
      out <- ch_get_ymls(menu = FALSE)
      expect_equal(class(out), "list")
      expect_snapshot(out$gpt35)
      expect_snapshot(out$gpt4)
      expect_snapshot(out$gpt4o)
    }
  )
})

test_that("Missing token prevents showing the option", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = NA, "DATABRICKS_TOKEN" = "test"),
    {
      out <- ch_get_ymls(menu = FALSE)
      expect_null(out$gpt35)
      expect_null(out$gpt4)
      expect_null(out$gpt4o)
    }
  )
})


test_that("Menu works", {
  skip_on_cran()
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "test", "DATABRICKS_TOKEN" = NA),
    {
      local_mocked_bindings(
        menu = function(...) {
          return(1)
        }
      )
      print(ch_get_ymls(menu = TRUE))
      expect_true(
        ch_get_ymls(menu = TRUE) %in% c("gpt35", "gpt4", "gpt4o")
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
