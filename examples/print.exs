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
