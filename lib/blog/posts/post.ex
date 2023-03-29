defmodule Blog.Posts.Post do
  @moduledoc """
  The Post schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :title, :string
    field :published_on, :date
    field :visible, :boolean, default: true
    belongs_to :user, Blog.Accounts.User
    has_many :comments, Blog.Comments.Comment
    many_to_many :tags, Blog.Tags.Tag, join_through: "posts_tags", on_replace: :delete

    timestamps()
  end

  @doc """
  Returns a changeset for creating or updating a `Post`.

  """
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published_on, :visible, :user_id])
    |> put_assoc(:tags, attrs["tags"] || [])
    |> validate_required([:title, :content, :published_on])
    |> validate_required([:user_id], message: "only the author can edit this post")
    |> validate_change(:published_on, fn :published_on, date ->
      case Date.compare(date, Date.utc_today()) do
        :gt -> []
        :eq -> []
        :lt -> [published_on: "can't publish in the past"]
      end
    end)
  end
end
