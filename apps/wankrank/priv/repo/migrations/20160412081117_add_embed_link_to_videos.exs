defmodule Wankrank.Repo.Migrations.AddEmbedLinkToVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :embed_link, :string
    end
  end
end
