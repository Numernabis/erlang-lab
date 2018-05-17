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
-export([addStation/2]).
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

addStation(Name, Cords) -> gen_server:call(pgs, {addStation, {Name, Cords}}).


handle_call({addStation, {Name, Cords}}, _From, State) ->
  NewState = pollution:addStation(Name, Cords, State),
  io:format("addStation(~p, ~p) ~n", [Name, Cords]),
  {reply, {Name, Cords}, NewState}.


%%%-------------------------------------------------------------------
terminate(Reason, Value) ->
  io:format("server: exit ~p ~n", [Value]),
  Reason.

crash() -> gen_server:cast(pgs, crash).

handle_cast(stop, Value) ->
  {stop, normal, Value};

handle_cast(crash, State) ->
  Illegal = 1 / 0,
  {noreply, State}.
%%%-------------------------------------------------------------------
