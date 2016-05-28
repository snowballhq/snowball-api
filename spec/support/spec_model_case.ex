defmodule Snowball.SpecModelCase do
  defmacro __using__(_opts) do
    quote do
      use Snowball.SpecCase

      import Snowball.SpecModelCase
    end
  end

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
