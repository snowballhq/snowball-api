defmodule Snowball.UserController do
  use Snowball.Web, :controller

  alias Snowball.User

  plug Snowball.Plug.Authenticate when action in [:show, :update]

  def show(conn, %{"id" => id}) do
    if user = Repo.get(User, id) do
      render(conn, "show.json", user: user)
    else
      conn
      |> put_status(:not_found)
      |> render(Snowball.ErrorView, "404.json")
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = conn.assigns.current_user
    if id == user.id do
      changeset = User.changeset(user, user_params)
      case Repo.update(changeset) do
        {:ok, user} ->
          render(conn, "show.json", user: user)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Snowball.ErrorView, "error.json", changeset: changeset)
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render(Snowball.ErrorView, "401.json")
    end
  end
end
