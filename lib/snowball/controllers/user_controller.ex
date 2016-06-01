defmodule Snowball.UserController do
  use Snowball.ApplicationController

  alias Snowball.User

  def index(conn) do
    users = User |> Repo.all |> User.to_json
    send_resp(conn, 200, users)
  end
end
