defmodule Snowball.ClipController do
  use Snowball.Web, :controller

  alias Snowball.Clip

  plug Snowball.Plug.Authenticate when action in [:index]

  def index(conn, _params) do
    clips = Repo.all(Clip)
    render(conn, "index.json", clips: clips)
  end
end
