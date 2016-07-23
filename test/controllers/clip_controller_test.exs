defmodule Snowball.ClipControllerTest do
  use Snowball.ConnCase, async: true

  test_authentication_required_for(:get, :clip_path, :index)

  test "index/2 returns the main clip stream", %{conn: conn} do
    insert(:clip) # Random clip, random user, not following, should not exist in stream
    follow = insert(:follow)
    my_clip = insert(:clip, user: follow.follower)
    following_clip = insert(:clip, user: follow.followed, created_at: Ecto.DateTime.cast!("2014-04-17T14:00:00Z"))
    conn = conn
    |> authenticate(follow.follower.auth_token)
    |> get(clip_path(conn, :index))
    assert json_response(conn, 200) == [clip_response(my_clip, current_user: follow.follower), clip_response(following_clip, current_user: follow.follower)]
  end

  test "index/2 is paginated", %{conn: conn} do
    user = insert(:user)
    for _ <- 0..25, do: insert(:clip, user: user)
    conn = conn
    |> authenticate(user.auth_token)
    |> get(clip_path(conn, :index, page: 2))
    assert Enum.count(json_response(conn, 200)) == 1
  end

  test "index/2 with a user_id in url returns the specified user's clip stream", %{conn: conn} do
    insert(:clip) # Random clip, random user, should not exist in stream
    clip = insert(:clip)
    conn = conn
    |> authenticate(clip.user.auth_token)
    |> get(clip_path(conn, :index, user_id: clip.user_id))
    assert json_response(conn, 200) == [clip_response(clip, current_user: clip.user)]
  end

  test_authentication_required_for(:post, :clip_path, :create)

  # TODO: Bring this back
  # test "create/2 creates and returns the clip", %{conn: conn} do
  #   user = insert(:user)
  #   params = params_for(:new_clip)
  #   conn = conn
  #   |> authenticate(user.auth_token)
  #   |> post(clip_path(conn, :create), params)
  #   clip = Repo.one(from x in Clip, order_by: [desc: x.id], limit: 1) # Last clip
  #   assert json_response(conn, 201) == clip_response(clip, current_user: clip.user)
  #   assert User.likes?(clip.user, clip)
  # end

  test "create/2 with invalid params returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> post(clip_path(conn, :create))
    assert json_response(conn, 422) == error_changeset_response(:video, "can't be blank")
  end

  test_authentication_required_for(:delete, :clip_path, :delete, generic_uuid)

  test "delete/2 with valid params deletes the specified clip", %{conn: conn} do
    clip = insert(:clip)
    conn = conn
    |> authenticate(clip.user.auth_token)
    |> delete(clip_path(conn, :delete, clip))
    assert json_response(conn, 200) == clip_response(clip, current_user: clip.user)
    refute Snowball.Repo.get(Clip, clip.id)
  end

  test "delete/2 with valid params returns a 404 if the clip does not exist", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> delete(clip_path(conn, :delete, generic_uuid))
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
end
