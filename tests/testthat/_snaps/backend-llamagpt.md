# Sets to LLamaGPT model

    Code
      chattr_use("llamagpt")
    Message <cliMessage>
      * Provider: LlamaGPT
      * Model: ~/ggml-gpt4all-j-v1.3-groovy.bin

# Session management works

    Code
      ch_test(defaults = ch_defaults())
    Message <cliMessage>
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
      ch_llamagpt_printout(ch_defaults(), output = "xxx\n> ")
    Message <cliMessage>
      
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
    Message <cliMessage>
      * Provider: Open AI - Chat Completions
      * Model: gpt-3.5-turbo

