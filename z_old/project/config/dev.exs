use Mix.Config

config :snowball, Snowball.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :snowball, Snowball.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "snowball_dev",
  hostname: "localhost",
  pool_size: 10
