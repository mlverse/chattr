# Saving defaults work

    Code
      readLines(defaults_file)
    Output
       [1] "default:"                                                                       
       [2] "  prompt: '{readLines(system.file(''prompt/base.txt'', package = ''chattr''))}'"
       [3] "  max_data_files: 20"                                                           
       [4] "  max_data_frames: 20"                                                          
       [5] "  include_doc_contents: no"                                                     
       [6] "  include_history: yes"                                                         
       [7] "  provider: Open AI"                                                            
       [8] "  model_label: GPT 3.5 Turbo"                                                   
       [9] "  path: https://api.openai.com/v1/chat/completions"                             
      [10] "  model: gpt-3.5-turbo"                                                         
      [11] "  model_arguments:"                                                             
      [12] "    temperature: 0.01"                                                          
      [13] "    max_tokens: 1000"                                                           
      [14] "    stream: yes"                                                                
      [15] "  system_msg: You are a helpful coding assistant"                               

