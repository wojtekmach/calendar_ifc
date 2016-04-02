defmodule Calendar.IFC do
  @moduledoc ~S"""
  Calendar.IFC is a library to work with the International Fixed Calendar.

  International Fixed Calendar, or IFC, splits the calendar year into
  13 months, each having exactly 28 days.

  See: <https://en.wikipedia.org/wiki/International_Fixed_Calendar>.
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

  @doc ~S"""
  Returns a date in the IFC calendar from a `Date` in `Calendar.ISO`.
  Note, the returned date can be a:

  - `Date`
  - `:leap_day`
  - `:year_day`

  ## Examples

      iex> Calendar.IFC.from_iso({2016, 1, 1})
      %Date{calendar: Calendar.IFC, year: 2016, month: 1, day: 1}

      iex> Calendar.IFC.from_iso({2016, 1, 28})
      %Date{calendar: Calendar.IFC, year: 2016, month: 1, day: 28}

      iex> Calendar.IFC.from_iso({2016, 1, 29})
      %Date{calendar: Calendar.IFC, year: 2016, month: 2, day: 1}

      iex> Calendar.IFC.from_iso({2016, 3, 1})
      %Date{calendar: Calendar.IFC, year: 2016, month: 3, day: 5}

      iex> Calendar.IFC.from_iso({2015, 3, 1})
      %Date{calendar: Calendar.IFC, year: 2015, month: 3, day: 4}

      iex> Calendar.IFC.from_iso({2016, 6, 16})
      %Date{calendar: Calendar.IFC, year: 2016, month: 6, day: 28}

      iex> Calendar.IFC.from_iso({2016, 6, 17})
      {2016, :leap_day}

      iex> Calendar.IFC.from_iso({2015, 6, 17})
      %Date{calendar: Calendar.IFC, year: 2015, month: 6, day: 28}

      iex> Calendar.IFC.from_iso({2016, 6, 18})
      %Date{calendar: Calendar.IFC, year: 2016, month: 7, day: 1}

      iex> Calendar.IFC.from_iso({2016, 12, 30})
      %Date{calendar: Calendar.IFC, year: 2016, month: 13, day: 28}

      iex> Calendar.IFC.from_iso({2016, 12, 31})
      {2016, :year_day}

      iex> Calendar.IFC.from_iso({2015, 12, 31})
      {2015, :year_day}
  """
  def from_iso(%Date{calendar: Calendar.ISO, year: year, month: month, day: day}) do
    days =
      :calendar.date_to_gregorian_days({year, month, day}) -
      :calendar.date_to_gregorian_days({year, 1, 1})

    day = rem(days, 28) + 1
    month = div(days, 28) + 1
    is_leap_year = is_leap_year(year)
    new_year_offset = if is_leap_year, do: 1, else: 0
    day_offset = if is_leap_year && days > 6 * 28, do: 1, else: 0

    cond do
      days == 13 * 28 + new_year_offset ->
        {year, :year_day}
      is_leap_year && days == 13 * 28 ->
        %Date{calendar: Calendar.IFC, year: year, month: 13, day: 28}
      is_leap_year && days == 6 * 28 ->
        {year, :leap_day}
      true ->
        %Date{calendar: Calendar.IFC, year: year, month: month, day: day - day_offset}
    end
  end
  def from_iso({year, month, day}) do
    from_iso(%Date{calendar: Calendar.ISO, year: year, month: month, day: day})
  end

  defp is_leap_year(year) do
    rem(year, 4) == 0 && !(rem(year, 100) == 0 || rem(year, 400) == 0)
  end
end
