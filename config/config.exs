use Mix.Config

config :snowball,
  ecto_repos: [Snowball.Repo]

config :snowball, Snowball.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  render_errors: [accepts: ~w(json)]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  sns: [
    host: {:system, "AWS_SNS_ENDPOINT"},
    region: {:system, "AWS_SNS_REGION"}
  ],
  s3: [
    region: {:system, "AWS_S3_REGION"}
  ]

config :arc,
  bucket: "snowball-development",
  virtual_host: true

import_config "#{Mix.env}.exs"
