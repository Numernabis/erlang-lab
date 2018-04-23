%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. kwi 2018 11:36
%%%-------------------------------------------------------------------
-module(pollution_test).
-author("Ludwik Ciechański").
-include_lib("eunit/include/eunit.hrl").
%%%-------------------------------------------------------------------

createMonitor_test() ->
  ?assertEqual({monitor, #{}, #{}, #{}, 0}, pollution:createMonitor()).
%%%-------------------------------------------------------------------

addStation_test() ->
  M1 = pollution:createMonitor(),
  M2 = pollution:addStation("NH", {50.07, 20.03}, M1),
  Expected = {monitor, #{"NH" => 0}, #{{50.07, 20.03} => 0},
    #{0 => {station, 0, "NH", {50.07, 20.03}, []}}, 1},
  ?assertEqual(Expected, M2),

  M3 = pollution:addStation("A", {50.07, 20.03}, M2),
  Err = {error, "Station already exists!"},
  ?assertEqual(Err, M3).
%%%-------------------------------------------------------------------

addValue_test() ->
  DT = calendar:local_time(),
  M1 = pollution:createMonitor(),
  M2 = pollution:addStation("NH", {50.07, 20.03}, M1),
  M3 = pollution:addValue({50.07, 20.03}, DT, pm10, 66, M2),
  Expected = {monitor, #{"NH" => 0}, #{{50.07, 20.03} => 0},
    #{0 => {station, 0, "NH", {50.07, 20.03}, [{measure, DT, pm10, 66}]}}, 1},
  ?assertEqual(Expected, M3),

  M4 = pollution:addValue({50.07, 20.03}, DT, pm10, 144, M3),
  Err = {error, "Such measure already exists!"},
  ?assertEqual(Err, M4).
%%%-------------------------------------------------------------------

removeValue_test() ->
  DT = calendar:local_time(),
  M1 = pollution:createMonitor(),
  M2 = pollution:addStation("NH", {50.07, 20.03}, M1),
  M3 = pollution:addValue({50.07, 20.03}, DT, pm10, 66, M2),
  M4 = pollution:removeValue("NH", DT, pm10, M3),
  Expected = {monitor, #{"NH" => 0}, #{{50.07, 20.03} => 0},
    #{0 => {station, 0, "NH", {50.07, 20.03}, []}}, 1},
  ?assertEqual(Expected, M4).
%%%-------------------------------------------------------------------

getOneValue_test() ->
  DT = calendar:local_time(),
  M1 = pollution:createMonitor(),
  M2 = pollution:addStation("NH", {50.07, 20.03}, M1),
  M3 = pollution:addValue({50.07, 20.03}, DT, pm10, 42, M2),
  M4 = pollution:getOneValue("NH", DT, pm10, M3),
  Expected = 42,
  ?assertEqual(Expected, M4).
%%%-------------------------------------------------------------------

getStationMean_test() ->
  DT = calendar:local_time(),
  M1 = pollution:createMonitor(),
  M2 = pollution:addStation("NH", {50.07, 20.03}, M1),
  M3 = pollution:addValue({50.07, 20.03}, DT, pm10, 66, M2),
  M4 = pollution:addValue({50.07, 20.03}, {{2018, 4, 7}, {20, 00, 00}}, pm10, 22, M3),
  M5 = pollution:getStationMean("NH", pm10, M4),
  Expected = 44.0,
  ?assertEqual(Expected, M5).
%%%-------------------------------------------------------------------

getDailyMean_test() ->
  DT = calendar:local_time(),
  M1 = pollution:createMonitor(),
  M2 = pollution:addStation("K1", {50.25, 20.1}, M1),
  M3 = pollution:addStation("K2", {50.05, 19.8}, M2),
  M4 = pollution:addValue("K1", DT, pm10, 50, M3),
  M5 = pollution:addValue("K1", {{2018, 3, 3}, {08, 08, 00}}, pm10, 60, M4),
  M6 = pollution:addValue("K2", DT, temp, 10, M5),
  M7 = pollution:addValue("K2", {{2018, 3, 3}, {17, 17, 00}}, pm10, 10, M6),
  M8 = pollution:getDailyMean(pm10, {2018, 3, 3}, M7),
  Expected = 35.0,
  ?assertEqual(Expected, M8).
%%%-------------------------------------------------------------------

getMinimumDistanceStations_test() ->
  M1 = pollution:createMonitor(),
  M2 = pollution:addStation("K1", {52, 20}, M1),
  M3 = pollution:addStation("K2", {52, 18}, M2),
  M4 = pollution:addStation("K3", {50, 10}, M3),
  M5 = pollution:addStation("K4", {51, 20}, M4),
  M6 = pollution:getMinimumDistanceStations(M5),
  io:format("~p~n", [M6]),
  Expected = [{111.2263425710955,{51,20},{52,20}}],
  ?assertEqual(Expected, [M6]).
%%%-------------------------------------------------------------------