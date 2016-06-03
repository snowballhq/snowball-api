defmodule Snowball.Controller do
  import Plug.Conn

  defmacro __using__(_opts) do
    quote do
      import Plug.Conn
      import Ecto.Query
      import Snowball.Controller

      alias Snowball.Repo
    end
  end

  def head(conn, status) do
    render(conn, text: "")
  end

  def render(conn, [text: text]) do
    conn
    |> put_resp_header("content-type", "text/plain; charset=utf-8")
    |> send_resp(200, text)
  end
end
