defmodule Plug.Anonymous do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    anonymous_id = get_session(conn, "anonymous_id")
    case anonymous_id do
      nil -> put_session(conn, "anonymous_id", "Testing")
      _   -> conn
    end
  end
end
