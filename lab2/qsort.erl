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
-export([randomElems/3, compareSpeeds/3]).

lessThan(List, Arg) -> [].
grtEqThan(List, Arg) -> [].

qs([Pivot|Tail]) -> qs( lessThan(Tail,Pivot) ) ++ [Pivot] ++ qs( grtEqThan(Tail,Pivot) ).

%% functions for testing qsort
randomElems(N,Min,Max)-> [].
compareSpeeds(List, Fun1, Fun2) -> [].