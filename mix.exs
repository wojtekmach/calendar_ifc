defmodule Calendar.IFC.Mixfile do
  use Mix.Project

  def project do
    [app: :calendar_ifc,
     version: "0.0.1",
     description: "Elixir application to work with International Fixed Calendar",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end
end
