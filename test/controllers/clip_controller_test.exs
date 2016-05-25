defmodule Snowball.ClipControllerTest do
  use Snowball.ConnCase, async: true

  test "GET /clips/stream", %{conn: conn} do
    clip = insert(:clip)
    conn = conn |> authenticate(clip.user.auth_token)
    conn = get conn, clip_path(conn, :index)
    assert json_response(conn, 200) == [clip_response(clip)]
  end

  defp clip_response(clip) do
    %{"id" => clip.id}
  end
end
