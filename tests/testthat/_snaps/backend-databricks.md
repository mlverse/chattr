# Init messages work

    Code
      app_init_message(def)
    Message
      * Provider: Databricks
      * Model: databricks-mixtral-8x7b-instruct
      * Label: Mixtral 8x7b (Datbricks)
      ! A list of the top 10 files will be sent externally to Databricks with every request
      To avoid this, set the number of files to be sent to 0 using `chattr::chattr_defaults(max_data_files = 0)`
      ! A list of the top 10 data.frames currently in your R session will be sent externally to Databricks with every request
      To avoid this, set the number of data.frames to be sent to 0 using `chattr::chattr_defaults(max_data_frames = 0)`

