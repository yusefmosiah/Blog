defmodule Blog.Repo.Migrations.ValidatePublishedOn do
  use Ecto.Migration

  def change do
    create constraint(:posts, :published_on, check: "published_on >= CURRENT_DATE")
  end
end
