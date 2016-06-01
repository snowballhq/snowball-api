defmodule Snowball.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug Plug.RequestId
  plug Plug.Logger

  plug :match
  plug :dispatch

  get "/", do: send_resp(conn, 200, "⛄")
  get "/users", do: Snowball.UserController.index(conn)

  match _, do: send_resp(conn, 404, "Oops")
  defp handle_errors(conn, _error), do: send_resp(conn, conn.status, "Something went wrong")
end
