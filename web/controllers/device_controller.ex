defmodule Snowball.DeviceController do
  use Snowball.Web, :controller

  alias Snowball.Device

  plug Snowball.Plug.Authenticate when action in [:create]

  def create(conn, params) do
    user = conn.assigns.current_user
    if token = params["token"] do
      if arn = Snowball.SNS.register_device_token(token) do
        if Device |> where(arn: ^arn) |> Repo.one do
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
