defmodule Snowball.ApplicationController do
  defmacro __using__(_opts) do
    quote do
      import Plug.Conn
    end
  end
end
