defmodule Snowball.DeviceController do
  use Snowball.Controller

  alias Snowball.Device

  # plug Snowball.Plug.Authenticate when action in [:create]

  def create(conn, params) do
    user = conn.assigns.current_user

    # TODO: This needs to go to Amazon to get the ARN!
    arn = params["token"]

    if Device |> where(arn: ^arn) |> Repo.one do
      conn
      |> put_status(:created)
      # |> render(Snowball.UserView, "show.json", user: user)
      |> head(200)
    else
      changeset = Device.changeset(%Device{}, %{
        arn: arn,
        user_id: user.id
      })
      case Repo.insert(changeset) do
        {:ok, _device} ->
          conn
          |> put_status(:created)
          # |> render(Snowball.UserView, "show.json", user: user)
          |> head(200)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          # |> render(Snowball.ErrorView, "error.json", changeset: changeset)
          |> head(200)
      end
    end
  end
end
