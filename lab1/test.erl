%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. mar 2018 22:54
%%%-------------------------------------------------------------------
-module(test).
-author("Ludwik Ciechański").

%% API
-export([power/2]).

power(A,0) -> 1;
power(A,B) -> A * power(A,B-1).
