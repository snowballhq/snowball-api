defmodule Snowball.ClipController do
  use Snowball.Web, :controller

  alias Snowball.{Clip, Follow}

  plug Snowball.Plug.Authenticate when action in [:index, :delete]

  def index(conn, params) do
    page = params["page"]
    if page do
      page = String.to_integer(page)
    else
      page = 1
    end
    limit = 25
    offset = limit * page - limit
    current_user = conn.assigns.current_user
    clips = if user_id = params["user_id"] do
      Repo.all(
        from clip in Clip,
        where: clip.user_id == ^user_id,
        order_by: [desc: clip.created_at],
        limit: ^limit,
        offset: ^offset
      )
    else
      Repo.all(
        from clip in Clip,
        join: follow in Follow, on: clip.user_id == follow.following_id or clip.user_id == ^current_user.id,
        order_by: [desc: clip.created_at],
        limit: ^limit,
        offset: ^offset
      )
    end
    render(conn, "index.json", clips: clips)
  end

  def delete(conn, %{"id" => id}) do
    clip = Repo.get(Clip, id)
    cond do
      clip == nil ->
        conn
        |> put_status(:not_found)
        |> render(Snowball.ErrorView, "404.json", %{})
      clip.user_id == conn.assigns.current_user.id ->
        Repo.delete!(clip)
        render(conn, "show.json", clip: clip)
      true ->
        conn
        |> put_status(:unauthorized)
        |> render(Snowball.ErrorView, "401.json", %{})
    end
  end
end
