defmodule Snowball.UserController do
  use Snowball.Web, :controller

  alias Snowball.User

  plug Snowball.Plug.Authenticate when action in [:show, :update, :search]

  def show(conn, %{"id" => id}) do
    if user = Repo.get(User, id) do
      render(conn, "show.json", user: user)
    else
      conn
      |> put_status(:not_found)
      |> render(Snowball.ErrorView, "404.json")
    end
  end

  def update(conn, params) do
    user = conn.assigns.current_user
    if params["id"] == user.id do
      changeset = User.changeset(user, params)
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

  def search(conn, params) do
    phone_numbers = params["phone_numbers"]
    users = User |> where([u], u.phone_number in ^params["phone_numbers"]) |> Repo.all
    users = List.delete(users, conn.assigns.current_user)
    render(conn, "index.json", users: users)
  end
end
