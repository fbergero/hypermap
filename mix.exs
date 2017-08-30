defmodule HyperMap.Mixfile do
  use Mix.Project

  def project do
    [
      app: :hypermap,
      version: "0.1.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "HyperMap",
      source_url: "https://github.com/fbergero/hypermap"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      # Development
      {:ex_doc, "> 0.0.0", only: :dev},
      {:credo, "> 0.0.0", only: :dev}
    ]
  end

  defp description() do
    "HyperMap is an Elixir library which provides a Map that can be accessed" <>
    " through different keys."
  end

  defp package() do
    [
      name: "hypermap",
      # These are the default files included in the package
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Federico Bergero"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/fbergero/hypermap"}
    ]
  end
end
