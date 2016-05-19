defmodule Snowball.ChangesetView do
  use Snowball.Web, :view

  def render("error.json", %{changeset: changeset}) do
    errors = Enum.map(changeset.errors, fn {field, detail} ->
      %{
        source: %{pointer: "/data/attributes/#{field}"},
        title: "Invalid Attribute",
        detail: render_detail(detail)
      }
    end)

    %{errors: errors}
  end

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  defp render_detail(message) do
    message
  end
end
