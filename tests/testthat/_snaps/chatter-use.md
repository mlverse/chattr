# Model lists output is as expected

    Code
      capture.output(ch_get_ymls())
    Message
      
      -- chattr - Available models 
      
      1: OpenAI - Copilot Chat -  (copilot) 
      2: OpenAI - Completions - text-davinci-003 (davinci) 
      3: OpenAI - Chat Completions - gpt-3.5-turbo (gpt35) 
      4: OpenAI - Chat Completions - gpt-4 (gpt4) 
      5: LlamaGPT - ~/ggml-gpt4all-j-v1.3-groovy.bin (llamagpt) 
      
    Output
       [1] "$copilot"                                                             
       [2] "[1] \"1: OpenAI - Copilot Chat -  (copilot) \\n\""                    
       [3] ""                                                                     
       [4] "$davinci"                                                             
       [5] "[1] \"2: OpenAI - Completions - text-davinci-003 (davinci) \\n\""     
       [6] ""                                                                     
       [7] "$gpt35"                                                               
       [8] "[1] \"3: OpenAI - Chat Completions - gpt-3.5-turbo (gpt35) \\n\""     
       [9] ""                                                                     
      [10] "$gpt4"                                                                
      [11] "[1] \"4: OpenAI - Chat Completions - gpt-4 (gpt4) \\n\""              
      [12] ""                                                                     
      [13] "$llamagpt"                                                            
      [14] "[1] \"5: LlamaGPT - ~/ggml-gpt4all-j-v1.3-groovy.bin (llamagpt) \\n\""
      [15] ""                                                                     

