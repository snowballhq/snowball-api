defmodule Snowball.DeviceControllerTest do
  use Snowball.ConnCase, async: true

  test_authentication_required_for(:put, :device_path, :create, generic_uuid)

  test "create/2 creates a device for the specified user", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> put(device_path(conn, :create, user), token: "token")
    assert json_response(conn, 201) == user_response(user)
  end

  test "create/2 does create a duplicate devices", %{conn: conn} do
    user = insert(:user)
    device = insert(:device)
    conn = conn
    |> authenticate(user.auth_token)
    |> put(device_path(conn, :create, user), token: device.arn)
    assert json_response(conn, 201) == user_response(user)
    assert Repo.one(from d in Device, select: count(d.id)) == 1
  end

  test "create/2 with invalid params does not create a device and returns an error", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> authenticate(user.auth_token)
    |> put(device_path(conn, :create, user), token: "")
    assert json_response(conn, 422) == error_changeset_response(:arn, "can't be blank")
  end
end
