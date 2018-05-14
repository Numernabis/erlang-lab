%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. kwi 2018 21:18
%%%-------------------------------------------------------------------
-module(pollution_server_test).
-author("Ludwik Ciechański").
-include_lib("eunit/include/eunit.hrl").
%%%-------------------------------------------------------------------

start_test() ->
  State = pollution_server:start(),
  pollution_server:stop(),
  ?assertEqual(true, State).

stop_test() ->
  pollution_server:start(),
  State = pollution_server:stop(),
  ?assertEqual(stop, State).
%%%-------------------------------------------------------------------

addStation_test() ->
  pollution_server:start(),
  State = pollution_server:addStation("NH", {50.07, 20.03}),
  Expected = {addStation, {"NH", {50.07, 20.03}}},
  pollution_server:stop(),
  ?assertEqual(Expected, State).
%%%-------------------------------------------------------------------

addValue_test() ->
  DT = calendar:local_time(),
  pollution_server:start(),
  pollution_server:addStation("NH", {50.07, 20.03}),
  State = pollution_server:addValue({50.07, 20.03}, DT, pm10, 66),
  Expected = {addValue, {{50.07, 20.03}, DT, pm10, 66}},
  pollution_server:stop(),
  ?assertEqual(Expected, State).
%%%-------------------------------------------------------------------

removeValue_test() ->
  DT = calendar:local_time(),
  pollution_server:start(),
  pollution_server:addStation("NH", {50.07, 20.03}),
  pollution_server:addValue({50.07, 20.03}, DT, pm10, 66),
  State = pollution_server:removeValue("NH", DT, pm10),
  Expected = {removeValue, {"NH", DT, pm10}},
  pollution_server:stop(),
  ?assertEqual(Expected, State).
%%%-------------------------------------------------------------------

getOneValue_test() ->
  DT = calendar:local_time(),
  pollution_server:start(),
  pollution_server:addStation("NH", {50.07, 20.03}),
  pollution_server:addValue({50.07, 20.03}, DT, pm10, 42),
  State = pollution_server:getOneValue("NH", DT, pm10),
  Expected = {getOneValue, {"NH", DT, pm10}},
  pollution_server:stop(),
  ?assertEqual(Expected, State).
%%%-------------------------------------------------------------------

getStationMean_test() ->
  DT = calendar:local_time(),
  pollution_server:start(),
  pollution_server:addStation("NH", {50.07, 20.03}),
  pollution_server:addValue({50.07, 20.03}, DT, pm10, 66),
  pollution_server:addValue({50.07, 20.03}, {{2018, 4, 7}, {20, 00, 00}}, pm10, 22),
  State = pollution_server:getStationMean("NH", pm10),
  Expected = {getStationMean, {"NH", pm10}},
  pollution_server:stop(),
  ?assertEqual(Expected, State).
%%%-------------------------------------------------------------------

getDailyMean_test() ->
  DT = calendar:local_time(),
  pollution_server:start(),
  pollution_server:addStation("K1", {50.25, 20.1}),
  pollution_server:addStation("K2", {50.05, 19.8}),
  pollution_server:addValue("K1", DT, pm10, 50),
  pollution_server:addValue("K1", {{2018, 3, 3}, {08, 08, 00}}, pm10, 60),
  pollution_server:addValue("K2", DT, temp, 10),
  pollution_server:addValue("K2", {{2018, 3, 3}, {17, 17, 00}}, pm10, 10),
  State = pollution_server:getDailyMean(pm10, {2018, 3, 3}),
  Expected = {getDailyMean, {pm10, {2018, 3, 3}}},
  pollution_server:stop(),
  ?assertEqual(Expected, State).
%%%-------------------------------------------------------------------

getMinimumDistanceStations_test() ->
  pollution_server:start(),
  pollution_server:addStation("K1", {52, 20}),
  pollution_server:addStation("K2", {52, 18}),
  pollution_server:addStation("K3", {50, 10}),
  pollution_server:addStation("K4", {51, 20}),
  State = pollution_server:getMinimumDistanceStations(),
  io:format("~p~n", [State]),
  Expected = {getMinimumDistanceStations},
  pollution_server:stop(),
  ?assertEqual(Expected, State).
%%%-------------------------------------------------------------------