defmodule Snowball.ModelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Snowball.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
      import Snowball.ModelCase
      import Snowball.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Snowball.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Snowball.Repo, {:shared, self()})
    end

    :ok
  end

  # TODO: Should this be extracted into its own module? Probably!
  def errors_on(struct, attribute, value \\ nil) do
    errors_on(struct, &struct.__struct__.changeset/2, attribute, value)
  end

  def errors_on(struct, changeset_function, attribute, value) do
    params = if value do
      %{attribute => value}
    else
      %{}
    end
    errors = changeset_function.(struct, params).errors
    |> Snowball.ChangesetErrorFormatter.reformat_errors
    if errors && errors[attribute] do
      errors[attribute]
    else
      []
    end
  end
end
