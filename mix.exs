defmodule Snowball.Mixfile do
  use Mix.Project

  def project do
    [app: :snowball,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  def application do
    [mod: {Snowball, []},
     applications: applications(Mix.env)]
  end

  defp applications(:dev), do: [:dotenv | applications]
  defp applications(:test), do: [:dotenv | applications]
  defp applications(_), do: applications
  defp applications, do: [:phoenix, :cowboy, :logger, :phoenix_ecto, :postgrex, :comeonin, :ex_aws, :httpoison, :sweet_xml]

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 1.2.0-rc"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 3.0-rc"},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 2.4"},
     {:secure_random, "~> 0.2"},
     {:dotenv, "~> 2.0.0"},
     {:ex_aws, github: "jamescmartinez/ex_aws"},
     {:httpoison, "~> 0.8.0"},
     {:sweet_xml, "~> 0.6.1"},
     {:ex_phone_number, github: "socialpaymentsbv/ex_phone_number", branch: :develop},
     {:credo, "~> 0.3", only: [:dev, :test]},
     {:ex_machina, "~> 1.0.0-beta.1", github: "thoughtbot/ex_machina", only: :test},
     {:faker, "~> 0.5", only: :test}]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
