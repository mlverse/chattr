# Missing token returns error

    No token found
        - Add your key to the "OPENAI_API_KEY" environment variable
        - or - Add  "openai-api-key" to a `config` YAML file

# Init messages work

    Code
      app_init_message(def)
    Message
      * Provider: OpenAI - Chat Completions
      * Model: gpt-4.1
      * Label: GPT 4.1 (OpenAI)
      ! A list of the top 10 files will be sent externally to OpenAI with every request
      To avoid this, set the number of files to be sent to 0 using `chattr::chattr_defaults(max_data_files = 0)`
      ! A list of the top 10 data.frames currently in your R session will be sent externally to OpenAI with every request
      To avoid this, set the number of data.frames to be sent to 0 using `chattr::chattr_defaults(max_data_frames = 0)`

