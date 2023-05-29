# Sets to LLamaGPT model

    Code
      chattr_use("llamagpt")
    Message <cliMessage>
      * Provider: LlamaGPT
      * Model: LlamaGPT

# Session management works

    Code
      ch_test(defaults = ch_defaults())
    Message <cliMessage>
      v Model started sucessfully
      v Model session closed sucessfully

# Args output is correct

    Code
      ch_llamagpt_args(ch_defaults())
    Output
       [1] "--threads"                                  
       [2] "4"                                          
       [3] "--temp"                                     
       [4] "0.01"                                       
       [5] "--model"                                    
       [6] "/Users/edgar/ggml-gpt4all-j-v1.3-groovy.bin"
       [7] "--n_predict"                                
       [8] "1000"                                       
       [9] "--temperature"                              
      [10] "0.01"                                       
      [11] "--max_tokens"                               
      [12] "1000"                                       
      [13] "--stream"                                   
      [14] "TRUE"                                       

# Printout works

    Code
      ch_llamagpt_printout(ch_defaults(), output = "xxx\n> ")
    Message <cliMessage>
      
      -- chattr --
      
      -- Initializing model 
    Output
      xxx
      [1] "xxx\n"

# Console works

    Code
      capture.output(ch_llamagpt_output(stream_to = "console", output = "xxx\n> "))
    Output
      [1] "xxx"            "[1] \"xxx\\n\""

# Restore to previews defaults

    Code
      chattr_use("gpt35")
    Message <cliMessage>
      * Provider: Open AI
      * Model: GPT 3.5 Turbo

