defmodule Snowball.HomeController do
  use Snowball.Controller

  def index(conn, _params) do
    # render conn, "index.text"
    render(conn, text: "⛄")
  end
end
