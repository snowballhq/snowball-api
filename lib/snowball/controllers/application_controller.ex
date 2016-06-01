defmodule Snowball.ApplicationController do
  defmacro __using__(_opts) do
    quote do
      import Plug.Conn
      import Ecto.Query

      alias Snowball.Repo
    end
  end
end
