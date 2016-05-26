defmodule Snowball.ErrorView do
  use Snowball.Web, :view

  def render("404.json", _assigns) do
    %{message: "Page not found"}
  end

  def render("500.json", _assigns) do
    %{message: "Server internal error"}
  end

  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end

  def render("error.json", assigns) do
    cond do
      assigns.message ->
        %{message: assigns.message}
      assigns.changeset ->
        render_changeset_errors(assigns.changeset)
      true ->
        render "500.json", assigns
    end
  end

  defp render_changeset_errors(%{changeset: changeset}) do
    errors = Enum.map(changeset.errors, fn {field, {message, values}} ->
      %{
        field: field,
        message:
          Enum.reduce(values, message, fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", to_string(value))
          end)
      }
    end)
    %{
      message: "Validation failed",
      errors: errors
    }
  end
end
