defmodule Ajedrez.MixProject do
  use Mix.Project

  def project do
    [
      app: :ajedrez,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :bunt]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bunt, "~> 0.2.0"},
      {:credo, "~> 0.9.0", only: [:dev, :test], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
