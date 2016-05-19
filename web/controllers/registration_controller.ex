defmodule Snowball.RegistrationController do
  use Snowball.Web, :controller

  alias Snowball.User

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Snowball.UserView, "show-auth.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Snowball.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
