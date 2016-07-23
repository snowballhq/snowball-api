defmodule Snowball.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Snowball.TestCase
      use Phoenix.ConnTest

      import Snowball.ConnCase
      import Snowball.ConnCaseHelpers
      import Snowball.Router.Helpers

      @endpoint Snowball.Endpoint
    end
  end

  setup tags do
    Snowball.TestCase.setup(tags)

    {:ok, conn: Phoenix.ConnTest.build_conn}
  end
end

defmodule Snowball.ConnCaseHelpers do
  use Phoenix.ConnTest

  def generic_uuid do
    "696c7ceb-c8ec-4f2b-a16a-21c822c9e984"
  end

  def authenticate(conn, auth_token) do
    conn |> put_req_header("authorization", "Token token=#{auth_token}")
  end

  def clip_response(clip, opts \\ []) do
    %{
      "id" => clip.id,
      "user" => user_response(clip.user, opts),
      "thumbnail_url" => Snowball.ClipVideo.url({clip.video_file_name, clip}, :thumbnail),
      "video_url" => Snowball.ClipVideo.url({clip.video_file_name, clip}),
      "created_at" => clip.created_at |> Ecto.DateTime.to_iso8601
    }
  end

  def user_response(user, opts \\ []) do
    json = %{
      "id" => user.id,
      "username" => user.username,
      "avatar_url" => nil,
      "email" => user.email
    }
    if current_user = opts[:current_user] do
      json = Map.merge(json, %{
        "following" => Snowball.User.following?(current_user, user)
      })
      if user.id == current_user.id do
        json = Map.merge(json, %{
          "phone_number" => user.phone_number
        })
      end
    end
    if auth_token = opts[:auth_token] do
      json = Map.merge(json, %{
        "auth_token" => auth_token
      })
    end
    json
  end

  def error_changeset_response(field, message) do
    %{"message" => "Validation failed", "errors" => [%{"message" => message, "field" => Atom.to_string(field)}]}
  end

  def error_bad_request_response do
    %{"message" => "Bad request"}
  end

  def error_not_found_response do
    %{"message" => "Not found"}
  end

  def error_unauthorized_response do
    %{"message" => "Unauthorized"}
  end

  defmacro test_authentication_required_for(method, path_name, action, options \\ []) do
    quote do
      test "#{unquote(action)}/2 requires authentication", %{conn: conn} do
        conn = make_request(conn, @endpoint, unquote(method), unquote(path_name), unquote(action), unquote(options))
        assert conn |> json_response(401)
      end
    end
  end

  def make_request(conn, endpoint, method, path_name, action, options) do
    path = apply(Snowball.Router.Helpers, path_name, [conn, action, options])
    dispatch(conn, endpoint, method, path)
  end
end
