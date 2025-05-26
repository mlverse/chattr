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
  local_mocked_bindings(
    ch_ollama_check = function(x) return(TRUE)
  )
  withr::with_envvar(
    new = c(
      "OPENAI_API_KEY" = NA,
      "DATABRICKS_TOKEN" = NA,
      "DATABRICKS_HOST" = NA
    ),
    {
      out <- ch_get_ymls(menu = FALSE)
      expect_null(out$gpt4)
      expect_null(out$gpt4o)
      expect_null(out$`databricks-dbrx`)
    }
  )
})

test_that("If all missing show error", {
  local_mocked_bindings(
    ch_ollama_check = function(x) return(FALSE)
  )
  withr::with_envvar(
    new = c(
      "OPENAI_API_KEY" = NA,
      "DATABRICKS_TOKEN" = NA,
      "DATABRICKS_HOST" = NA
    ),
    {
      expect_snapshot_error(ch_get_ymls(menu = FALSE))
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


test_that("Invalid label returns expected error", {
  expect_snapshot_error(ch_package_file("notexists"))
})

test_that("Uses ellmer object", {
  withr::with_envvar(
    new = c("ANTHROPIC_API_KEY" = "not really a key"), {
      my_model <- ellmer::chat_anthropic()
      expect_snapshot(chattr_use(my_model))

    }
  )
})
