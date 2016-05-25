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

  def errors_on(struct, data) do
    errors_on(struct, &struct.__struct__.changeset/2, data)
  end

  def errors_on(struct, changeset_function, data) do
    changeset_function.(struct, data).errors
    |> Enum.map(fn {field, {message, opts}} ->
      message = message
      |> replace_opts(opts)
      {field, message}
    end)
  end

  defp replace_opts(message, opts) do
    key = opts
    |> Keyword.keys
    |> List.first
    value = opts[key]
    message
    |> String.replace("%{#{key}}", to_string(value))
  end
end
