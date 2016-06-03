defmodule Snowball.HomeController do
  use Snowball.Web, :controller

  def index(conn, _params) do
    render conn, "index.text"
  end
end
