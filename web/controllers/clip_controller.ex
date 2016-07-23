defmodule Snowball.ClipController do
  use Snowball.Web, :controller

  alias Snowball.{Clip, Follow}

  plug Snowball.Plug.Authenticate when action in [:index, :create, :delete]

  def index(conn, params) do
    current_user = conn.assigns.current_user
    clips = if user_id = params["user_id"] do
      Repo.all(
        Clip
        |> where([c], c.user_id == ^user_id)
        |> order_by([desc: :created_at])
        |> Snowball.Paginator.page(params["page"])
        |> preload(:user)
      )
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
    end
    render(conn, "index.json", clips: clips)
  end

  def create(conn, params) do
    user = conn.assigns.current_user
    params = params
    |> Map.put("user_id", user.id)
    |> Map.put("video_content_type", "a") # TODO: Remove these three
    |> Map.put("thumbnail_file_name", "a")
    |> Map.put("thumbnail_content_type", "a")
    changeset = Clip.changeset(%Clip{}, params)
    case Repo.insert(changeset) do
      {:ok, clip} ->
        clip = clip |> Map.put(:user, user)
        conn
        |> put_status(:created)
        |> render("show.json", clip: clip)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Snowball.ErrorView, "error.json", changeset: changeset)
    end
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
