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

  def head(conn, status \\ 200) do
    render(conn, text: "", status: status)
  end

  def render(conn, opts) do
    body = cond do
      opts[:json] ->
        conn = conn |> put_resp_header("content-type", "application/json; charset=utf-8")
        body = opts[:json] |> Poison.encode!
      opts[:text] ->
        conn = conn |> put_resp_header("content-type", "text/plain; charset=utf-8")
        body = opts[:text]
      true -> conn
    end
    status = opts[:status] || 200
    conn |> send_resp(status, body)
  end
end
