# Basic default tests

    Code
      chattr_use("ollama")
    Message
      
      -- chattr 
      * Provider: Ollama
      * Model: llama3.2
      * Label: Llama 3.2 (Ollama)

---

    Code
      chattr_defaults()
    Message
      
      -- chattr ----------------------------------------------------------------------
      
      -- Defaults for: Console --
      
      -- Prompt: 
      * For any line that is not code, prefix with a: #
      * Keep each line of explanations to no more than 80 characters
      * DO NOT use Markdown for the code
      
      -- Model 
      * Provider: Ollama
      * Model: llama3.2
      * Label: Llama 3.2 (Ollama)
      
      -- Context: 
      Max Data Files: 0
      Max Data Frames: 0
      x Chat History
      x Document contents

# Makes sure that changing something on 'default' changes it every where

    Code
      chattr_use("ollama")
    Message
      
      -- chattr 
      * Provider: Ollama
      * Model: llama3.2
      * Label: Llama 3.2 (Ollama)

---

    Code
      chattr_defaults(model = "test")
    Message
      
      -- chattr ----------------------------------------------------------------------
      
      -- Defaults for: Default --
      
      -- Prompt: 
      
      -- Model 
      * Provider: Ollama
      * Model: test
      * Label: Llama 3.2 (Ollama)
      
      -- Context: 
      Max Data Files: 0
      Max Data Frames: 0
      x Chat History
      x Document contents

# Changing something in non-default does not impact others

    Code
      chattr_use("ollama")
    Message
      
      -- chattr 
      * Provider: Ollama
      * Model: llama3.2
      * Label: Llama 3.2 (Ollama)

