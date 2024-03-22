# Request submission works

    Code
      openai_request(chattr_defaults(), list())
    Message
      <httr2_request>
      POST https://api.openai.com/v1/chat/completions
      Headers:
      * Authorization: '<REDACTED>'
      Body: json encoded data

# Error handling works

    Code
      parsed
    Output
      [1] "{{error}}Type:invalid_request_error\nMessage: This model's maximum context length is 4097 tokens. However, your messages resulted in 22261 tokens. Please reduce the length of the messages."

# Warning messages appear

    Code
      app_init_message.cl_openai(list(title = "test", max_data_files = 10,
        max_data_frames = 10))
    Message
      * Provider:
      * Path/URL:
      * Model:
      * Label:
      ! A list of the top 10 files will be sent externally to OpenAI with every request
      To avoid this, set the number of files to be sent to 0 using `chattr::chattr_defaults(max_data_files = 0)`
      ! A list of the top 10 data.frames currently in your R session will be sent externally to OpenAI with every request
      To avoid this, set the number of data.frames to be sent to 0 using `chattr::chattr_defaults(max_data_frames = 0)`

# Copilot httr2 request works

    Code
      openai_request.ch_openai_github_copilot_chat(defaults = list(path = "url"),
      req_body = list())
    Message
      <httr2_request>
      POST url
      Headers:
      * Authorization: '<REDACTED>'
      * Editor-Version: 'vscode/9.9.9'
      Body: json encoded data

