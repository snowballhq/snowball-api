defmodule Snowball.ChangesetErrorFormatter do
  # TODO: Clean up this file when not sleepy :(

  def reformat_errors(errors) do
    errors
    |> get_keys_for_errors
    |> get_messages_for_keys(errors)
    |> Enum.into(%{})
  end

  defp get_keys_for_errors(errors) do
    errors
    |> Keyword.new
    |> Keyword.keys
  end

  defp get_messages_for_keys(keys, errors) do
    keys
    |> Enum.map(fn(key) ->
      values = errors
      |> Keyword.get_values(key)
      |> Enum.map(fn({message, opts}) ->
        message |> replace_message_opts(opts)
      end)
      {key, values}
    end)
  end

  defp replace_message_opts(message, opts) do
    key = opts
    |> Keyword.keys
    |> List.first
    value = opts[key]
    message = message |> String.replace("%{#{key}}", to_string(value))
    if value == 1 do
      message = message |> String.replace("(s)", "")
    else
      message = message |> String.replace("(s)", "s")
    end
  end
end
