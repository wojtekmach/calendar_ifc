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
end
