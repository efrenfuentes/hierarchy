defmodule Hierarchy.MixProject do
  use Mix.Project

  def project do
    [
      app: :hierarchy,
      version: "0.1.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: application(Mix.env())]
  end

  defp application(:test), do: [:postgrex, :ecto, :logger]
  defp application(_), do: [:logger]

  defp description do
    "Hierarchy structure for ecto models with PostgreSQL LTree."
  end

  defp elixirc_paths(:test), do: elixirc_paths() ++ ["test/for_testing", "test/support"]
  defp elixirc_paths(_), do: elixirc_paths()
  defp elixirc_paths, do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.12"},
      {:ecto_sql, "~> 3.12"},
      {:postgrex, ">= 0.20.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
