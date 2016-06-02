defmodule Snowball.SessionController do
  use Snowball.Controller

  alias Snowball.User

  def create(conn, params) do
    user = Repo.get_by(User, email: params["email"])
    cond do
      user && Comeonin.Bcrypt.checkpw(params["password"], user.password_digest) ->
        conn
        |> put_status(:created)
        # |> render(Snowball.UserView, "show-auth.json", user: user)
        |> render(json: user)
      user ->
        conn
        |> put_status(:unauthorized)
        # |> render(Snowball.ErrorView, "error.json", %{message: "Invalid password"})
        |> head(200)
      true ->
        conn
        |> put_status(:unauthorized)
        # |> render(Snowball.ErrorView, "error.json", %{message: "Invalid email"})
        |> head(200)
    end
  end
end
