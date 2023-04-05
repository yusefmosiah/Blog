defmodule Blog.OpenAIAPI do
  @moduledoc """
  The OpenAI API context.
  """
  def default_config do
    %{
      model: "gpt-3.5-turbo",
      api_key: System.get_env("OPENAI_API_KEY"),
      url: "https://api.openai.com/v1/chat/completions",
      max_tokens: 3700,
      system_message: %{
        role: "system",
        content:
          "you are a programming assistant, helping developers write web apps in elixir and phoenix."
      }
    }
  end

  def call(prompt, history \\ [], config \\ default_config()) do
    history =
      Task.async(fn -> call_api(prompt, history, config) end)
      |> Task.await(500_000)

    _comment = Enum.at(history, -1).content
  end

  def call_api(prompt, history \\ [], config \\ default_config()) do
    messages =
      ([%{role: "user", content: prompt} | history] ++ [config.system_message])
      |> Enum.reverse()

    body = %{model: config.model, messages: messages, max_tokens: config.max_tokens}

    headers = [
      Authorization: "Bearer #{config.api_key}",
      "Content-Type": "Application/json; Charset=utf-8"
    ]

    response_body =
      Req.post!(config.url, headers: headers, json: body, receive_timeout: 500_000).body

    %{
      "choices" => [
        %{
          "message" => %{
            "content" => content
          }
        }
      ]
    } = response_body

    history ++ [%{role: "user", content: prompt}, %{role: "assistant", content: content}]
  end
end
