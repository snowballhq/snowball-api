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

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end

defmodule Snowball.ConnCaseHelpers do
  use Phoenix.ConnTest

  def authenticate(conn, auth_token) do
    header_content = "Basic " <> Base.encode64("#{auth_token}:")
    conn |> put_req_header("authorization", header_content)
  end

  def clip_response(clip) do
    %{"id" => clip.id}
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
        path = apply(Snowball.Router.Helpers, unquote(path_name), [conn, unquote(action), unquote(options)])
        assert dispatch(conn, @endpoint, unquote(method), path) |> json_response(401)
      end
    end
  end
end
