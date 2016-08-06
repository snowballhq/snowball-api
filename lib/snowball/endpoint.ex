defmodule Snowball.Endpoint do
  use Phoenix.Endpoint, otp_app: :snowball

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison,
    read_timeout: 30_000

  plug Plug.Head

  plug Snowball.Router
end
