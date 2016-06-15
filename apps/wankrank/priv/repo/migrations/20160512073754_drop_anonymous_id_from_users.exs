defmodule Wankrank.Repo.Migrations.DropAnonymousIdFromUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      remove :anonymous_id
    end
  end

  def down do
    alter table(:users) do
      add :anonymous_id, :integer
    end
  end
end
