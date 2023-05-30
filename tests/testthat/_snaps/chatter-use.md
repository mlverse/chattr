# Model lists output is as expected

    Code
      capture.output(ch_get_ymls())
    Message <cliMessage>
      
      -- chattr - Available models 
      
      1: Open AI - Completions - text-davinci-003 (davinci) 
      2: Open AI - Chat Completions - gpt-3.5-turbo (gpt35) 
      3: LlamaGPT - ~/ggml-gpt4all-j-v1.3-groovy.bin (llamagpt) 
      
    Output
      [1] "$davinci"                                                             
      [2] "[1] \"1: Open AI - Completions - text-davinci-003 (davinci) \\n\""    
      [3] ""                                                                     
      [4] "$gpt35"                                                               
      [5] "[1] \"2: Open AI - Chat Completions - gpt-3.5-turbo (gpt35) \\n\""    
      [6] ""                                                                     
      [7] "$llamagpt"                                                            
      [8] "[1] \"3: LlamaGPT - ~/ggml-gpt4all-j-v1.3-groovy.bin (llamagpt) \\n\""
      [9] ""                                                                     

