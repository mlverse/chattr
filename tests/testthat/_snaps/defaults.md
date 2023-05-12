# Basic default tests

    Code
      tc_defaults()
    Message <cliMessage>
      
      -- tidychat --------------------------------------------------------------------
      
      -- Defaults for: Console --
      
      -- Prompt: 
      * {{readLines(system.file('prompt/base.txt', package = 'tidychat'))}}
      
      -- Model 
      * Provider: Open AI
      Model: GPT 3.5 Turbo
      
      -- Model Arguments: 
      * temperature: 0.01
      * max_tokens: 1000
      * stream: TRUE
      
      -- Context: 
      v Chat History
      v Data Files
      v Data Frames
      x Document contents

