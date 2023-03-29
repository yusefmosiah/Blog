defmodule Blog.Repo.Migrations.CreatePostTags do
  @moduledoc """
  This module defines the migration for the post_tags join table.

  """
  use Ecto.Migration

  @doc """
  Create the post_tags table, with :post_id and :tag_id foreign keys that reference the posts and tags tables, respectively.
  """
  def change do
    create table(:posts_tags) do
      add(:post_id, references(:posts, on_delete: :delete_all), null: false)
      add(:tag_id, references(:tags, on_delete: :delete_all), null: false)
      timestamps()
    end

    create(unique_index(:posts_tags, [:post_id, :tag_id]))
  end
end
