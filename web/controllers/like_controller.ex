defmodule Snowball.LikeController do
  use Snowball.Web, :controller

  alias Snowball.{Clip, User}

  plug Snowball.Plug.Authenticate when action in [:create, :delete]

  def create(conn, %{"clip_id" => id}) do
    user = conn.assigns.current_user
    if clip = Repo.get(Clip, id) do
      if User.like(user, clip) do
        conn
        |> put_status(:created)
        |> render(Snowball.ClipView, "show.json", clip: clip)
      else
        conn
        |> put_status(:bad_request)
        |> render(Snowball.ErrorView, "400.json")
      end
    else
      conn
      |> put_status(:bad_request)
      |> render(Snowball.ErrorView, "400.json")
    end
  end

  def delete(conn, %{"clip_id" => id}) do
    user = conn.assigns.current_user
    if clip = Repo.get(Clip, id) do
      if User.unlike(user, clip) do
        render(conn, Snowball.ClipView, "show.json", clip: clip)
      else
        conn
        |> put_status(:bad_request)
        |> render(Snowball.ErrorView, "400.json")
      end
    else
      conn
      |> put_status(:bad_request)
      |> render(Snowball.ErrorView, "400.json")
    end
  end
end
