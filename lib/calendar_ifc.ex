defmodule CalendarIFC do
  @behaviour Calendar

  @type day :: 1..29
  @type month :: 1..13
  @type year :: 0..9999

  @moduledoc ~S"""
  CalendarIFC is a library to work with the International Fixed Calendar.

  International Fixed Calendar (IFC) splits a solar year into
  13 months of 28 days each. Each month has exactly 4 weeks.

  There are two additional days that are not considered to be part of
  any week:

  - Year day - December 29th every year
  - Leap day - June 29th every leap year

  See: <https://en.wikipedia.org/wiki/International_Fixed_Calendar>.

  ## Examples

      iex> CalendarIFC.from_iso!(~D[2016-01-01])
      %Date{calendar: CalendarIFC, year: 2016, month: 1, day: 1}

      # in IFC, any given day of the month will always fall on the same week day.
      iex> CalendarIFC.day_of_week(2016, 1, 13)
      6
      iex> CalendarIFC.day_of_week(2016, 2, 13)
      6
      iex> CalendarIFC.day_of_week(2016, 3, 13)
      6

      iex> to_string CalendarIFC.next_day(2016, 1, 1)
      "2016-01-02"
      iex> to_string CalendarIFC.next_day(2016, 1, 28)
      "2016-02-01"

  """

  @doc ~S"""
  Builds and validates an IFC date.

  ## Examples

      iex> CalendarIFC.date(2000, 1, 1)
      {:ok, %Date{calendar: CalendarIFC, year: 2000, month: 1, day: 1}}

      iex> CalendarIFC.date(2000, 13, 28)
      {:ok, %Date{calendar: CalendarIFC, year: 2000, month: 13, day: 28}}

      iex> CalendarIFC.date(2000, 1, 29)
      {:error, :invalid_date}

  """
  @spec date(year, month, day) :: {:ok, Date.t} | {:error, :invalid_date}
  def date(year, month, day) when is_integer(year) and is_integer(month) and is_integer(day) do
    if valid_date?(year, month, day) do
      {:ok, %Date{calendar: __MODULE__, year: year, month: month, day: day}}
    else
      {:error, :invalid_date}
    end
  end

  defp date!(year, month, day) do
    case date(year, month, day) do
      {:ok, date} -> date
      {:error, :invalid_date} -> raise "Invalid date: #{year}, #{month}, #{day}"
    end
  end

  defp valid_date?(year, month, day) do
    cond do
      year <= 9999 and month in 1..13 and day in 1..28 -> true
      month == 13 and day == 29 -> true
      leap_year?(year) and month == 6 and day == 29 -> true
      true -> false
    end
  end

  @doc ~S"""
  Calculates the day of the week from the given year, month, and day.

  For week days, returns an integer from `1` to `7`, where `1` is Sunday, `2` is Monday, and `7` is Saturday.
  For non-week days, returns `8` for Leap Day (June 29th) and `9` for Year Day (December 29th)

  Note: in IFC, any given day of the month will always fall on the same
  week day.

  ## Examples

      iex> CalendarIFC.day_of_week(2016, 1, 1)
      1
      iex> CalendarIFC.day_of_week(2016, 1, 7)
      7
      iex> CalendarIFC.day_of_week(2016, 1, 11)
      4
      iex> CalendarIFC.day_of_week(2016, 2, 11)
      4
      iex> CalendarIFC.day_of_week(2016, 3, 11)
      4
      iex> CalendarIFC.day_of_week(2016, 6, 29)
      8
      iex> CalendarIFC.day_of_week(2016, 13, 29)
      9

  """
  @spec day_of_week(year, month, day) :: 1..9
  def day_of_week(_year, _month, day) when day in 1..28,
    do: Enum.at(1..7, rem(day, 7) - 1)
  def day_of_week(_year, 6, 29),
    do: 8
  def day_of_week(_year, 13, 29),
    do: 9

  @doc ~S"""
  Converts ISO date into IFC date.

  ## Examples

      iex> to_string CalendarIFC.from_iso!(~D[2016-01-01])
      "2016-01-01"
      iex> to_string CalendarIFC.from_iso!(~D[2016-01-29])
      "2016-02-01"

      iex> to_string CalendarIFC.from_iso!(~D[2016-06-17])
      "2016-06-29"
      iex> to_string CalendarIFC.from_iso!(~D[2016-06-18])
      "2016-07-01"
      iex> to_string CalendarIFC.from_iso!(~D[2017-06-17])
      "2017-06-28"
      iex> to_string CalendarIFC.from_iso!(~D[2017-06-18])
      "2017-07-01"

      iex> to_string CalendarIFC.from_iso!(~D[2017-12-31])
      "2017-13-29"
      iex> to_string CalendarIFC.from_iso!(~D[2018-01-01])
      "2018-01-01"

      iex> to_string CalendarIFC.from_iso!(~N[2017-12-31 00:00:00])
      "2017-13-29 00:00:00"

  """
  @spec from_iso!(Date.t) :: Date.t
  def from_iso!(%Date{calendar: Calendar.ISO, year: year, month: 12, day: 31}),
    do: %Date{calendar: CalendarIFC, year: year, month: 13, day: 29}
  def from_iso!(%Date{calendar: Calendar.ISO} = date),
    do: do_from_iso!(date)
  def from_iso!(%NaiveDateTime{calendar: Calendar.ISO} = iso_datetime) do
    ifc_date = NaiveDateTime.to_date(iso_datetime) |> from_iso!
    %{iso_datetime | calendar: CalendarIFC,
                     year: ifc_date.year,
                     month: ifc_date.month,
                     day: ifc_date.day}
  end

  defp do_from_iso!(%Date{calendar: Calendar.ISO, year: year, month: month, day: day}) do
    day_of_year = :calendar.date_to_gregorian_days({year, month, day}) -
                  :calendar.date_to_gregorian_days({year, 1, 1})
    leap_day_of_year = 6 * 28
    leap_day_offset = if leap_year?(year) && day_of_year > leap_day_of_year, do: -1, else: 0

    if leap_year?(year) && day_of_year == leap_day_of_year do
      %Date{calendar: CalendarIFC, year: year, month: 6, day: 29}
    else
      day = rem(day_of_year + leap_day_offset, 28) + 1
      month = div(day_of_year + leap_day_offset, 28) + 1
      %Date{calendar: CalendarIFC, year: year, month: month, day: day}
    end
  end

  @doc ~S"""
  ## Examples

      iex> CalendarIFC.leap_year?(2016)
      true
      iex> CalendarIFC.leap_year?(2017)
      false

  """
  @spec leap_year?(year) :: boolean
  defdelegate leap_year?(year), to: Calendar.ISO

  def leap_day?(_y,  6, 29), do: true
  def leap_day?(_y, _m, _d), do: false
  def leap_day?(%Date{calendar: CalendarIFC, year: y, month: m, day: d}),
    do: leap_day?(y, m, d)

  @doc ~S"""
  Returns the last day of the month for the given year.

  ## Examples

      iex> CalendarIFC.last_day_of_month(2016, 1)
      28
      iex> CalendarIFC.last_day_of_month(2016, 2)
      28
      iex> CalendarIFC.last_day_of_month(2016, 3)
      28
      iex> CalendarIFC.last_day_of_month(2016, 6)
      29
      iex> CalendarIFC.last_day_of_month(2017, 6)
      28
      iex> CalendarIFC.last_day_of_month(2018, 6)
      28
      iex> CalendarIFC.last_day_of_month(2016, 13)
      29

  """
  @spec last_day_of_month(year, month) :: day
  def last_day_of_month(_year, 13),
    do: 29
  def last_day_of_month(year, 6),
    do: if leap_year?(year), do: 29, else: 28
  def last_day_of_month(_year, _month),
    do: 28

  @doc ~S"""
  Returns next day for a given date.

  ## Examples

      iex> to_string CalendarIFC.next_day(2016, 1, 1)
      "2016-01-02"
      iex> to_string CalendarIFC.next_day(2016, 1, 28)
      "2016-02-01"
      iex> to_string CalendarIFC.next_day(2016, 6, 28)
      "2016-06-29"

      iex> to_string CalendarIFC.next_day(CalendarIFC.from_iso!(~D[2016-01-28]))
      "2016-02-01"
  """
  @spec next_day(year, month, day) :: Date.t
  @spec next_day(Date.t) :: Date.t
  def next_day(year, 13, 28),
    do: date!(year, 13, 29)
  def next_day(year, 13, 29),
    do: date!(year + 1, 1, 1)
  def next_day(year, 6, 28),
    do: if leap_year?(year), do: date!(year, 6, 29), else: date!(year, 7, 1)
  def next_day(year, 6, 29),
    do: date!(year, 7, 1)
  def next_day(year, month, 28),
    do: date!(year, month + 1, 1)
  def next_day(year, month, day),
    do: date!(year, month, day + 1)
  def next_day(%Date{calendar: CalendarIFC, year: year, month: month, day: day}),
    do: next_day(year, month, day)

  @doc ~S"""
  Returns previous day for a given date.

  ## Examples

      iex> to_string CalendarIFC.prev_day(2016, 1, 2)
      "2016-01-01"
      iex> to_string CalendarIFC.prev_day(2016, 1, 1)
      "2015-13-29"

  """
  @spec prev_day(year, month, day) :: Date.t
  @spec prev_day(Date.t) :: Date.t
  def prev_day(year, 1, 1),
    do: date!(year - 1, 13, 29)
  def prev_day(year, month, 28),
    do: date!(year, month + 1, 1)
  def prev_day(year, 7, 1),
    do: if leap_year?(year), do: date!(year, 6, 29), else: date!(year, 6, 28)
  def prev_day(year, month, 1),
    do: date!(year, month - 1, 28)
  def prev_day(year, month, day),
    do: date!(year, month, day - 1)
  def prev_day(%Date{calendar: CalendarIFC, year: year, month: month, day: day}),
    do: prev_day(year, month, day)

  @doc false
  defdelegate to_string(date), to: Calendar.ISO

  @month_names ~w(
    January
    February
    March
    April
    May
    June
    Sol
    July
    August
    September
    October
    November
    December)

  @doc ~S"""
  Returns name for the given month.

  ## Examples

      iex> CalendarIFC.month_name(1)
      "January"
      iex> CalendarIFC.month_name(7)
      "Sol"
      iex> CalendarIFC.month_name(8)
      "July"

  """
  @spec month_name(month) :: String.t
  def month_name(month) when month in 1..13 do
    Enum.at(@month_names, month - 1)
  end
end
