defmodule Wankrank.Repo.Migrations.AddDefaultValueToWanksInVideo do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      modify :wanks, :integer, default: 0
    end
  end
end
