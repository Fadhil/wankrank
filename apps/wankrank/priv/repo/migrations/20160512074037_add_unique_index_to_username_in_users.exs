defmodule Wankrank.Repo.Migrations.AddUniqueIndexToUsernameInUsers do
  use Ecto.Migration

  def change do
    unique_index(:users, [:username])
  end
end
