defmodule Wankrank.Repo.Migrations.AddAnonymousIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :anonymous_id, :string
    end

    unique_index(:users, [:anonymous_id])
  end
end
