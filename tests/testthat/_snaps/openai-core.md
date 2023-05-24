# Request submission works

    Code
      openai_request("chat/completions", list())
    Message <cliMessage>
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

