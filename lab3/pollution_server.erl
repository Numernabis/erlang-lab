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
    %%% ...
    stop -> ok
  end.
%%%-------------------------------------------------------------------

addStation(Name, Cords) -> server ! {addStation, {Name, Cords}}.

addValue(Station, Date, Type, Value) -> server ! {addValue, {Station, Date, Type, Value}}.

removeValue(Station, Date, Type) -> server ! {removeValue, {Station, Date, Type}}.

getOneValue(Station, Date, Type) -> [].

getStationMean(Station, Type) -> [].

getDailyMean(Type, Day) -> [].

getMinimumDistanceStations() -> [].
%%%-------------------------------------------------------------------