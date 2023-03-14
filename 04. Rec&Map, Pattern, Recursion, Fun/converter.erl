-module(converter).

-include("conv_info.hrl").

-export([rec_to_rub/1, map_to_rub/1]).

rec_to_rub(#conv_info{type = usd, amount = Amount, commission = Commission}) when is_integer(Amount), Amount > 0 ->
    {ok, Amount*75.5 - (Amount*Commission)};
rec_to_rub(#conv_info{type = euro, amount = Amount, commission = Commission}) when is_integer(Amount), Amount > 0 ->
    {ok, Amount*80 - (Amount*Commission)};
rec_to_rub(#conv_info{type = lari, amount = Amount, commission = Commission}) when is_integer(Amount), Amount > 0 ->
    {ok, Amount*29 - (Amount*Commission)};
rec_to_rub(#conv_info{type = peso, amount = Amount, commission = Commission}) when is_integer(Amount), Amount > 0 ->
    {ok, Amount*3 - (Amount*Commission)};
rec_to_rub(#conv_info{type = krone, amount = Amount, commission = Commission}) when is_integer(Amount), Amount > 0 ->
    {ok, Amount*10 - (Amount*Commission)};
rec_to_rub(Error) ->
    io:format("Bad argument ~p~n",[Error]),
    {error, badarg}.


map_to_rub(#{type := usd, amount := Amount, commission := Commission}) when is_integer(Amount), Amount > 0 ->
    {ok, Amount*75.5 - (Amount*Commission)};
map_to_rub(#{type := euro, amount := Amount, commission := Commission}) when is_integer(Amount), Amount > 0 ->
    {ok, Amount*80 - (Amount*Commission)};
map_to_rub(#{type := lari, amount := Amount, commission := Commission}) when is_integer(Amount), Amount > 0 ->
   {ok, Amount*29 - (Amount*Commission)};
map_to_rub(#{type := peso, amount := Amount, commission := Commission}) when is_integer(Amount), Amount > 0 ->
    {ok, Amount*3 - (Amount*Commission)};
map_to_rub(#{type := krone, amount := Amount, commission := Commission}) when is_integer(Amount), Amount > 0 ->
    {ok, Amount*10 - (Amount*Commission)};
map_to_rub(Error) ->
    io:format("Bad argument ~p~n",[Error]),
    {error, badarg}.