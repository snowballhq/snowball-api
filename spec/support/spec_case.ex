defmodule Snowball.SpecCase do
  defmacro __using__(_opts) do
    quote do
      use ESpec, async: true

      import Snowball.Factory

      alias Snowball.{Clip, Follow, User}
    end
  end
end
