test_that("chattr app initial values are consistent", {
  skip_on_cran()
  shiny_app <- shinyApp(app_ui(), app_server)
  app <- shinytest2::AppDriver$new(shiny_app, options = list("chatter-shiny-test" = TRUE))
  app$expect_values(screenshot_args = FALSE)
  app$set_inputs(prompt = "hello")
  app$click("submit")
  app$expect_values(screenshot_args = FALSE)
})
