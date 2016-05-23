defmodule Snowball.ErrorView do
  use Snowball.Web, :view

  def render("404.json", _assigns) do
    %{message: "Page not found"}
  end

  def render("500.json", _assigns) do
    %{message: "Server internal error"}
  end

  def render("error-auth-required.json", _assigns) do
    %{message: "Authentication required"}
  end

  def render("error-auth-email.json", _assigns) do
    %{message: "Invalid email"}
  end

  def render("error-auth-password.json", _assigns) do
    %{message: "Invalid password"}
  end

  def render("error-changeset.json", %{changeset: changeset}) do
    errors = Enum.map(changeset.errors, fn {field, detail} ->
      %{
        field: field,
        message: render_detail(detail)
      }
    end)

    %{
      message: "Validation Failed",
      errors: errors
    }
  end

  defp render_detail({message, values}) do
    Enum.reduce(values, message, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  defp render_detail(message) do
    message
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
