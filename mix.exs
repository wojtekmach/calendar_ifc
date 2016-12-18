defmodule CalendarIFC.Mixfile do
  use Mix.Project

  def project do
    [app: :calendar_ifc,
     version: "0.1.0",
     description: "Elixir application to work with the International Fixed Calendar.",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     docs: [extras: ["README.md"], main: "readme"],
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev}]
  end
end
