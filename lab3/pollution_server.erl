%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. kwi 2018 21:17
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("Ludwik Ciechański").

-export([
  start/0, stop/0, addStation/2, addValue/4, removeValue/3,
  getOneValue/3, getStationMean/2, getDailyMean/2,
  getMinimumDistanceStations/0
]).
%%%-------------------------------------------------------------------

start() -> register(server, spawn(fun() -> init() end)).

stop() -> server ! stop.

init() ->
  Monitor = pollution:createMonitor(),
  loop(Monitor).
%%%-------------------------------------------------------------------

loop(Monitor) ->
  receive
    {addStation, {Name, Cords}} ->
      Updated = pollution:addStation(Name, Cords, Monitor),
      loop(Updated);
    {addValue, {Station, Date, Type, Value}} ->
      Updated = pollution:addValue(Station, Date, Type, Value, Monitor),
      loop(Updated);
    {removeValue, {Station, Date, Type}} ->
      Updated = pollution:removeValue(Station, Date, Type, Monitor),
      loop(Updated);
    {getOneValue, {Station, Date, Type}} ->
      OneValue = pollution:getOneValue(Station, Date, Type, Monitor),
      io:format("server response:
        getOneValue(~w, ~w, ~w) = ~w~n", [Station, Date, Type, OneValue]),
      loop(Monitor);
    {getStationMean, {Station, Type}} ->
      StationMean = pollution:getStationMean(Station, Type, Monitor),
      io:format("server response:
        getStationMean(~w, ~w) = ~w~n", [Station, Type, StationMean]),
      loop(Monitor);
    {getDailyMean, {Station, Type}} ->
      DailyMean = pollution:getDailyMean(Station, Type, Monitor),
      io:format("server response:
        getDailyMean(~w, ~w) = ~w~n", [Station, Type, DailyMean]),
      loop(Monitor);
    {getMinimumDistanceStations} ->
      MinDistStations = pollution:getMinimumDistanceStations(Monitor),
      io:format("server response:
        getMinimumDistanceStations() = ~w~n", [MinDistStations]),
      loop(Monitor);
    stop -> ok
  end.
%%%-------------------------------------------------------------------

addStation(Name, Cords) -> server ! {addStation, {Name, Cords}}.

addValue(Station, Date, Type, Value) -> server ! {addValue, {Station, Date, Type, Value}}.

removeValue(Station, Date, Type) -> server ! {removeValue, {Station, Date, Type}}.

getOneValue(Station, Date, Type) -> server ! {getOneValue, {Station, Date, Type}}.

getStationMean(Station, Type) -> server ! {getStationMean, {Station, Type}}.

getDailyMean(Type, Day) -> server ! {getDailyMean, {Type, Day}}.

getMinimumDistanceStations() -> server ! {getMinimumDistanceStations}.
%%%-------------------------------------------------------------------