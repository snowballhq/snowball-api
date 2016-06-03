defmodule Snowball.Web do
  def model do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query

      @primary_key {:id, :binary_id, read_after_writes: true}
      @foreign_key_type :binary_id
      @timestamps_opts [inserted_at: :created_at]
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      import Ecto.Query
      import Snowball.Router.Helpers

      alias Snowball.Repo
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
