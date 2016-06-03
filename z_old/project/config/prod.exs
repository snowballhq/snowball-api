use Mix.Config

config :snowball, Snowball.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "localhost", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

config :logger, level: :info

config :snowball, Snowball.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 10,
  ssl: true
