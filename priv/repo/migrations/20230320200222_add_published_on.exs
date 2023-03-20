defmodule Blog.Repo.Migrations.AddPublishedOn do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :published_on, :date
    end
  end
end
