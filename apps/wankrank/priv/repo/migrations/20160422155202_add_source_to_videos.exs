defmodule Wankrank.Repo.Migrations.AddSourceToVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :source, :string
    end
  end
end
