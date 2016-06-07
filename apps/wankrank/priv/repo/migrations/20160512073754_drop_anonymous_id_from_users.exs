defmodule Wankrank.Repo.Migrations.DropAnonymousIdFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :anonymous_id
    end
  end
end
