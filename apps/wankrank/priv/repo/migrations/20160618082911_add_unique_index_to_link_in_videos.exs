defmodule Wankrank.Repo.Migrations.AddUniqueIndexToLinkInVideos do
  use Ecto.Migration

  def up do
    create unique_index(:videos, [:video_id])
  end

  def down do
    drop index(:videos, [:video_id])
  end
end
