defmodule Snowball.Enum do
  def keyword_keys_to_strings(keyword_list) do
    Enum.map(keyword_list, fn(keyword) ->
      key = elem(keyword, 0)
      if is_atom(key) do
        {Atom.to_string(key), elem(keyword, 1)}
      else
        keyword
      end
    end)
  end
end
