# Test function works for OpenAI

    Code
      chattr_use("gpt35")
    Message
      
      -- chattr 
      * Provider: OpenAI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo

---

    Code
      chattr_test()
    Message
      
      -- Testing chattr 
      * Provider: OpenAI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo
      v Connection with OpenAI cofirmed
      |--Prompt: TEST
      |--Response: TEST

# Test function works for LlamaGPT

    Code
      chattr_use("llamagpt")
    Message
      
      -- chattr 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin

---

    Code
      chattr_test()
    Message
      
      -- Testing chattr 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      v Model started sucessfully
      v Model session closed sucessfully

# Test function works for Copilot

    Code
      chattr_use("copilot")
    Message
      
      -- chattr 
      * Provider: OpenAI - GitHub Copilot Chat
      * Path/URL: https://api.githubcopilot.com/chat/completions
      * Model: TRUE

---

    Code
      chattr_test()
    Message
      
      -- Testing chattr 
      * Provider: OpenAI - GitHub Copilot Chat
      * Path/URL: https://api.githubcopilot.com/chat/completions
      * Model:
      v Connection with GitHub Copilot cofirmed
      |--Prompt: TEST
      |--Response: TEST

