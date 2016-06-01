defmodule Snowball.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.RequestId
  plug Plug.Logger

  plug :match
  plug :dispatch

  get "/", do: Snowball.ApplicationController.render(conn, text: "⛄")
  get "/users", do: Snowball.UserController.index(conn)

  match _, do: Snowball.ApplicationController.head(conn, 404)
  defp handle_errors(conn, _error), do: Snowball.ApplicationController.head(conn, 500)
end
