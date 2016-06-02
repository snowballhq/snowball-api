use Mix.Config

config :logger, level: :info

config :snowball, Snowball.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 10,
  ssl: true
