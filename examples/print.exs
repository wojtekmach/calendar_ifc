# |     |  S  M  T  W  T  F  S |  S  M  T  W  T  F  S |  S  M  T  W  T  F  S |  S  M  T  W  T  F  S |    |
# | --- | -------------------- | -------------------- | -------------------- | -------------------- | -- |
# | Jan |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | Feb |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | Mar |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | Apr |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | May |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | Jun |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 | 29 |
# | Sol |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | Jul |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | Aug |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | Sep |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | Oct |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | Nov |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 |    |
# | Dec |  1  2  3  4  5  6  7 |  8  9 10 11 12 13 14 | 15 16 17 18 19 20 21 | 22 23 24 25 26 27 28 | 29 |
defmodule Print do
  import CalendarIFC, only: [month_name: 1, leap_year?: 1]

  def run(year) do
    sep = " |"
    weekdays   = "  S  M  T  W  T  F  S"
    weekdays_h = " --------------------"

    IO.puts ["|     |", weekdays,   sep, weekdays,   sep, weekdays,   sep, weekdays,   sep, "    |"]
    IO.puts ["| --- |", weekdays_h, sep, weekdays_h, sep, weekdays_h, sep, weekdays_h, sep, " -- |"]

    Enum.each(1..13, fn month ->
      IO.write ["| ", month_short_name(month), sep]

      Enum.each(1..28, fn day ->
        IO.write day_string(day)

        if day > 0 and rem(day, 7) == 0,
          do: IO.write sep
      end)

      cond do
        month == 13 ->
          " 29 |"
        month == 6 && leap_year?(year) ->
          " 29 |"
        true ->
          "    |"
      end
      |> IO.puts
    end)
  end

  defp month_short_name(month),
    do: month_name(month) |> String.slice(0, 3)
  defp day_string(day),
    do: String.rjust("#{day}", 3)
end

Print.run(2016)
