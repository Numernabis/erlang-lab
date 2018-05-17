%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. maj 2018 23:03
%%%-------------------------------------------------------------------
-module(pollution_gen_server).
-behaviour(gen_server).
-author("Ludwik Ciechański").

%% API
-export([init/1, start_link/0, handle_call/3, handle_cast/2]).
-export([start/0, stop/0, terminate/2, crash/0]).
-export([addStation/2, addValue/4, removeValue/3]).
-export([getOneValue/3, getStationMean/2, getDailyMean/2]).
-export([getMinimumDistanceStations/0]).
%%%-------------------------------------------------------------------

start_link() ->
  gen_server:start_link(
    {local, pgs},
    pollution_gen_server,
    empty, []
  ).

init(_) ->
  Monitor = pollution:createMonitor(),
  {ok, Monitor}.

start() -> start_link().
stop() -> gen_server:cast(pgs, stop).
%%%-------------------------------------------------------------------

addStation(Name, Cords) ->
  gen_server:call(pgs, {addStation, {Name, Cords}}).

addValue(Station, Date, Type, Value) ->
  gen_server:call(pgs, {addValue, {Station, Date, Type, Value}}).

removeValue(Station, Date, Type) ->
  gen_server:call(pgs, {removeValue, {Station, Date, Type}}).

getOneValue(Station, Date, Type) ->
  gen_server:call(pgs, {getOneValue, {Station, Date, Type}}).

getStationMean(Station, Type) ->
  gen_server:call(pgs, {getStationMean, {Station, Type}}).

getDailyMean(Type, Day) ->
  gen_server:call(pgs, {getDailyMean, {Type, Day}}).

getMinimumDistanceStations() ->
  gen_server:call(pgs, {getMinimumDistanceStations}).
%%%-------------------------------------------------------------------

handle_call({addStation, {Name, Cords}}, _From, State) ->
  NewState = pollution:addStation(Name, Cords, State),
  {reply, {Name, Cords}, NewState};

handle_call({addValue, {Station, Date, Type, Value}}, _From, State) ->
  NewState = pollution:addValue(Station, Date, Type, Value, State),
  {reply, {Station, Date, Type, Value}, NewState};

handle_call({removeValue, {Station, Date, Type}}, _From, State) ->
  NewState = pollution:removeValue(Station, Date, Type, State),
  {reply, {Station, Date, Type}, NewState};

handle_call({getOneValue, {Station, Date, Type}}, _From, State) ->
  OneValue = pollution:getOneValue(Station, Date, Type, State),
  {reply, {OneValue}, State};

handle_call({getStationMean, {Station, Type}}, _From, State) ->
  StationMean = pollution:getStationMean(Station, Type, State),
  {reply, {StationMean}, State};

handle_call({getDailyMean, {Type, Day}}, _From, State) ->
  DailyMean = pollution:getDailyMean(Type, Day, State),
  {reply, {DailyMean}, State};

handle_call({getMinimumDistanceStations}, _From, State) ->
  MinDistStation = pollution:getMinimumDistanceStations(State),
  {reply, {MinDistStation}, State}.
%%%-------------------------------------------------------------------

terminate(Reason, _Value) ->
  io:format("gen_server: terminate ~n"),
  Reason.

crash() -> gen_server:cast(pgs, crash).

handle_cast(stop, Value) ->
  {stop, normal, Value};

handle_cast(crash, State) ->
  1 / 0,
  {noreply, State}.
%%%-------------------------------------------------------------------
