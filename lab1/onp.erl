%%%-------------------------------------------------------------------
%%% @author Ludwik Ciechański
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. mar 2018 19:28
%%%-------------------------------------------------------------------
-module(onp).
-author("Ludwik Ciechański").

%% API
-export([onp/1, calculate/2]).

calculate(["+" | T], [A | [B | R]])   -> calculate(T, [B + A | R]);
calculate(["*" | T], [A | [B | R]])   -> calculate(T, [B * A | R]);
calculate(["/" | T], [A | [B | R]])   -> calculate(T, [B / A | R]);
calculate(["-" | T], [A | [B | R]])   -> calculate(T, [B - A | R]);
calculate([H | T], Stack)             -> calculate(T, [list_to_integer(H)] ++ Stack);
calculate([], [Result])               -> Result.

onp(Expr) -> calculate(string:tokens(Expr," "),[]).