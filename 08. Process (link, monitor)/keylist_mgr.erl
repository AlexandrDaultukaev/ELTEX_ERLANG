-module(keylist_mgr).
-include("state_ch.hrl").
-export([loop/1, start/0, init/1]).

% start() ->
%     Pid = spawn(?MODULE, loop, [#state_ch{}]),
%     MonitorRef = erlang:monitor(process, Pid),
%     register(?MODULE, Pid),
%     process_flag(trap_exit, true),
%     {ok, Pid, MonitorRef}.

start() ->
    {Pid, MonitorRef} = spawn_monitor(?MODULE, init, [#{name => ?MODULE}]),
    {ok, Pid, MonitorRef}.

init(#{name := Name}) ->
    register(Name, self()),
    process_flag(trap_exit, true),
    loop(#state_ch{}).

loop(#state_ch{children = Children} = State) ->
        process_flag(trap_exit, true),
    receive

        {From, start_child, Name} ->
            case proplists:is_defined(Name, Children) of
                true ->
                    erlang:send(From, [{badarg, name_already_defined}]),
                    loop(State);
                false ->
                    Pid = keylist:start_link(Name),
                    erlang:send(From, [{ok, Pid}]),
                    loop(State#state_ch{children = Children ++ [{Name, Pid}]})
            end;

        {From, stop_child, Name} ->
            case proplists:is_defined(Name, Children) of
                true ->
                    Pid = element(2, proplists:lookup(Name, Children)),
                    exit(Pid, stop),
                    erlang:send(From, [{ok, Pid}]),
                    loop(State#state_ch{children = proplists:delete(Name, Children)});
                false ->
                    erlang:send(From, [{badarg, name_already_defined}]),
                    loop(State)
            end;
        
        stop ->
            exit(stop);

        {From, get_names} ->
            erlang:send(From, [proplists:get_keys(Children)]),
            loop(State);
        
        {'EXIT', Pid, Reason} ->
            io:format("EXIT(~p): ~p~n", [Pid, Reason]),
            loop(State#state_ch{children = lists:keydelete(Pid, 2, Children)})
    end.