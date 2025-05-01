test_that("Testing the function directly", {
  withr::with_options(list("chattr-shiny-test" = TRUE),{
    expect_null(
      shiny::testServer(app_server, {
        session$setInputs(prompt = "hello", submit = TRUE)
      })
    )
  })
})

test_that("chattr app initial values are consistent", {
  skip_on_cran()
  shiny_app <- shinyApp(app_ui(), app_server)
  app <- shinytest2::AppDriver$new(
    shiny_app,
    options = list("chattr-shiny-test" = TRUE)
  )
  app$expect_values(output = "submit", screenshot_args = FALSE)
  app$set_inputs(prompt = "hello", allow_no_input_binding_ = TRUE)
  app$click("submit")
  app$expect_values(output = "submit", screenshot_args = FALSE)
  app$click("options")
  app$expect_values(output = "options", screenshot_args = FALSE)
  app$click("saved")
  app$expect_values(output = "saved", screenshot_args = FALSE)
})

test_that("Split content function", {
  content <- readRDS(package_file("history", "raw.rds"))[[2]]$content
  expect_snapshot(app_split_content(content))
})

test_that("Prep-entry works", {
  x <- prep_entry(c("a", "b", "c"), TRUE)
  expect_true(length(x) == 1)
  expect_equal(prep_entry("", TRUE), "")
})

test_that("Cleanup", {
  expect_null(ch_history_set(NULL))
})

test_that("Adding to history works", {
  local_mocked_bindings(
    ch_history = function(...) {
      c(list(list("role" = "user")))
    },
    insertUI = function(...) list(...),
  )
  expect_silent(app_add_history("test"))
})

test_that("app_add_assistant() function runs", {
  local_mocked_bindings(
    insertUI = function(...) invisible()
  )
  expect_silent(app_add_assistant("test\n```{r}\nx<-1\n```", list()))
})
