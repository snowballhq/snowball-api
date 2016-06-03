defmodule Snowball.ModelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Snowball.TestCase

      import Snowball.ModelCase
    end
  end

  setup tags do
    Snowball.TestCase.setup(tags)
    :ok
  end

  def errors_on(struct, attribute, value \\ nil) do
    errors_on(struct, &struct.__struct__.changeset/2, attribute, value)
  end

  def errors_on(struct, changeset_function, attribute, value, require_save \\ false) do
    params = if value do
      %{attribute => value}
    else
      %{}
    end
    errors = if require_save do
      Snowball.Repo.transaction(fn ->
        case Snowball.Repo.insert(changeset_function.(struct, params)) do
          {:ok, _struct} -> false
          {:error, changeset} ->
            errors = changeset.errors |> Snowball.ChangesetErrorFormatter.reformat_errors
            Snowball.Repo.rollback(errors)
        end
      end) |> elem(1)
    else
      changeset_function.(struct, params).errors
      |> Snowball.ChangesetErrorFormatter.reformat_errors
    end
    if errors && errors[attribute] do
      errors[attribute]
    else
      []
    end
  end
end
