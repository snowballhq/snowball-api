use Mix.Config

config :snowball, Snowball.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "example.com", port: 443]

config :logger, level: :info

config :snowball, Snowball.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 10,
  ssl: true
