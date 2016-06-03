defmodule Snowball.HomeController do
  use Snowball.Controller

  def index(conn) do
    render(conn, text: "⛄")
  end
end
