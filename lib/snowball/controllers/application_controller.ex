defmodule Snowball.ApplicationController do
  import Plug.Conn

  defmacro __using__(_opts) do
    quote do
      import Plug.Conn
      import Ecto.Query
      import Snowball.ApplicationController

      alias Snowball.Repo
    end
  end

  def render(conn, [text: text]) do
    conn
    |> put_resp_header("Content-Type", "text/plain; charset=utf-8")
    |> send_resp(200, text)
  end

  def render(conn, [json: json]) do
    conn
    |> put_resp_header("Content-Type", "application/json; charset=utf-8")
    |> send_resp(200, json)
  end

  def head(conn, status) do
    send_resp(conn, status, "")
  end
end
