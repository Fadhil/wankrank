defmodule Wankrank.Repo.Migrations.CreateVideo do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :title, :string
      add :link, :text
      add :description, :text

      timestamps
    end

  end
end
