defmodule Snowball.UserController do
  use Snowball.BaseController

  alias Snowball.User

  def index(conn) do
    users = User |> Repo.all |> User.to_json
    render(conn, json: users)
  end
end
