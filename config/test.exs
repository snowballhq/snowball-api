use Mix.Config

config :logger, level: :warn

config :snowball, Snowball.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "snowball_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :comeonin, bcrypt_log_rounds: 4
