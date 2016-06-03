defmodule Snowball.ChangesetErrorsHelper do
  def json(changeset) do
    changeset.errors
    |> reformat_errors
    |> json_for_errors
  end

  def json_for_error(error) do
    key = error |> Keyword.keys |> List.first
    errors = [{Atom.to_string(key), Keyword.get_values(error, key)}] |> Enum.into(%{})
    json_for_errors(errors)
  end

  defp json_for_errors(errors) do
    errors = errors
    |> Map.keys
    |> Enum.map(fn(key) ->
      %{field: key, message: List.first(errors[key])}
    end)
    %{
      message: "Validation failed",
      errors: errors
    }
  end

  def reformat_errors(errors) do
    keys = errors
    |> Keyword.new
    |> Keyword.keys

    formatted_errors = keys
    |> Enum.map(fn(key) ->
      values = errors
      |> Keyword.get_values(key)
      |> Enum.map(fn({message, opts}) ->
        message |> replace_message_opts(opts)
      end)
      {key, values}
    end)

    formatted_errors |> Enum.into(%{})
  end

  defp replace_message_opts(message, opts) do
    key = opts
    |> Keyword.keys
    |> List.first
    value = opts[key]
    message = message |> String.replace("%{#{key}}", to_string(value))
    if value == 1 do
      message |> String.replace("(s)", "")
    else
      message |> String.replace("(s)", "s")
    end
  end
end
