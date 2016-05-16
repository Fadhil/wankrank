defmodule Plug.AnonymousTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias SomeApp.User
  doctest Plug.Anonymous

  setup_all do
    Ecto.Adapters.SQL.begin_test_transaction(Wankrank.Repo)

    on_exit fn ->
      Ecto.Adapters.SQL.rollback_test_transaction(Wankrank.Repo)
    end
  end

  @default_opts [
    store: :cookie,
    key: "_test_key",
    encryption_salt: "encrypted salt",
    signing_salt: "signing salt",
    log: false
  ]

  @opts Plug.Session.init(@default_opts)

  @secret String.duplicate("abcdef0123456789", 8)

  def default_conn do
    conn(:get, "/") |> SomeApp.SomeController.call([])
  end

  def create_conn(conn, secret \\ @secret) do
    put_in(conn.secret_key_base, secret)
    |> Plug.Session.call(@opts)
    |> fetch_session
  end

  def create_user(params) do
    user_changeset = SomeApp.User.changeset(%SomeApp.User{}, params)

    Wankrank.Repo.insert(user_changeset)
  end

  test "assigns username session key" do
    conn = default_conn
    refute get_session(conn, "username") == nil
  end

  test "returns existing user session key" do
    assert {:ok, _user} = create_user(%{username: "SomeRandomUserName"})
    new_conn = create_conn(conn(:get, "/"))
    |> put_session("username", "SomeRandomUserName")
    |> Plug.Anonymous.call(%{user_model: SomeApp.User, repo: Wankrank.Repo })
    assert get_session(new_conn, "username") == "SomeRandomUserName"
  end

  test "creates a new user when no session user_id exists" do
    conn = default_conn
    refute Map.has_key?(conn, :current_user)
  end
end
