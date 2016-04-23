defmodule Wankrank.Repo.Migrations.AddWanksToVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :wanks, :integer, default: 0
    end
  end
end
