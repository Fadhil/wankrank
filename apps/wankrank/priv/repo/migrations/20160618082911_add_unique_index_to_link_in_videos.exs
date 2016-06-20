defmodule Wankrank.Repo.Migrations.AddUniqueIndexToLinkInVideos do
  use Ecto.Migration

  def up do
    create unique_index(:videos, [:link])
  end

  def down do
    drop index(:videos, [:link])
  end
end
