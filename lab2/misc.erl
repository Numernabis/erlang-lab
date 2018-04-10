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
-export([randomElem/3]).
-export([map/2, filter/2]).

randomElem(N, Min, Max) -> [rand:uniform(Max - Min + 1) + (Min - 1) || _ <- lists:seq(1, N)].

map(_, []) -> [];
map(Fun, List) -> [Fun(X) || X <- List].

filter(_, []) -> [];
filter(Fun, List) -> [X || X <- List, Fun(X)].

%% version 1
%% sumDigits(N) -> lists:foldl(fun (X, Acc) -> X + Acc end, 0, lists:map(fun (X) -> X - $0 end, integer_to_list(N))).


