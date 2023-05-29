# Model lists output is as expected

    Code
      capture.output(ch_get_ymls())
    Message <cliMessage>
      1 - Open AI - DaVinci 3 (davinci)
      
      2 - Open AI - GPT 3.5 Turbo (gpt35)
      
      3 - LlamaGPT (llamagpt)
      
    Output
      [1] "$davinci"                                         
      [2] "[1] \"1 - Open AI - DaVinci 3 (davinci)\\n\\n\""  
      [3] ""                                                 
      [4] "$gpt35"                                           
      [5] "[1] \"2 - Open AI - GPT 3.5 Turbo (gpt35)\\n\\n\""
      [6] ""                                                 
      [7] "$llamagpt"                                        
      [8] "[1] \"3 - LlamaGPT (llamagpt)\\n\\n\""            
      [9] ""                                                 

