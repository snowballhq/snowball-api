defmodule Snowball.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest

      alias Snowball.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Snowball.Router.Helpers
      import Snowball.Factory

      @endpoint Snowball.Endpoint

      # TODO: Should this go here?
      def authenticate(conn, auth_token) do
        header_content = "Basic " <> Base.encode64("#{auth_token}:")
        conn |> put_req_header("authorization", header_content)
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Snowball.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Snowball.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
