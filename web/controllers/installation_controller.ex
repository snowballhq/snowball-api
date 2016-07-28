defmodule Snowball.InstallationController do
  use Snowball.Web, :controller

  alias Snowball.Installation

  plug Snowball.Plug.Authenticate when action in [:create]

  def create(conn, params) do
    user = conn.assigns.current_user
    if token = params["token"] do
      if arn = Snowball.PushNotificationService.register_installation_token(token) do
        if Installation |> where(arn: ^arn) |> Repo.one do
          conn
          |> put_status(:created)
          |> render(Snowball.UserView, "show.json", user: user)
        else
          changeset = Installation.changeset(%Installation{}, %{
            arn: arn,
            user_id: user.id
          })
          case Repo.insert(changeset) do
            {:ok, _installation} ->
              conn
              |> put_status(:created)
              |> render(Snowball.UserView, "show.json", user: user)
            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render(Snowball.ErrorView, "error.json", changeset: changeset)
          end
        end
      else
        conn
        |> put_status(:unprocessable_entity)
        |> render(Snowball.ErrorView, "error.json", message: "An error occured while registering the token.")
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Snowball.ErrorView, "error.json", message: "Token can't be blank.")
    end
  end
end
