%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. kwi 2018 13:20
%%%-------------------------------------------------------------------
-module(pollution).
-author("Ludwik Ciechański").
-record(monitor, {byName, byCords, stations, n = 0}).
-record(station, {id, name, cords, measures}).
-record(measure, {date, type, value}).

-export([
  createMonitor/0, addStation/3, addValue/5, removeValue/4,
  getOneValue/4, getStationMean/3, getDailyMean/3
]).
%%%-------------------------------------------------------------------

createMonitor() -> #monitor{byName = #{}, byCords = #{}, stations = #{}}.
%%%-------------------------------------------------------------------

addStation(Name, Cords, Monitor) ->
  N = maps:is_key(Name, Monitor#monitor.byName),
  C = maps:is_key(Cords, Monitor#monitor.byCords),
  addStation(not N and not C, Name, Cords, Monitor).

addStation(true, Name, Cords, Monitor) ->
  Sid = Monitor#monitor.n,
  NewStation = #station{id = Sid, name = Name, cords = Cords, measures = []},
  Monitor#monitor{
    byName = maps:put(Name, Sid, Monitor#monitor.byName),
    byCords = maps:put(Cords, Sid, Monitor#monitor.byCords),
    stations = maps:put(Sid, NewStation, Monitor#monitor.stations),
    n = Sid + 1
  };
addStation(false, _, _, _) -> {error, "Station already exists!"}.
%%%-------------------------------------------------------------------

addValue(Station, Date, Type, Value, Monitor) ->
  StationToUpdate = getStation(Station, Monitor),
  N = getMeasure(StationToUpdate, Date, Type),
  addValue(N, StationToUpdate, Date, Type, Value, Monitor).

addValue([], Station, Date, Type, Value, Monitor) ->
  Sid = getSid(Station, Monitor),
  NewMeasure = #measure{date = Date, type = Type, value = Value},
  OldMeasures = Station#station.measures,
  UpdatedStation = Station#station{
    measures = [NewMeasure] ++ OldMeasures
  },
  Monitor#monitor{
    stations = maps:put(Sid, UpdatedStation, Monitor#monitor.stations)
  };
addValue(_, _, _, _, _, _) -> {error, "Such measure already exists!"}.
%%%-------------------------------------------------------------------

removeValue(Station, Date, Type, Monitor) -> []. %% TODO

getOneValue(Station, Date, Type, Monitor) -> []. %% TODO

getStationMean(Station, Type, Monitor) -> []. %% TODO

getDailyMean(Type, Date, Monitor) -> []. %% TODO
%%%-------------------------------------------------------------------

getSid({_, _} = Key, Monitor) -> maps:get(Key, Monitor#monitor.byCords);
getSid(_ = Key, Monitor) -> maps:get(Key, Monitor#monitor.byName).

getStation(Key, Monitor) -> maps:get(getSid(Key, Monitor), Monitor#monitor.stations).

checkTimeAndType(Measure, Date, Type) ->
  (Measure#measure.date =:= Date) and (Measure#measure.type =:= Type).

getMeasure(Station, Date, Type) ->
  [M || M <- Station#station.measures, checkTimeAndType(M, Date, Type)].