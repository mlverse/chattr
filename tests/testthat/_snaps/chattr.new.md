# Basic chattr() tests

    Code
      chattr("test", preview = TRUE)
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: LlamaGPT
      * Model: LlamaGPT
      * threads: 4
      * temp: 0.01
      * model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      * chat_path: ~/LlamaGPTJ-chat/build/bin/chat
      * n_predict: 1000
      * temperature: 0.01
      * max_tokens: 1000
      * stream: TRUE
      
      -- Prompt: 
      test(Use the R language, the tidyverse, and tidymodels)

---

    Code
      chattr("test", preview = TRUE, prompt_build = FALSE)
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: LlamaGPT
      * Model: LlamaGPT
      * threads: 4
      * temp: 0.01
      * model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      * chat_path: ~/LlamaGPTJ-chat/build/bin/chat
      * n_predict: 1000
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
      * Provider: LlamaGPT
      * Model: LlamaGPT
      * threads: 4
      * temp: 0.01
      * model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      * chat_path: ~/LlamaGPTJ-chat/build/bin/chat
      * n_predict: 1000
      * temperature: 0.01
      * max_tokens: 1000
      * stream: TRUE
      
      -- Prompt: 
      test(Use the R language, the tidyverse, and tidymodels)

---

    Code
      chattr(preview = TRUE)
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
      -- Preview for: Console 
      * Provider: LlamaGPT
      * Model: LlamaGPT
      * threads: 4
      * temp: 0.01
      * model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      * chat_path: ~/LlamaGPTJ-chat/build/bin/chat
      * n_predict: 1000
      * temperature: 0.01
      * max_tokens: 1000
      * stream: TRUE
      
      -- Prompt: 
      [Your future prompt goes here](Use the R language, the tidyverse, and
      tidymodels)

# Using DaVinci

    Code
      ch_use_openai_davinci()
    Message <cliMessage>
      * Provider: Open AI
      * Model: DaVinci 3

---

    Code
      chattr("test", preview = TRUE)
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
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
      * Data frames currently in R memory (and columns):
      |-- iris (Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, Species)
      |-- mtcars (mpg, cyl, disp, hp, drat, wt, qsec, vs, am, gear, carb)
      * [Your future prompt goes here]

