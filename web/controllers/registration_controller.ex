defmodule Snowball.RegistrationController do
  use Snowball.Web, :controller

  alias Snowball.User

  def create(conn, params) do
    changeset = User.changeset(%User{}, params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user) # Log in user for correct response
        |> put_status(:created)
        |> render(Snowball.UserView, "show-auth.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Snowball.ErrorView, "error.json", changeset: changeset)
    end
  end
end
