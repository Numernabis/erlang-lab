%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. maj 2018 23:36
%%%-------------------------------------------------------------------
-module(pollution_server_supervisor).
-author("Ludwik Ciechański").

%% API
-export([start_link/1, init/1, start/0]).
%%%-------------------------------------------------------------------

start() -> start_link(empty).

start_link(_) ->
  supervisor:start_link(
    {local, server_supervisor},
    ?MODULE, []
  ).

init(_) ->
  {ok, {
    {one_for_all, 2, 3},
    [ {pgs, {pollution_gen_server, start, []},
      permanent, brutal_kill, worker,
      [pollution_gen_server]}
    ] }
  }.
%%%-------------------------------------------------------------------