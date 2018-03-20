%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. mar 2018 11:10
%%%-------------------------------------------------------------------
-module(myLists).
-author("Ludwik Ciechański").

%% API
-export([contains/2]).
-export([duplicateElements/1]).
-export([sumFloats/1]).
-export([sumFloats/2]).

contains([], _) -> false;
contains([H|_], H) -> true;
contains([_|T], V) -> contains(T, V).

duplicateElements([]) -> [];
duplicateElements([H|T]) -> [H, H | duplicateElements(T)].

sumFloats([]) -> 0.0;
sumFloats([H|T]) when is_float(H) -> H + sumFloats(T);
sumFloats([_|T]) -> sumFloats(T).

sumFloats([], A) -> A;
sumFloats([H|T], A) when is_float(H) -> sumFloats(T, A + H);
sumFloats([_|T], A) -> sumFloats(T, A).