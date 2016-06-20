defmodule :release_tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:wankrank)

    path = Application.app_dir(:wankrank, "/priv/repo/migrations")

    Ecto.Migrator.run(Wankrank.Repo, path, :up, all: true)

    :init.stop()
  end
end
