defmodule Blog.Repo.Migrations.DeletingAPostDeletesItsComments do
  @moduledoc """
  This migration is a bit more complicated than the others.
  We need to alter the comments table to have a foreign key constraint that deletes all comments when a post is deleted.
  """
  use Ecto.Migration

  defmodule Blog.Repo.Migrations.DeletingAPostDeletesItsComments do
    use Ecto.Migration

    def up do
      execute("ALTER TABLE comments DROP CONSTRAINT comments_post_id_fkey;")

      alter table(:comments) do
        modify :post_id, references(:posts, on_delete: :delete_all), null: false
      end
    end

    def down do
      execute("ALTER TABLE comments DROP CONSTRAINT comments_post_id_fkey;")

      alter table(:comments) do
        modify :post_id, references(:posts, on_delete: :nothing), null: false
      end
    end
  end
end
