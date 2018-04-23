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
  getOneValue/4, getStationMean/3, getDailyMean/3,
  getMinimumDistanceStations/1
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
  M = getMeasure(StationToUpdate, Date, Type),
  addValue(M, StationToUpdate, Date, Type, Value, Monitor).

addValue([], Station, Date, Type, Value, Monitor) ->
  Sid = Station#station.id,
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

removeValue(Station, Date, Type, Monitor) ->
  StationToUpdate = getStation(Station, Monitor),
  MeasureToRemove = getMeasure(StationToUpdate, Date, Type),
  Sid = StationToUpdate#station.id,
  OldMeasures = StationToUpdate#station.measures,
  UpdatedStation = StationToUpdate#station{
    measures = OldMeasures -- MeasureToRemove
  },
  Monitor#monitor{
    stations = maps:put(Sid, UpdatedStation, Monitor#monitor.stations)
  }.
%%%-------------------------------------------------------------------

getOneValue(Station, Date, Type, Monitor) ->
  Station1 = getStation(Station, Monitor),
  [Measure] = getMeasure(Station1, Date, Type),
  Measure#measure.value.
%%%-------------------------------------------------------------------

getStationMean(Station, Type, Monitor) ->
  Station1 = getStation(Station, Monitor),
  Values = getValues(Station1, Type),
  calcMean(Values).
%%%-------------------------------------------------------------------

getDailyMean(Type, Day, Monitor) ->
  Values = getDayValues(Type, Day, Monitor),
  calcMean(Values).
%%%-------------------------------------------------------------------

getMinimumDistanceStations(Monitor) ->
  SC = [S#station.cords || S <- getStations(Monitor)],
  H = [{calcHaversine(A, B), A, B} || A <- SC, B <- SC, A /= B],
  hd(lists:sort(H)).
%%%-------------------------------------------------------------------

getSid({_, _} = Key, Monitor) -> maps:get(Key, Monitor#monitor.byCords);
getSid(_ = Key, Monitor) -> maps:get(Key, Monitor#monitor.byName).

getStation(Key, Monitor) -> maps:get(getSid(Key, Monitor), Monitor#monitor.stations).

checkTimeAndType(Measure, Date, Type) ->
  (Measure#measure.date =:= Date) and (Measure#measure.type =:= Type).

getMeasure(Station, Date, Type) ->
  [M || M <- Station#station.measures, checkTimeAndType(M, Date, Type)].

getValues(Station, Type) ->
  [V#measure.value || V <- Station#station.measures, V#measure.type =:= Type].

getDayValues(Type, Day, Monitor) ->
  [V#measure.value || SS <- getStations(Monitor), V <- SS#station.measures,
    (V#measure.type =:= Type) and (Day =:= getDay(V#measure.date))].

getStations(Monitor) ->
  [maps:get(S, Monitor#monitor.stations) || S <- lists:seq(0, Monitor#monitor.n - 1)].

getDay(Date) -> {Day, _} = Date, Day.

calcMean(Values) ->
  Fun = fun(A, B) -> A + B end,
  Sum = lists:foldl(Fun, 0, Values),
  Sum / length(Values).

%% based on: https://en.wikipedia.org/wiki/Haversine_formula
calcHaversine(A, B) ->
  Deg2Rad = fun(Deg) -> (math:pi() * Deg / 180) end,
  [X1, Y1, X2, Y2] = lists:map(Deg2Rad, tuple_to_list(A) ++ tuple_to_list(B)),

  DX = X2 - X1,
  DY = Y2 - Y1,
  D = math:pow(math:sin(DX / 2), 2) + math:cos(X1) * math:cos(X2) * math:pow(math:sin(DY / 2), 2),
  R = 2 * math:asin(math:sqrt(D)),

  Km = 6372.8 * R,
  Km. %%round(Km * 1000) / 1000.
%%%-------------------------------------------------------------------