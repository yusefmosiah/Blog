defmodule BlogWeb.PostView do
  use BlogWeb, :view

  def tag_options do
    Blog.Tags.list_tags() |> Enum.map(fn tag -> {tag.name, tag.id} end)
  end

  def post_content_preview(post) do
    content =
      post.content
      |> String.graphemes()
      |> Enum.take(400)
      |> Enum.join()

    if String.length(post.content) > 400 do
      content <> "..."
    else
      content
    end
  end
end
