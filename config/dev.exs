use Mix.Config

config :snowball, Snowball.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "snowball_dev",
  hostname: "localhost",
  pool_size: 10
