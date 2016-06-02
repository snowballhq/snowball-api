defmodule Snowball.UserController do
  use Snowball.Controller

  alias Snowball.User

  # plug Snowball.Plug.Authenticate when action in [:show, :update]

  def show(conn, %{"id" => id}) do
    if user = Repo.get(User, id) do
      # render(conn, "show.json", user: user)
      render(conn, json: user)
    else
      conn
      |> put_status(:not_found)
      # |> render(Snowball.ErrorView, "404.json")
      |> head(404)
    end
  end

  def update(conn, params) do
    user = conn.assigns.current_user
    if params["id"] == user.id do
      changeset = User.changeset(user, params)
      case Repo.update(changeset) do
        {:ok, user} ->
          # render(conn, "show.json", user: user)
          head(conn, 200)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          # |> render(Snowball.ErrorView, "error.json", changeset: changeset)
          |> head(200)
      end
    else
      conn
      |> put_status(:unauthorized)
      # |> render(Snowball.ErrorView, "401.json")
      |> head(200)
    end
  end
end
