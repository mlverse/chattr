tc_simulate_openai <- function() {
  if(is.null(tc_env$simulations$openai)) {
    app <- webfakes::new_app()
    app$use(webfakes::mw_json())
    app$post("/chat/completions", function(req, res) {
      res$send(readLines(package_file("responses", "chat-completion.json")))
    })
    tc_env$simulations$openai <- webfakes::local_app_process(app)
  }
  tc_env$simulations$openai
}



