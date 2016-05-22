defmodule Snowball.Plug.Authenticate do
  import Plug.Conn
  import Phoenix.Controller

  alias Snowball.{Repo, User}

  def init(default), do: default

  def call(conn, _default) do
    auth_header = get_req_header(conn, "authorization")
    if user = auth_header |> user_for_credentials do
      conn |> assign(:current_user, user)
    else
      conn
      |> put_status(:unauthorized)
      # TODO: Maybe this should not send a view back
      |> render(Snowball.AuthenticateView, "authenticate.json", %{})
      |> halt
    end
  end

  defp user_for_credentials(["Basic " <> encoded_auth_token]) do
    auth_token = Base.decode64!(encoded_auth_token) |> String.split(":") |> List.first
    Repo.get_by(User, %{auth_token: auth_token})
  end

  # Handle scenarios where there are no basic auth credentials supplied
  defp user_for_credentials(_credentials) do
    nil
  end
end
