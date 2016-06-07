alias Plug.Anonymous

defmodule SomeApp do
  defmodule User do
    use Ecto.Schema
    import Ecto.Changeset
    schema "users" do
      # field :email, :string
      field :username, :string
      # field :hashed_password, :string
      timestamps
    end

    def changeset(user, params \\ :empty) do
      user
      |> cast(params, ~w(username), [])
    end
  end

  defmodule SomeController do
    use Plug.Builder
    plug Plug.Session,
      store: :cookie,
      key: "_wankrank_key",
      signing_salt: "cmwAUEpB",
      max_age: 86400
    plug :fetch_session
    plug Anonymous, %{user_model: User, repo: Wankrank.Repo}
  end
end


