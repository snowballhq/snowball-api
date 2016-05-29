defmodule Snowball.LikeControllerTest do
  use Snowball.ConnCase, async: true

  test_authentication_required_for(:put, :like_path, :create, generic_uuid)

  test "create/2 when not liked likes and returns the clip", %{conn: conn} do
    clip = insert(:clip)
    conn = conn
    |> authenticate(clip.user.auth_token)
    |> put(like_path(conn, :create, clip))
    assert json_response(conn, 201) == clip_response(clip)
    assert User.likes?(clip.user, clip)
  end

  test "create/2 when already liked returns the clip", %{conn: conn} do
    clip = insert(:clip)
    conn = conn
    |> authenticate(clip.user.auth_token)
    |> put(like_path(conn, :create, clip))
    assert json_response(conn, 201) == clip_response(clip)
    assert User.likes?(clip.user, clip)
  end

  test "create/2 when the clip does not exist returns an error", %{conn: conn} do
    clip = insert(:clip)
    conn = conn
    |> authenticate(clip.user.auth_token)
    |> put(like_path(conn, :create, generic_uuid))
    assert json_response(conn, 400) == error_bad_request_response
  end

  test_authentication_required_for(:delete, :like_path, :delete, generic_uuid)

  test "delete/2 when liked unlikes and returns the clip", %{conn: conn} do
    like = insert(:like)
    assert User.likes?(like.user, like.clip)
    conn = conn
    |> authenticate(like.user.auth_token)
    |> delete(like_path(conn, :delete, like.clip))
    assert json_response(conn, 200) == clip_response(like.clip)
    refute User.likes?(like.user, like.clip)
  end

  test "delete/2 when not liked returns the clip", %{conn: conn} do
    clip = insert(:clip)
    conn = conn
    |> authenticate(clip.user.auth_token)
    |> delete(like_path(conn, :delete, clip))
    assert json_response(conn, 200) == clip_response(clip)
    refute User.likes?(clip.user, clip)
  end

  test "delete/2 when the clip does not exist returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> delete(like_path(conn, :delete, generic_uuid))
    assert json_response(conn, 400) == error_bad_request_response
  end
end
