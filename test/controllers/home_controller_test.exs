defmodule Snowball.HomeControllerTest do
  use Snowball.ConnCase, async: true

  test "index/2", %{conn: conn} do
    conn = get conn, "/"
    assert text_response(conn, 200) =~ "⛄"
  end
end
