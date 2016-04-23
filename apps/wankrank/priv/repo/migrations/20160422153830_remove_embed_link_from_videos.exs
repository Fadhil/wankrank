defmodule Wankrank.Repo.Migrations.RemoveEmbedLinkFromVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      remove :embed_link
    end
  end
end
