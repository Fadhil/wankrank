defmodule Wankrank.Repo do
  use Ecto.Repo, otp_app: :wankrank
  use Scrivener, page_size: 15
end
