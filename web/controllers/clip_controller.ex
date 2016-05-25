defmodule Snowball.ClipController do
  use Snowball.Web, :controller

  alias Snowball.{Clip, Follow}

  plug Snowball.Plug.Authenticate when action in [:index, :delete]

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

  def delete(conn, %{"id" => id}) do
    clip = Repo.get!(Clip, id)
    if clip.user_id == conn.assigns.current_user.id do
      # TODO: When deleting clip, ensure that file is removed from S3
      Repo.delete!(clip)
      render(conn, "show.json", clip: clip)
    else
      # TODO: Render more appropriate error
      conn
      |> put_status(:unauthorized)
      |> render(Snowball.ErrorView, "error-auth-required.json", %{})
    end
  end
end
