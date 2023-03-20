defmodule BlogWeb.PostView do
  use BlogWeb, :view

  # def render_code_blocks(content) do
  #   content
  #   |> String.split("```")
  #   |> Enum.map(fn segment, index ->
  #     if Integer.is_even(index) do
  #       "<pre class=\"code-frame\">#{Phoenix.HTML.raw(segment)}</pre>"
  #     else
  #       segment
  #     end
  #   end)
  #   |> Enum.join("")
  # end
end
