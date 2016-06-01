defmodule Snowball.UserController do
  use Snowball.ApplicationController

  def index(conn) do
    result = Snowball.User |> Repo.all
    send_resp(conn, 200, result)
  end
end
