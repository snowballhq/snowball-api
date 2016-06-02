defmodule Snowball.ClipController do
  use Snowball.Controller

  alias Snowball.{Clip, Follow}

  # plug Snowball.Plug.Authenticate when action in [:index, :delete]

  def index(conn, params) do
    current_user = conn.assigns.current_user
    clips = if user_id = params["user_id"] do
      clips = Repo.all(
        Clip
        |> where([c], c.user_id == ^user_id)
        |> order_by([desc: :created_at])
        |> Snowball.Paginator.page(params["page"])
        |> preload(:user)
      )
      clips |> Clip.set_user_following(Snowball.User.following?(current_user, List.first(clips).user))
    else
      user_ids = Follow
      |> where([f], f.follower_id == ^current_user.id)
      |> select([f], f.followed_id)
      |> Repo.all

      Clip
      |> where([c], c.user_id in ^(user_ids ++ [current_user.id]))
      |> order_by([desc: :created_at])
      |> Snowball.Paginator.page(params["page"])
      |> preload(:user)
      |> Repo.all
      |> Clip.set_user_following(true)
    end
    # render(conn, "index.json", clips: clips)
    head(conn, 200)
  end

  def delete(conn, %{"id" => id}) do
    clip = Clip
    |> where([c], c.id == ^id)
    |> preload(:user)
    |> Repo.one
    cond do
      clip == nil ->
        conn
        |> put_status(:not_found)
        # render error
        |> head(404)
      clip.user_id == conn.assigns.current_user.id ->
        Repo.delete!(clip)
        # render(conn, "show.json", clip: clip |> Clip.set_user_following(false))
        head(conn, 200)
      true ->
        conn
        |> put_status(:unauthorized)
        # render some error
        |> head(401)
    end
  end
end
