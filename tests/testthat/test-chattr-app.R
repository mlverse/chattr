test_that("chattr app initial values are consistent", {
  skip_on_cran()
  test_model_backend()
  shiny_app <- shinyApp(app_ui(), app_server)
  app <- shinytest2::AppDriver$new(shiny_app, options = list("chatter-shiny-test" = TRUE))
  app$expect_values(screenshot_args = FALSE)
  app$click("submit")
  app$expect_values(screenshot_args = FALSE)
})
