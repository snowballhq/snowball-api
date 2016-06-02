defmodule Snowball.RegistrationController do
  use Snowball.Controller

  alias Snowball.User

  def create(conn, params) do
    changeset = User.changeset(%User{}, params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        # |> render(Snowball.UserView, "show-auth.json", user: user)
        |> head(200)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        # |> render(Snowball.ErrorView, "error.json", changeset: changeset)
        |> head(200)
    end
  end
end
