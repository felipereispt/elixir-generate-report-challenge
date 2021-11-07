defmodule GenReport do
  alias GenReport.Parser

  @names [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build(), do: {:error, "Insira o nome de um arquivo"}

  defp report_acc() do
    all_hours = Enum.into(@names, %{}, fn name -> {name, 0} end)
    months = Enum.into(@months, %{}, fn month -> {month, 0} end)
    years = Enum.into(2016..2020, %{}, fn year -> {year, 0} end)

    hours_per_month = Enum.into(@names, %{}, fn name -> {name, months} end)

    hours_per_year = Enum.into(@names, %{}, fn name -> {name, years} end)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp sum_values([name, hours, _day, month, year], %{
    "all_hours" => all_hours,
    "hours_per_month" => hours_per_month,
    "hours_per_year" => hours_per_year
  }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month = %{
    hours_per_month
    | name => Map.put(hours_per_month[name], month, hours_per_month[name][month] + hours)
    }

    hours_per_year = %{
    hours_per_year
    | name => Map.put(hours_per_year[name], year, hours_per_year[name][year] + hours)
    }

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
