-module(recursion).
-export([fac/1, fac/2, duplicate/1, tail_duplicate/1]).

fac(N) when is_integer(N) ->
    fac(N, 1);
fac(Error) ->
    io:format("Error argument ~p~n", [Error]).

fac(N, Acc) when N =:= 0 -> Acc;
fac(N, Acc) when N > 0 ->
    fac(N-1, Acc*N).

duplicate([]) ->
    [];
duplicate([Head | Tail]) ->
    [Head, Head] ++ duplicate(Tail);
duplicate(Error) ->
    io:format("Error argument ~p~n", [Error]),
    {error, badarg}.

tail_duplicate([]) -> [];
tail_duplicate([Head|Tail]) ->
    tail_duplicate([Head|Tail],[]);
tail_duplicate(Error) ->
    io:format("Error argument ~p~n",[Error]),
    {error, badarg}.

tail_duplicate([],Acc) -> lists:reverse(Acc);
tail_duplicate([Head|Tail],Acc) ->
    tail_duplicate(Tail,[Head,Head|Acc]).