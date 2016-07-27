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
    current_user = opts[:current_user]
    # TODO: This type of formatting shouldn't have to happen to remove microseconds. Fix?
    created_at = Ecto.DateTime.to_iso8601(clip.created_at) |> String.split(".") |> List.first
    %{
      "id" => clip.id,
      "user" => user_response(clip.user, opts),
      "image" => %{
        "standard_resolution" => %{
          "url" => Snowball.ClipVideo.url({clip.video, clip}, :image_standard)
        }
      },
      "video" => %{
        "standard_resolution" => %{
          "url" => Snowball.ClipVideo.url({clip.video, clip}, :standard)
        }
      },
      "liked" => Snowball.User.likes?(current_user, clip),
      "created_at" => created_at <> "Z"
    }
  end

  def user_response(user, opts \\ []) do
    current_user = opts[:current_user]
    json = %{
      "id" => user.id,
      "username" => user.username,
      "avatar_url" => nil,
      "following" => Snowball.User.following?(current_user, user)
    }
    if user.id == current_user.id do
      json = Map.merge(json, %{
        "phone_number" => user.phone_number,
        "email" => user.email
      })
    end
    json
  end

  def user_auth_response(user, opts \\ []) do
    opts = opts ++ [current_user: user]
    Map.merge(user_response(user, opts), %{
      "auth_token" => user.auth_token
    })
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
