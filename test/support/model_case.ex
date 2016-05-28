defmodule Snowball.ModelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Snowball.TestCase

      import Snowball.ModelCase
      import Snowball.ModelCaseHelpers
    end
  end

  setup tags do
    Snowball.TestCase.setup(tags)

    :ok
  end
end

defmodule Snowball.ModelCaseHelpers do
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
