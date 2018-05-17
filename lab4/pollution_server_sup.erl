%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. maj 2018 23:03
%%%-------------------------------------------------------------------
-module(pollution_server_sup).
-author("Ludwik Ciechański").

%% API
-export([start/0, init/0]).

start() -> spawn(?MODULE, init, []).

init() ->
  process_flag(trap_exit, true),
  loop().

loop() ->
  pollution_server:start(),
  receive
    {'EXIT', _P, _R} -> loop();
    stop -> ok
  end.
%%%-------------------------------------------------------------------
