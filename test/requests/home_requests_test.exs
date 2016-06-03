defmodule Snowball.HomeRequestsTest do
  use Snowball.ConnCase, async: true

  test "GET /" do
    conn = conn(:get, "/")
    assert conn |> response(200) == "⛄"
  end
end
