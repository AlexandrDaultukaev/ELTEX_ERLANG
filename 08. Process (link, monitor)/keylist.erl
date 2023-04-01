-module(keylist).
-include("state.hrl").
-export([start/1, start_link/1, loop/1]).



% c("keylist.erl"). PidLinked = keylist:start_link(linked). erlang:send(PidLinked, {self(), add, "One", "Two", "Three"}).
% PidMonitor = keylist:start(monitored).
% PidLinked = keylist:start_link(linked).
% erlang:send(PidLinked, {self(), add, "One", "Two", "Three"}).
% erlang:is_process_alive(PidLinked).

loop(#state{list = List, counter = Counter} = State) ->
    receive
        {From, add, Key, Value, Comment} ->
            NewState = State#state{list = [{Key, Value, Comment} | List], counter = Counter + 1},
            From ! {ok, NewState},
            loop(NewState);
        {From, is_member, Key} ->
            RetVal = lists:keymember(Key, 1, List),
            NewState = State#state{list = List, counter = Counter + 1},
            From ! {ok, RetVal},
            loop(NewState);
        {From, take, Key} ->
            RetVal = lists:keytake(Key, 1, List),
            NewState = State#state{list = List, counter = Counter + 1},
            From ! {ok, RetVal},
            loop(NewState);
        {From, find, Key} ->
            RetVal = lists:keyfind(Key, 1, List),
            NewState = State#state{list = List, counter = Counter + 1},
            From ! {ok, RetVal},
            loop(NewState);
        {From, delete, Key} ->
            RetVal = lists:keydelete(Key, 1, List),
            NewState = State#state{list = RetVal, counter = Counter + 1},
            From ! {ok, RetVal},
            loop(NewState);
        Error ->
            io:format("Incorrect command: ~p~n", [Error]),
            % From ! {error, badarg},
            loop(State)
            % throw("Incorrect command")
    end.

start(Name) ->
    Pid = spawn(keylist, loop, [#state{}]),
    register(Name, Pid),
    Ref = erlang:monitor(process, Pid),
    {ok, Pid, Ref}.

start_link(Name) ->
    Pid = spawn_link(keylist, loop, [#state{}]),
    register(Name, Pid),
    Pid.