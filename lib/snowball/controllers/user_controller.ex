defmodule Snowball.UserController do
  use Snowball.ApplicationController

  def index(conn) do
    send_resp(conn, 200, "users")
  end
end
