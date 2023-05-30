# Basic default tests

    Code
      ch_defaults()
    Message <cliMessage>
      
      -- chattr ----------------------------------------------------------------------
      
      -- Defaults for: Console --
      
      -- Prompt: 
      * {{readLines(system.file('prompt/base.txt', package = 'chattr'))}}
      
      -- Model 
      * Provider: Open AI - Chat Completions
      * Path: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
      
      -- Model Arguments: 
      * temperature: 0.01
      * max_tokens: 1000
      * stream: TRUE
      
      -- Context: 
      Max Data Files: 20
      Max Data Frames: 20
      v Chat History
      x Document contents

