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
-export([onp/1, calculate/2, strnum/1]).

%% to_float(String) -> {Float, Rest} | {error, Reason}
strnum(Input) ->
  case string:to_float(Input) of
    {error, no_float} -> list_to_integer(Input);
    {Float, _Rest} -> Float
  end.

calculate(["+" | T], [A | [B | R]]) -> calculate(T, [B + A | R]);
calculate(["-" | T], [A | [B | R]]) -> calculate(T, [B - A | R]);
calculate(["*" | T], [A | [B | R]]) -> calculate(T, [B * A | R]);
calculate(["/" | T], [A | [B | R]]) -> calculate(T, [B / A | R]);
calculate(["p" | T], [A | [B | R]]) -> calculate(T, [math:pow(B,A) | R]);
calculate(["q" | T], [A | R])       -> calculate(T, [math:sqrt(A) | R]);
calculate(["c" | T], [A | R])       -> calculate(T, [math:cos(A) | R]);
calculate(["s" | T], [A | R])       -> calculate(T, [math:sin(A) | R]);
calculate(["t" | T], [A | R])       -> calculate(T, [math:tan(A) | R]);
calculate([H | T], S)               -> calculate(T, [strnum(H)] ++ S);
calculate([], [Result])             -> Result.

onp(Input) -> calculate(string:tokens(Input," "),[]).