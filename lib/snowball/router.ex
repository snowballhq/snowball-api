defmodule Snowball.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.RequestId
  plug Plug.Logger

  plug :match
  plug :dispatch

  get "/", do: Snowball.BaseController.render(conn, text: "⛄")
  get "/users", do: Snowball.UserController.index(conn)

  match _, do: Snowball.BaseController.head(conn, 404)
  defp handle_errors(conn, _error), do: Snowball.BaseController.head(conn, 500)
end
