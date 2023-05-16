# Basic tidychat() tests

    Code
      tidychat("test", preview = TRUE)
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
      * For models, use tidymodels packages: recipes, parsnip, yardstick, workflows,
      broom
      * Avoid explanations unless requested by user, expecting code only
      test

---

    Code
      tidychat("test", preview = TRUE, prompt_build = FALSE)
    Message <cliMessage>
      
      -- tidychat --------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: Open AI
      * Model: GPT 3.5 Turbo
      * temperature: 0.01
      * max_tokens: 1000
      * stream: TRUE
      
      -- Prompt: 
      test

---

    Code
      tidychat("test", preview = TRUE, stream = FALSE)
    Message <cliMessage>
      
      -- tidychat --------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: Open AI
      * Model: GPT 3.5 Turbo
      * temperature: 0.01
      * max_tokens: 1000
      * stream: FALSE
      
      -- Prompt: 
      role: system
      content: You are a helpful coding assistant
      role: user
      content:
      * Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference
      * Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference
      * Use tidyverse packages: readr, ggplot2, dplyr, tidyr
      * For models, use tidymodels packages: recipes, parsnip, yardstick, workflows,
      broom
      * Avoid explanations unless requested by user, expecting code only
      test

---

    Code
      tidychat(preview = TRUE)
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
      * For models, use tidymodels packages: recipes, parsnip, yardstick, workflows,
      broom
      * Avoid explanations unless requested by user, expecting code only
      [Your future prompt goes here]

---

    Code
      tidychat("test", stream = FALSE)
    Output
      $model
      [1] "gpt-3.5-turbo"
      
      $messages
      $messages[[1]]
      $messages[[1]]$role
      [1] "system"
      
      $messages[[1]]$content
      [1] "You are a helpful coding assistant"
      
      
      $messages[[2]]
      $messages[[2]]$role
      [1] "user"
      
      $messages[[2]]$content
      [1] "* Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference \n* Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference \n* Use tidyverse packages: readr, ggplot2, dplyr, tidyr \n* For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom \n* Avoid explanations unless requested by user, expecting code only\ntest"
      
      
      
      $temperature
      [1] 0.01
      
      $max_tokens
      [1] 1000
      
      $stream
      [1] FALSE
      

# Using DaVinci

    Code
      tc_use_openai_davinci()
    Message <cliMessage>
      * Provider: Open AI
      * Model: DaVinci 3

---

    Code
      tidychat("test", preview = TRUE)
    Message <cliMessage>
      
      -- tidychat --------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: Open AI
      * Model: DaVinci 3
      * temperature: 0.01
      * max_tokens: 1000
      * stream: TRUE
      
      -- Prompt: 
      
      * Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference
      * Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference
      * Use tidyverse packages: readr, ggplot2, dplyr, tidyr
      * For models, use tidymodels packages: recipes, parsnip, yardstick, workflows,
      broom
      * Avoid explanations unless requested by user, expecting code only
      * For any line that is not code, prefix it with a: #
      * test

---

    Code
      tidychat("test", stream = FALSE)
    Output
      $model
      [1] "text-davinci-003"
      
      $prompt
      [1] "* Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference \n* Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference \n* Use tidyverse packages: readr, ggplot2, dplyr, tidyr \n* For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom \n* Avoid explanations unless requested by user, expecting code only \n* For any line that is not code, prefix it with a: #\n * test"
      
      $temperature
      [1] 0.01
      
      $max_tokens
      [1] 1000
      
      $stream
      [1] FALSE
      

