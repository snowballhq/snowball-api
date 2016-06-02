use Mix.Config

config :logger, :console, format: "[$level] $message\n"

config :snowball, Snowball.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "snowball_dev",
  hostname: "localhost",
  pool_size: 10
