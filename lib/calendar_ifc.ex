defmodule Calendar.IFC do
  @moduledoc ~S"""
  Calendar.IFC is a library to work with the International Fixed Calendar.

  International Fixed Calendar, or IFC, splits the calendar year into
  13 months, each having exactly 28 days.

  See: https://en.wikipedia.org/wiki/International_Fixed_Calendar.
  """

  @doc ~S"""
  Parses a given date into `Date` struct.

  ## Examples

      iex> Calendar.IFC.parse!({2016, 1, 1})
      %Date{calendar: Calendar.IFC, year: 2016, month: 1, day: 1}
  """
  def parse!({year, month, day} = date) do
    if day < 0 || day > 13 do
      raise ArgumentError, "invalid date: #{inspect(date)}"
    end

    %Date{calendar: __MODULE__, year: year, month: month, day: day}
  end

  @doc ~S"""
  Returns day of the week for a given date.
  Note, in IFC the same day of the year always falls
  onto the same day of the week, regardless of the month or the year.

  ## Examples

      iex> Calendar.IFC.day_of_week({2016, 1, 1})
      :sunday

      iex> Calendar.IFC.day_of_week({2016, 1, 13})
      :friday

      iex> Calendar.IFC.day_of_week({2016, 2, 13})
      :friday
  """
  def day_of_week(%Date{calendar: Calendar.IFC, day: day}) do
    [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]
    |> Enum.at(rem(day, 7) - 1)
  end
  def day_of_week({_year, _month, _day} = date) do
    parse!(date) |> day_of_week
  end
end
