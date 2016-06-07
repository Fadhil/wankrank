defmodule Wankrank.Repo.Migrations.AddCategoryToVideos do
  use Ecto.Migration
  def change do
    alter table(:videos) do
      add :category, :text # 'add' is add column
    end
  end
end
