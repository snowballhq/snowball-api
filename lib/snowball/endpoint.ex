defmodule Snowball.Endpoint do
  use Phoenix.Endpoint, otp_app: :snowball

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.Head

  plug Snowball.Router
end
