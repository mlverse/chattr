test_that("Request submission works", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "test"),
    {
      out <- ch_get_ymls(menu = FALSE)
      expect_equal(class(out), "list")
      expect_snapshot(out$gpt41)
      expect_snapshot(out$gpt4o)
    }
  )
})

test_that("Missing token prevents showing the option", {
  withr::with_envvar(
    new = c(
      "OPENAI_API_KEY" = NA,
      "DATABRICKS_TOKEN" = "test",
      "DATABRICKS_HOST" = "test"
    ),
    {
      out <- ch_get_ymls(menu = FALSE)
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
      out_names <- names(ch_get_ymls(menu = FALSE))
      expect_true(
        any(out_names %in% c("gpt41", "gpt4o"))
      )
      expect_false(
        any(out_names %in% c("databricks-dbrx", "databricks-mixtral8x7b"))
      )
    }
  )
})
