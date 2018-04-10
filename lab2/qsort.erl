%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 09. kwi 2018 13:15
%%%-------------------------------------------------------------------
-module(qsort).
-author("Ludwik Ciechański").

%% API
-export([lessThan/2, grtEqThan/2, qs/1]).
-export([partition/4, qs2/1]).
-export([randomElem/3, compareSpeeds/3]).

lessThan(List, Arg) -> [X || X <- List, X < Arg].
grtEqThan(List, Arg) -> [X || X <- List, X >= Arg].

partition(_, [], L, G) -> {L, G};
partition(Arg, [H|T], L, G) ->
  if H < Arg -> partition(Arg, T, [H|L], G);
     H >= Arg -> partition(Arg, T, L, [H|G])
  end.

qs([]) -> [];
qs([Pivot|Tail]) -> qs( lessThan(Tail,Pivot) ) ++ [Pivot] ++ qs( grtEqThan(Tail,Pivot) ).

qs2([]) -> [];
qs2([Pivot|Tail]) ->
  {L, G} = partition(Pivot, Tail, [], []),
  qs2(L) ++ [Pivot] ++ qs(G).

%% functions for testing qsort
randomElem(N, Min, Max) -> [rand:uniform(Max - Min + 1) + (Min - 1) || _ <- lists:seq(1, N)].
compareSpeeds(List, Fun1, Fun2) ->
  {Time1, _} = timer:tc(Fun1, [List]),
  {Time2, _} = timer:tc(Fun2, [List]),
  io:format("Time of Fun1: ~p~n", [Time1]),
  io:format("Time of Fun2: ~p~n", [Time2]).

%% qsort:compareSpeeds(qsort:randomElem(100000, 2, 1000), fun qsort:qs/1, fun lists:sort/1).