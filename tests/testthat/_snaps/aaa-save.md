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
       [8] "  model: GPT 3.5 Turbo"                                                         
       [9] "  model_arguments:"                                                             
      [10] "    temperature: 0.01"                                                          
      [11] "    max_tokens: 1000"                                                           
      [12] "    stream: yes"                                                                
      [13] "  system_msg: You are a helpful coding assistant"                               

