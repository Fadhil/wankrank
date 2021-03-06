use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wankrank, Wankrank.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :wankrank, Wankrank.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("WANKRANK_DEV_PG_USERNAME"),
  password: System.get_env("WANKRANK_DEV_PG_PASSWORD"),
  database: "wankrank_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :wankrank, :http_client, Wankrank.HTTPTestClient
