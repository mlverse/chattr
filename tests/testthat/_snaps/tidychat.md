# Basic tidychat() tests

    Code
      tidychat::tidychat("test", preview = TRUE)
    Message <cliMessage>
      
      -- tidychat --------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: Open AI
      * Model: GPT 3.5 Turbo
      * temperature: 0.01
      * max_tokens: 1000
      * stream: TRUE
      
      -- Prompt: 
      role: system
      content: You are a helpful coding assistant
      role: user
      content:
      * Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference
      * Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference
      * Use tidyverse packages: readr, ggplot2, dplyr, tidyr
      * skimr and janitor can also be used if needed
      * For models, use tidymodels packages: recipes, parsnip, yardstick, workflows,
      broom
      * Expecting only code, avoid comments unless requested by user
      * For any line that is not code, prefix it with a: #
      role: user
      content: test

