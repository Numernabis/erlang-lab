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
-export([sumDigits/1]).

sumDigits(N) -> lists:foldl(fun (X, Acc) -> X + Acc end, 0, lists:map(fun (X) -> X - $0 end, integer_to_list(N))).
