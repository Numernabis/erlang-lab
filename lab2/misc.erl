%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. kwi 2018 12:37
%%%-------------------------------------------------------------------
-module(misc).
-author("Ludwik Ciechański").

%% API
-export([map/2, filter/2]).
-export([sumDigits/1, splitNum/1]).
-export([randomElem/3, sumDigDiv3/0]).

randomElem(N, Min, Max) -> [rand:uniform(Max - Min + 1) + (Min - 1) || _ <- lists:seq(1, N)].

map(_, []) -> [];
map(Fun, List) -> [Fun(X) || X <- List].

filter(_, []) -> [];
filter(Fun, List) -> [X || X <- List, Fun(X)].

%% version 1
%% sumDigits(N) -> lists:foldl(fun (X, Acc) -> X + Acc end, 0, lists:map(fun (X) -> X - $0 end, integer_to_list(N))).

%% version 2
splitNum(0) -> [];
splitNum(N) -> splitNum(N div 10) ++ [N rem 10].
sumDigits(N) -> lists:foldl(fun (X, Acc) -> X + Acc end, 0, splitNum(N)).

%% filter 1M list, choose only numbers which sumDigits is divisible by 3.
sumDigDiv3() -> lists:filter(fun (X) -> sumDigits(X) rem 3 == 0 end, randomElem(1000000, 1, 999999)).