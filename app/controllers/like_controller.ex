defmodule Snowball.LikeController do
  use Snowball.Controller

  alias Snowball.{Clip, User}

  # plug Snowball.Plug.Authenticate when action in [:create, :delete]

  def create(conn, %{"clip_id" => id}) do
    user = conn.assigns.current_user
    clip = Clip
    |> where([c], c.id == ^id)
    |> preload(:user)
    |> Repo.one
    if clip do
      if User.like(user, clip) do
        conn
        |> put_status(:created)
        # |> render(Snowball.ClipView, "show.json", clip: clip)
        |> head(200)
      else
        conn
        |> put_status(:bad_request)
        # |> render(Snowball.ErrorView, "400.json")
        |> head(200)
      end
    else
      conn
      |> put_status(:bad_request)
      # |> render(Snowball.ErrorView, "400.json")
      |> head(200)
    end
  end

  def delete(conn, %{"clip_id" => id}) do
    user = conn.assigns.current_user
    clip = Clip
    |> where([c], c.id == ^id)
    |> preload(:user)
    |> Repo.one
    if clip do
      if User.unlike(user, clip) do
        # render(conn, Snowball.ClipView, "show.json", clip: clip)
        head(conn, 200)
      else
        conn
        |> put_status(:bad_request)
        # |> render(Snowball.ErrorView, "400.json")
        |> head(200)
      end
    else
      conn
      |> put_status(:bad_request)
      # |> render(Snowball.ErrorView, "400.json")
      |> head(200)
    end
  end
end
