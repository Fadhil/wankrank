defmodule Wankrank.Repo.Migrations.DropIndexAnonymousIdFromUsers do
  use Ecto.Migration

  def change do
    drop_if_exists index(:users, [:anonymous_id])
  end
end
