defmodule Snowball.Mixfile do
  use Mix.Project

  def project do
    [app: :snowball,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  def application do
    [mod: {Snowball, []},
     applications: [:logger, :postgrex, :ecto, :cowboy, :plug]]
  end

  defp elixirc_paths(:test), do: ["app", "lib", "test/support"]
  defp elixirc_paths(_), do: ["app", "lib"]

  defp deps do
    [{:postgrex, ">= 0.0.0"},
     {:ecto, "~> 2.0.0-beta"},
     {:cowboy, "~> 1.0.4"},
     {:plug, "~> 1.1.5"},
     {:poison, "~> 2.0"},
     {:credo, "~> 0.3", only: [:dev, :test]}]
  end

  defp aliases do
    ["server": "run --no-halt"]
  end
end
