defmodule ExChargebee.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_chargebee,
      name: "ex_chargebee",
      description: "Elixir implementation of Chargebee API (WIP)",
      organization: "sevenmind",
      package: %{
        licenses: ["MIT"],
        links: %{
          github: "https://github.com/sevenmind/ex_chargebee"
        }
      },
      source_url: "https://github.com/sevenmind/ex_chargebee",
      homepage_url: "https://github.com/sevenmind/ex_chargebee",
      version: "0.3.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:inflex, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:httpoison, "~> 1.7"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:mox, "~>1.0", only: [:test]},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:ex_check, "~> 0.14", only: [:dev], runtime: false}
    ]
  end
end
