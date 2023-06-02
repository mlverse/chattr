# Basic chattr() tests

    Code
      chattr_use("gpt35")
    Message <cliMessage>
      
      -- chattr 
      * Provider: Open AI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo

---

    Code
      chattr("test", preview = TRUE)
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: Open AI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
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
      chattr("test", preview = TRUE, prompt_build = FALSE)
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: Open AI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
      * temperature: 0.01
      * max_tokens: 1000
      * stream: TRUE
      
      -- Prompt: 
      test

---

    Code
      chattr("test", preview = TRUE, stream = FALSE)
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: Open AI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
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
      chattr(preview = TRUE)
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: Open AI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
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
      chattr("test", stream = FALSE)
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
      ch_use_openai_davinci()
    Message <cliMessage>
      
      -- chattr 
      * Provider: Open AI - Completions
      * Path/URL: https://api.openai.com/v1/completions
      * Model: text-davinci-003

---

    Code
      chattr("test", preview = TRUE)
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: Open AI - Completions
      * Path/URL: https://api.openai.com/v1/completions
      * Model: text-davinci-003
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
      chattr("test", stream = FALSE)
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
      

# Data frames show up

    Code
      chattr(preview = TRUE)
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: Open AI - Completions
      * Path/URL: https://api.openai.com/v1/completions
      * Model: text-davinci-003
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
      * [Your future prompt goes here]

