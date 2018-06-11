defmodule PollutionData do
  @moduledoc false

  def importLinesFromCSV do
    list = File.read!("pollution.csv") |> String.split()
    #length(list)
  end

  def parseOneLine(line) do
    [date, hour, longitude, latitude, value] = String.split(line, ",")
    date = date |> String.split("-") |> Enum.reverse |> Enum.map(fn(x) -> elem(Integer.parse(x), 0) end) |> :erlang.list_to_tuple
    hour = hour |> String.split(":") |> Enum.map(fn(x) -> elem(Integer.parse(x), 0) end) |> :erlang.list_to_tuple
    longitude = elem(Float.parse(longitude), 0)
    latitude = elem(Float.parse(latitude), 0)
    value = elem(Integer.parse(value), 0)
    %{:datetime => {date, hour}, :location => {longitude, latitude}, :pollutionLevel => value}
  end

  def identifyStations do

  end

  def addStations do

  end

  def addValues do

  end

  def test do
    [h | t] = importLinesFromCSV()
    parseOneLine(h)
  end

end
