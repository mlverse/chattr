test_that("Submit method works", {
  local_mocked_bindings(
    ch_databricks_complete = function(...) {
      return("test return")
    }
  )
  def <- test_simulate_model("databricks-llama3-70b.yml")
  expect_equal(
    ch_submit(def, "test"),
    "test return"
  )
  expect_snapshot(
    ch_submit(def, "test", preview = TRUE)
  )
  def$include_history <- FALSE
  expect_snapshot(
    ch_submit(def, "test", preview = TRUE)
  )
})

test_that("Completion function works", {
  withr::with_envvar(
    new = c(
      "DATABRICKS_HOST" = "test",
      "DATABRICKS_TOKEN" = "test"
    ),
    {
      local_mocked_bindings(
        req_perform_stream = function(...) {
          x <- list()
          x$status_code <- 200
          x
        }
      )
      def <- test_simulate_model("databricks-llama3-70b.yml")
      expect_null(
        ch_databricks_complete(
          prompt = "test",
          defaults = def,
        )
      )
    }
  )
})

test_that("Error when status is not 200", {
  withr::with_envvar(
    new = c(
      "DATABRICKS_HOST" = "test",
      "DATABRICKS_TOKEN" = "test"
    ),
    {
      local_mocked_bindings(
        req_perform_stream = function(...) {
          x <- list()
          x$status_code <- 400
          x
        }
      )
      def <- test_simulate_model("databricks-llama3-70b.yml")
      expect_error(
        ch_databricks_complete(
          prompt = "test",
          defaults = def,
        )
      )
    }
  )
})

test_that("Missing token returns error", {
  withr::with_envvar(
    new = c("DATABRICKS_TOKEN" = NA),
    expect_error(ch_databricks_token(d))
  )
})

test_that("Missing host returns error", {
  withr::with_envvar(
    new = c("DATABRICKS_HOST" = NA),
    expect_error(ch_databricks_host(d))
  )
})


test_that("Init messages work", {
  def <- test_simulate_model("databricks-llama3-70b.yml")
  def$max_data_files <- 10
  def$max_data_frames <- 10
  expect_snapshot(app_init_message(def))
})
