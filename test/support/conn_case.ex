defmodule Snowball.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Snowball.TestCase
      use Plug.Test

      import Snowball.ConnCase

      @endpoint Snowball.Endpoint
    end
  end

  setup tags do
    Snowball.TestCase.setup(tags)
    :ok
  end

  def response(conn, status) do
    conn = Snowball.Router.call(conn, Snowball.Router.init([]))
    assert conn.status == status
    assert conn.resp_body
    conn.resp_body
  end

  def json_response(conn, status) do
    response(conn, status) |> Poison.Parser.parse |> elem(1)
  end
end
