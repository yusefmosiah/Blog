defmodule Blog.Tags.Tag do
  @moduledoc """
  The Tag schema defines a many-to-many relationship with the Post schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    many_to_many :posts, Blog.Posts.Post, join_through: "post_tags", on_replace: :delete
    timestamps()
  end

  @doc """
  Returns a changeset for creating or updating a `Tag`.
  """
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
