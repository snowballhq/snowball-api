defmodule Snowball.ClipController do
  use Snowball.Web, :controller

  alias Snowball.{Clip, Follow}

  plug Snowball.Plug.Authenticate when action in [:index]

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    # TODO: Optimize these queries into a single query
    user_ids = Repo.all(
      from follow in Follow,
      where: follow.follower_id == ^current_user.id,
      select: follow.following_id
    )
    user_ids = user_ids ++ [current_user.id]
    clips = Repo.all(
      from clip in Clip,
      where: clip.user_id in ^user_ids,
      order_by: [desc: clip.created_at]
    )
    render(conn, "index.json", clips: clips)
  end
end
