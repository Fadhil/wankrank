defmodule Wankrank.Repo.Migrations.ChangeDescriptionToText do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      modify :description, :text
    end
  end
end
