defmodule Snowball.TestCase do
  defmacro __using__(_opts) do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Snowball.Factory

      alias Snowball.{Clip, Follow, User}
      alias Snowball.Repo
    end
  end

  def setup(tags) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Snowball.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Snowball.Repo, {:shared, self()})
    end
  end
end
