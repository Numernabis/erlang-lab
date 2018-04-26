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
    {} -> [];
    stop -> ok
  end.
%%%-------------------------------------------------------------------