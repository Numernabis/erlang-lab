defmodule PollutionData do
  @moduledoc false

  def importLinesFromCSV do
    list = File.read!("pollution.csv")
           |> String.split()
    #IO.puts "wczytano: #{length(list)} linii"
  end

  def parseOneLine(line) do
    [date, hour, longitude, latitude, value] = String.split(line, ",")
    date = date |> String.split("-")
           |> Enum.reverse
           |> Enum.map(fn(x) -> elem(Integer.parse(x), 0) end)
           |> :erlang.list_to_tuple
    hour = hour |> String.split(":")
           |> Enum.map(fn(x) -> elem(Integer.parse(x), 0) end)
           |> :erlang.list_to_tuple
           |> Tuple.append(0)

    longitude = elem(Float.parse(longitude), 0)
    latitude = elem(Float.parse(latitude), 0)
    value = elem(Integer.parse(value), 0)
    %{:datetime => {date, hour}, :location => {longitude, latitude}, :pollutionLevel => value}
  end

  def identifyStations do
    #map = parseLines() |> Enum.reduce(%{}, fn(d, acc) -> Map.put(acc, d.location, "xD") end)
    list = parseLines() |> Enum.uniq_by(fn (m) -> m.location end)
    #IO.puts "jest: #{length(list)} stacji"
  end

  def addStations do
    :pollution_server_supervisor.start()
    name = fn x -> "station_#{elem(x, 0)}_#{elem(x, 1)}" end
    st = identifyStations()
         |> Enum.map(fn (s) -> {name.(s.location), s.location} end)
         |> Enum.each(fn {n, c} -> :pollution_gen_server.addStation(n, c) end)
  end

  def addValues do
    vs = parseLines()
         |> Enum.map(fn (s) -> {s.location, s.datetime, :pm10, s.pollutionLevel} end)
         |> Enum.each(fn {n, d, t, v} -> :pollution_gen_server.addValue(n, d, t, v) end)
  end

  def parseLines do
    importLinesFromCSV() |> Enum.map(fn(x) -> parseOneLine(x) end)
  end

  def test do
    time_parsing = (fn() -> parseLines() end) |> :timer.tc |> elem(0)
    time_stations = (fn() -> addStations() end) |> :timer.tc |> elem(0)
    time_values = (fn() -> addValues() end) |> :timer.tc |> elem(0)
  end

end
