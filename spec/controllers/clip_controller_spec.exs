defmodule Snowball.ClipControllerSpec do
  use Snowball.SpecControllerCase

  describe "index/2" do
    it "returns the clip stream" do
      insert(:clip) # Random clip, random user, not following, should not exist in stream
      follow = insert(:follow)
      my_clip = insert(:clip, user: follow.follower)
      following_clip = insert(:clip, user: follow.following, created_at: Ecto.DateTime.cast!("2014-04-17T14:00:00Z"))
      conn = build_conn |> authenticate(follow.follower.auth_token)
      conn = conn |> get(clip_path(build_conn, :index))
      expect json_response(conn, 200) |> to(eq [clip_response(my_clip), clip_response(following_clip)])
    end

    it "returns the clip stream of a specific user when user_id is specified" do
      insert(:clip) # Random clip, random user, should not exist in stream
      clip = insert(:clip)
      conn = build_conn |> authenticate(clip.user.auth_token)
      conn = conn |> get(clip_path(conn, :index, user_id: clip.user_id))
      expect json_response(conn, 200) |> to(eq [clip_response(clip)])
    end

    it "requires authentication" do
      conn = build_conn
      conn = conn |> get(clip_path(conn, :index, user_id: ""))
      expect json_response(conn, 401) |> to(eq error_unauthorized_response)
    end
  end

  describe "delete/2" do
    it "deletes the specified clip when authorized" do
      clip = insert(:clip)
      conn = build_conn |> authenticate(clip.user.auth_token)
      conn = conn |> delete(clip_path(conn, :delete, clip))
      expect json_response(conn, 200) |> to(eq clip_response(clip))
      expect Snowball.Repo.get(Clip, clip.id) |> to(be_nil)
    end

    it "returns a 404 if the clip does not exist" do
      user = insert(:user)
      conn = build_conn |> authenticate(user.auth_token)
      conn = conn |> delete(clip_path(conn, :delete, "696c7ceb-c8ec-4f2b-a16a-21c822c9e984"))
      expect json_response(conn, 404) |> to(eq error_not_found_response())
    end

    it "returns a 401 when unauthorized" do
      user = insert(:user)
      clip = insert(:clip)
      conn = build_conn |> authenticate(user.auth_token)
      conn = conn |> delete(clip_path(conn, :delete, clip.id))
      expect json_response(conn, 401) |> to(eq error_unauthorized_response())
      expect Snowball.Repo.get(Clip, clip.id) |> to_not(be_nil)
    end

    it "requires authentication" do
      conn = build_conn
      conn = conn |> delete(clip_path(conn, :delete, "696c7ceb-c8ec-4f2b-a16a-21c822c9e984"))
      expect json_response(conn, 401) |> to(eq error_unauthorized_response)
    end
  end
end
