defmodule Snowball.DeviceController do
  use Snowball.Web, :controller

  alias Snowball.Device

  plug Snowball.Plug.Authenticate when action in [:create]

  def create(conn, %{"device" => device_params}) do
    user = conn.assigns.current_user

    # TODO: This needs to go to Amazon to get the ARN!
    arn = device_params["token"]

    if device = Device |> where(arn: ^arn) |> Repo.one do
      conn
      |> put_status(:created)
      |> render(Snowball.UserView, "show.json", user: user)
    else
      changeset = Device.changeset(%Device{}, %{
        arn: arn,
        user_id: user.id
      })
      case Repo.insert(changeset) do
        {:ok, _device} ->
          conn
          |> put_status(:created)
          |> render(Snowball.UserView, "show.json", user: user)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Snowball.ErrorView, "error.json", changeset: changeset)
      end
    end
  end
end
