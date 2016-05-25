defmodule Snowball.ClipControllerTest do
  use Snowball.ConnCase, async: true

  test "GET /clips/stream", %{conn: conn} do
    # TODO: Check pagination
    insert(:clip) # Random clip, random user, not following, should not exist in stream
    follow = insert(:follow)
    my_clip = insert(:clip, user: follow.follower)
    following_clip = insert(:clip, user: follow.following, created_at: Ecto.DateTime.cast!("2014-04-17T14:00:00Z"))
    conn = conn |> authenticate(follow.follower.auth_token)
    conn = get conn, clip_path(conn, :index)
    assert json_response(conn, 200) == [clip_response(my_clip), clip_response(following_clip)]
  end

  defp clip_response(clip) do
    %{"id" => clip.id}
  end
end
