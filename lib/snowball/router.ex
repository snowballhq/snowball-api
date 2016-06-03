defmodule Snowball.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.RequestId
  plug Plug.Logger

  plug :match
  plug :dispatch

  get "/", do: Snowball.HomeController.index(conn)

  match _, do: Snowball.Controller.head(conn, 404)
  defp handle_errors(conn, _error), do: Snowball.Controller.head(conn, 500)
end
