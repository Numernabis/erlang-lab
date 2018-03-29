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

calculate(["+" | T], [A | [B | R]]) -> calculate(T, [B + A | R]);
calculate(["*" | T], [A | [B | R]]) -> calculate(T, [B * A | R]);
calculate(["/" | T], [A | [B | R]]) -> calculate(T, [B / A | R]);
calculate(["-" | T], [A | [B | R]]) -> calculate(T, [B - A | R]);
calculate(["p" | T], [A | [B | R]]) -> calculate(T, [math:pow(B,A) | R]);
calculate(["q" | T], [A | R])       -> calculate(T, [math:sqrt(A) | R]);
calculate(["c" | T], [A | R])       -> calculate(T, [math:cos(A) | R]);
calculate(["s" | T], [A | R])       -> calculate(T, [math:sin(A) | R]);
calculate(["t" | T], [A | R])       -> calculate(T, [math:tan(A) | R]);
calculate([H | T], S)               -> calculate(T, [list_to_integer(H)] ++ S);
calculate([], [Result])             -> Result.

onp(Expr) -> calculate(string:tokens(Expr," "),[]).