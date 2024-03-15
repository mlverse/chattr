# Sets to LLamaGPT model

    Code
      chattr_use("llamagpt")
    Message
      
      -- chattr 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin

# Session management works

    Code
      chattr_test(defaults = chattr_defaults())
    Message
      
      -- Testing chattr 
      * Provider: LlamaGPT
      * Path/URL: ~/LlamaGPTJ-chat/build/bin/chat
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin
      v Model started sucessfully
      v Model session closed sucessfully

# Args output is correct

    Code
      out
    Output
      [1] "--threads"   "4"           "--temp"      "0.01"        "--n_predict"
      [6] "1000"        "--model"    

# Printout works

    Code
      ch_llamagpt_printout(chattr_defaults(), output = "xxx\n> ")
    Message
      
      -- chattr --
      
      -- Initializing model 
    Output
      xxx
      NULL

# Console works

    Code
      capture.output(ch_llamagpt_output(stream_to = "console", output = "xxx\n> "))
    Output
      [1] "xxx"  "NULL"

# Restore to previews defaults

    Code
      chattr_use("gpt35")
    Message
      
      -- chattr 
      * Provider: OpenAI - Chat Completions
      * Path/URL: https://api.openai.com/v1/chat/completions
      * Model: gpt-3.5-turbo

