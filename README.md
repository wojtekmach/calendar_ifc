# CalendarIFC

CalendarIFC is a library to work with the International Fixed Calendar.

See: <https://en.wikipedia.org/wiki/International_Fixed_Calendar>.

## Examples

```elixir
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
```

## Installation

  1. Add `calendar_ifc` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:calendar_ifc, github: "wojtekmach/calendar_ifc"}]
    end
    ```

  2. Ensure `calendar_ifc` is started before your application:

    ```elixir
    def application do
      [applications: [:calendar_ifc]]
    end
    ```

## License

The MIT License (MIT)

Copyright (c) 2016 Wojciech Mach

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
