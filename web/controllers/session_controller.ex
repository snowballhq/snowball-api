defmodule Snowball.SessionController do
  use Snowball.Web, :controller

  alias Snowball.User

  def create(conn, params) do
    user = Repo.get_by(User, email: params["email"])
    cond do
      user && Comeonin.Bcrypt.checkpw(params["password"], user.password_digest) ->
        conn
        |> assign(:current_user, user) # Log in user for correct response
        |> put_status(:created)
        |> render(Snowball.UserView, "show-auth.json", user: user)
      user ->
        conn
        |> put_status(:unauthorized)
        |> render(Snowball.ErrorView, "error.json", %{message: "Invalid password"})
      true ->
        conn
        |> put_status(:unauthorized)
        |> render(Snowball.ErrorView, "error.json", %{message: "Invalid email"})
    end
  end
end
