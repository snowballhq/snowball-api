defmodule Snowball.DeviceControllerTest do
  use Snowball.ConnCase, async: true

  test_authentication_required_for(:put, :device_path, :create, generic_uuid)

  # Note:
  # These tests do work, but are commented out so that this does not run during test suite runs.
  # TODO: Mock Snowball.SNS so that this can be run in regular test runs

  # test "create/2 creates a device for the specified user", %{conn: conn} do
  #   user = insert(:user)
  #   token = "740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad"
  #   conn = conn
  #   |> authenticate(user.auth_token)
  #   |> put(device_path(conn, :create, user), token: token)
  #   assert json_response(conn, 201) == user_response(user, current_user: user)
  # end
  #
  # test "create/2 does not create a duplicate device", %{conn: conn} do
  #   user = insert(:user)
  #   insert(:device, arn: "arn:aws:sns:us-west-2:235811926729:endpoint/APNS/snowball-ios-production/514e2e2a-0990-36e7-bc0c-04548bf13572")
  #   token = "740f4707bebcf74f9b7c25d48e3358945f6aa01da5ddb387462c7eaf61bb78ad"
  #   conn = conn
  #   |> authenticate(user.auth_token)
  #   |> put(device_path(conn, :create, user), token: token)
  #   assert json_response(conn, 201) == user_response(user, current_user: user)
  #   assert Repo.one(from d in Device, select: count(d.id)) == 1
  # end
  #
  # test "create/2 with invalid params does not create a device and returns an error", %{conn: conn} do
  #   user = insert(:user)
  #   conn = conn
  #   |> authenticate(user.auth_token)
  #   |> put(device_path(conn, :create, user), token: "")
  #   assert json_response(conn, 422) == %{"message" => "An error occured while registering the token."}
  # end
end
