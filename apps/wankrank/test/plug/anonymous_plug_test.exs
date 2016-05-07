defmodule Plug.AnonymousTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Plug.Anonymous

  @default_opts [
    store: :cookie,
    key: "_test_key",
    encryption_salt: "encrypted salt",
    signing_salt: "signing salt",
    log: false
  ]

  @opts Plug.Session.init(@default_opts)

  @secret String.duplicate("abcdef0123456789", 8)

  def create_conn(conn, secret \\ @secret) do
    put_in(conn.secret_key_base, secret)
    |> Plug.Session.call(@opts)
    |> fetch_session
  end

  test "assigns user_id session key" do
    conn = conn(:get, "/") |> SomeApp.SomeController.call([])
		refute get_session(conn, "anonymous_id") == nil
  end

  test "returns existing user session key" do
      new_conn = create_conn(conn(:get, "/"))
      |> put_session("anonymous_id", "some_id")
      |> Plug.Anonymous.call([])
    assert get_session(new_conn, "anonymous_id") == "some_id"
  end
end
