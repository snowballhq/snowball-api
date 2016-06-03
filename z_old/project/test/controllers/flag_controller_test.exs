
defmodule Snowball.FlagControllerTest do
  use Snowball.ConnCase, async: true

  test_authentication_required_for(:put, :flag_path, :create, generic_uuid)

  test "create/2 flags the clip", %{conn: conn} do
    clip = insert(:clip)
    conn = conn
    |> authenticate(clip.user.auth_token)
    |> put(flag_path(conn, :create, clip))
    assert json_response(conn, 201) == clip_response(clip)
  end

  test "create/2 when the clip does not exist returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> put(flag_path(conn, :create, generic_uuid))
    assert json_response(conn, 400) == error_bad_request_response
  end
end
