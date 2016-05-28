defmodule Snowball.ClipControllerTest do
  use Snowball.ConnCase, async: true

  test "index/2 returns the main clip stream", %{conn: conn} do
    # TODO: Check pagination
    insert(:clip) # Random clip, random user, not following, should not exist in stream
    follow = insert(:follow)
    my_clip = insert(:clip, user: follow.follower)
    following_clip = insert(:clip, user: follow.following, created_at: Ecto.DateTime.cast!("2014-04-17T14:00:00Z"))
    conn = conn
    |> authenticate(follow.follower.auth_token)
    |> get(clip_path(conn, :index))
    assert json_response(conn, 200) == [clip_response(my_clip), clip_response(following_clip)]
  end

  test "index/2 with a user_id param returns the specified user's clip stream", %{conn: conn} do
    # TODO: Check pagination
    insert(:clip) # Random clip, random user, should not exist in stream
    clip = insert(:clip)
    conn = conn
    |> authenticate(clip.user.auth_token)
    |> get(clip_path(conn, :index, user_id: clip.user_id))
    assert json_response(conn, 200) == [clip_response(clip)]
  end

  test "index/2 requires authentication", %{conn: conn} do
    # TODO: Extract this into a shared test
    conn = conn
    |> delete(clip_path(conn, :index))
    assert json_response(conn, 401) == error_unauthorized_response
  end

  test "delete/2 with valid params deletes the specified clip", %{conn: conn} do
    clip = insert(:clip)
    conn = conn
    |> authenticate(clip.user.auth_token)
    |> delete(clip_path(conn, :delete, clip))
    assert json_response(conn, 200) == clip_response(clip)
    refute Snowball.Repo.get(Clip, clip.id)
  end

  test "delete/2 with valid params returns a 404 if the clip does not exist", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> delete(clip_path(conn, :delete, "696c7ceb-c8ec-4f2b-a16a-21c822c9e984"))
    assert json_response(conn, 404) == error_not_found_response
  end

  test "delete/2 returns a 401 if the current user does not own the clip", %{conn: conn} do
    user = insert(:user)
    clip = insert(:clip)
    conn = conn
    |> authenticate(user.auth_token)
    |> delete(clip_path(conn, :delete, clip.id))
    assert json_response(conn, 401) == error_unauthorized_response
    assert Snowball.Repo.get(Clip, clip.id)
  end

  test "delete/2 requires authentication", %{conn: conn} do
    # TODO: Extract this into a shared test
    conn = conn
    |> delete(clip_path(conn, :delete, "696c7ceb-c8ec-4f2b-a16a-21c822c9e984"))
    assert json_response(conn, 401) == error_unauthorized_response
  end
end
