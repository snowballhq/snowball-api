defmodule Snowball.UserController do
  import Plug.Conn

  def index(conn) do
    send_resp(conn, 200, "users")
  end
end
