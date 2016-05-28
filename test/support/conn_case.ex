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
end
