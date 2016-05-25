use Mix.Config

config :snowball, Snowball.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :snowball, Snowball.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "snowball_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
