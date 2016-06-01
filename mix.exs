defmodule Snowball.Mixfile do
  use Mix.Project

  def project do
    [app: :snowball,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [mod: {Snowball, []},
     applications: [:logger, :postgrex, :ecto, :cowboy, :plug]]
  end

  defp deps do
    [{:postgrex, ">= 0.0.0"},
     {:ecto, "~> 2.0.0-beta"},
     {:cowboy, "~> 1.0.4"},
     {:plug, "~> 1.1.5"},
     {:poison, "~> 2.0"}]
  end
end
