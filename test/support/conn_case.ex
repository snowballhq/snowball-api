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

  def generic_uuid, do: "696c7ceb-c8ec-4f2b-a16a-21c822c9e984"

  def text_response(conn, status) do
    response(conn, status, "text/plain")
  end

  def json_response(conn, status) do
    response(conn, status, "application/json") |> Poison.Parser.parse!(keys: :atoms)
  end

  def head_response(conn, status) do
    body = response(conn, status)
    assert String.length(body) == 0
    body
  end

  defp response(conn, status, content_type \\ nil) do
    conn = Snowball.Router.call(conn, Snowball.Router.init([]))
    assert conn.status == status
    if content_type, do: assert {"content-type", "#{content_type}; charset=utf-8"} in conn.resp_headers
    assert conn.resp_body
    conn.resp_body
  end
end
