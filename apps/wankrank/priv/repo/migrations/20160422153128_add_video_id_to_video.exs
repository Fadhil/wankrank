defmodule Wankrank.Repo.Migrations.AddVideoIdToVideo do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :video_id, :string
    end

    create index(:videos, [:video_id])
  end
end
