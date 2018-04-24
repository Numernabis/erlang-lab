%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. kwi 2018 11:28
%%%-------------------------------------------------------------------
-module(pingpong).
-author("Ludwik Ciechański").

%% API
-export([start/0, stop/0, play/1]).

start() ->
  register(ping, spawn(fun() -> ping_loop() end)),
  register(pong, spawn(fun() -> pong_loop() end)).

ping_loop() ->
  receive
    0 -> ok;
    1 -> pong ! 0,
         io:format("Ping ~p~n", [1]);
    N -> io:format("Ping ~p~n", [N]),
         timer:sleep(500),
         pong ! (N - 1),
         ping_loop()
  end.

pong_loop() ->
  receive
    0 -> ok;
    1 -> ping ! 0,
         io:format("Pong ~p~n", [1]);
    N -> io:format("Pong ~p~n", [N]),
         timer:sleep(500),
         ping ! (N - 1),
         pong_loop()
  end.

stop() ->
  ping ! 0.

play(N) ->
  ping ! N.
