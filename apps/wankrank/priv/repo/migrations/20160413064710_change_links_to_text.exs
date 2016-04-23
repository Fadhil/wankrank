defmodule Wankrank.Repo.Migrations.ChangeLinksToText do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      modify :link,   :text
      modify :embed_link, :text
    end
  end
end
